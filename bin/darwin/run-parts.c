/* run-parts: run a bunch of scripts in a directory
 *
 * Debian run-parts program
 * Copyright (C) 1996 Jeff Noxon <jeff@router.patch.net>,
 * Copyright (C) 1996-1999 Guy Maor <maor@debian.org>
 *
 * This is free software; see the GNU General Public License version 2
 * or later for copying conditions.  There is NO warranty.
 *
 * Based on run-parts.pl version 0.2, Copyright (C) 1994 Ian Jackson.
 *
 */

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <getopt.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <signal.h>
#include <sys/time.h>
#include <regex.h>

int test_mode = 0;
int list_mode = 0;
int verbose_mode = 0;
int report_mode = 0;
int reverse_mode = 0;
int exitstatus = 0;
int lsbsysinit_mode = 0;
int exit_on_error_mode = 0;

int argcount = 0, argsize = 0;
char **args = 0;

void error(char *format, ...)
{
  va_list ap;

  fprintf(stderr, "run-parts: ");

  va_start(ap, format);
  vfprintf(stderr, format, ap);
  va_end(ap);

  fprintf(stderr, "\n");
}


void version()
{
  fprintf(stderr, "Debian run-parts program, version 1.0"
	  "\nCopyright (C) 1994 Ian Jackson, Copyright (C) 1996 Jeff Noxon.\n"
	  "Copyright (C) 1996,1997,1998,1999 Guy Maor\n"
	  "Copyright (C) 2002, 2003, 2004 Clint Adams\n"
	  "This is free software; see the GNU General Public License version 2\n"
	  "or later for copying conditions.  There is NO warranty.\n");
  exit(0);
}


void usage()
{
  fprintf(stderr, "Usage: run-parts [OPTION]... DIRECTORY\n"
	  "      --test          print script names which would run, but don't run them.\n"
	  "      --list          print names of all valid files (can not be used with\n"
	  "                      --test)\n"
	  "  -v, --verbose       print script names before running them.\n"
	  "      --report        print script names if they produce output.\n"
	  "      --reverse       reverse execution order of scripts.\n"
	  "      --exit-on-error exit as soon as a script returns with a non-zero exit\n"
	  "                      code.\n"
	  "      --lsbsysinit    validate filenames based on LSB sysinit specs.\n"
	  "  -u, --umask=UMASK   sets umask to UMASK (octal), default is 022.\n"
	  "  -a, --arg=ARGUMENT  pass ARGUMENT to scripts, use once for each argument.\n"
	  "  -V, --version       output version information and exit.\n"
	  "  -h, --help          display this help and exit.\n");
  exit(0);
}


/* The octal conversion in libc is not foolproof; it will take the 8 and 9
 * digits under some circumstances.  We'll just have to live with it.
 */
void set_umask()
{
  int mask, result;

  result = sscanf(optarg, "%o", &mask);
  if ((result != 1) || (mask > 07777) || (mask < 0)) {
    error("bad umask value");
    exit(1);
  }

  umask(mask);
}

/* Add an argument to the commands that we will call.  Called once for
   every argument. */
void add_argument(char *newarg)
{
  if (argcount + 1 >= argsize) {
    argsize = argsize ? argsize * 2 : 4;
    args = realloc(args, argsize * (sizeof(char *)));
    if (!args) {
      error("failed to reallocate memory for arguments: %s", strerror(errno));
      exit(1);
    }
  }
  args[argcount++] = newarg;
  args[argcount] = 0;
}

/* True or false? Is this a valid filename? */
int valid_name(const struct dirent *d)
{
  char *c = d->d_name;
  regex_t hierre, tradre, excsre, classicalre;

  /* The regcomps should be moved to program init */

  if (lsbsysinit_mode) {

    if (regcomp
	(&hierre, "^_?([a-z0-9_.]+-)+[a-z0-9]+$", REG_EXTENDED | REG_NOSUB)
	|| regcomp(&excsre, "^[a-z0-9-].*dpkg-(old|dist)$",
		   REG_EXTENDED | REG_NOSUB)
	|| regcomp(&tradre, "^[a-z0-9][a-z0-9-]*$", REG_NOSUB)) {
      error("regex failure");
      exit(1);
    }

    if (!regexec(&hierre, c, 0, NULL, 0))
      return regexec(&excsre, c, 0, NULL, 0);

    return !regexec(&tradre, c, 0, NULL, 0);
  }
  else {
    if (regcomp(&classicalre, "^[a-zA-Z0-9_-]+$", REG_EXTENDED | REG_NOSUB)) {
      error("regex failure");
      exit(1);
    }
    return !regexec(&classicalre, c, 0, NULL, 0);
  }

}


void set_fl(int fd, int flags)
{
  int val;
  if ((val = fcntl(fd, F_GETFL, 0)) < 0) {
    error("fcntl F_GETFL: %s", strerror(errno));
    exit(1);
  }
  val |= flags;
  if (fcntl(fd, F_SETFL, val) < 0) {
    error("fcntl F_SETFL: %s", strerror(errno));
    exit(1);
  }
}


/* We have to abort the select() call in run_part when we receive a
 * SIGCHLD signal. We can't simply ignore it, so we do nothing.
 */

/* itz Tue Nov 26 13:23:27 PST 2002 why "We have to abort?"
   just leave the default and reap child at the end
 */
void catch_sigchld(int sig)
{
}


/* Execute a file */
void run_part(char *progname)
{
  int result;
  int pid;
  int pout[2], perr[2];

  if (report_mode && (pipe(pout) || pipe(perr))) {
    error("pipe: %s", strerror(errno));
    exit(1);
  }
  if ((pid = fork()) < 0) {
    error("failed to fork: %s", strerror(errno));
    exit(1);
  }
  else if (!pid) {
    setsid();
    if (report_mode) {
      if (dup2(pout[1], STDOUT_FILENO) == -1 ||
	  dup2(perr[1], STDERR_FILENO) == -1) {
	error("dup2: %s", strerror(errno));
	exit(1);
      }
      close(pout[0]);
      close(perr[0]);
      close(pout[1]);
      close(perr[1]);
    }
    args[0] = progname;
    execv(progname, args);
    error("failed to exec %s: %s", progname, strerror(errno));
    exit(1);
  }

  if (report_mode) {
    fd_set set;
    int max, r, printflag;
    ssize_t c;
    char buf[4096];

    close(pout[1]);
    close(perr[1]);
    /* itz Tue Nov 26 13:26:09 PST 2002 why is this necessary? */
    /*     set_fl(pout[0], O_NONBLOCK); */
    /*     set_fl(perr[0], O_NONBLOCK); */
    max = pout[0] > perr[0] ? pout[0] + 1 : perr[0] + 1;
    printflag = 0;

    while (pout[0] >= 0 || perr[0] >= 0) {

      FD_ZERO(&set);
      if (pout[0] >= 0)
	FD_SET(pout[0], &set);
      if (perr[0] >= 0)
	FD_SET(perr[0], &set);
      r = select(max, &set, 0, 0, 0);
      while (r < 0 && errno == EINTR) {
	FD_ZERO(&set);
	if (pout[0] >= 0)
	  FD_SET(pout[0], &set);
	if (perr[0] >= 0)
	  FD_SET(perr[0], &set);
	r = select(max, &set, 0, 0, 0);
      }				/*while */

      if (r < 0) {
	/* assert(errno != EINTR) */
	error("select: %s", strerror(errno));
	exit(1);
      }
      else if (r > 0) {
	if (pout[0] >= 0 && FD_ISSET(pout[0], &set)) {
	  c = read(pout[0], buf, sizeof(buf));
	  if (c > 0) {
	    if (!printflag) {
	      printf("%s:\n", progname);
	      fflush(stdout);
	      printflag = 1;
	    }
	    write(STDOUT_FILENO, buf, c);
	  }
	  else if (c == 0) {
	    close(pout[0]);
	    pout[0] = -1;
	  }
	}
	if (perr[0] >= 0 && FD_ISSET(perr[0], &set)) {
	  c = read(perr[0], buf, sizeof(buf));
	  if (c > 0) {
	    if (!printflag) {
	      fprintf(stderr, "%s:\n", progname);
	      fflush(stderr);
	      printflag = 1;
	    }
	    write(STDERR_FILENO, buf, c);
	  }
	  else if (c == 0) {
	    close(perr[0]);
	    perr[0] = -1;
	  }
	}
      }
      else {
	/* assert(FALSE): select was called with infinite timeout, so
	   it either returns successfully or is interrupted */
      }				/*if */
    }				/*while */
  }

  waitpid(pid, &result, 0);

  if (WIFEXITED(result) && WEXITSTATUS(result)) {
    error("%s exited with return code %d", progname, WEXITSTATUS(result));
    exitstatus = 1;
  }
  else if (WIFSIGNALED(result)) {
    error("%s exited because of uncaught signal %d", progname,
	  WTERMSIG(result));
    exitstatus = 1;
  }
}


/* Find the parts to run & call run_part() */
void run_parts(char *dirname)
{
  struct dirent **namelist;
  char *filename;
  size_t filename_length, dirname_length;
  int entries, i, result;
  struct stat st;

  /* dirname + "/" */
  dirname_length = strlen(dirname) + 1;
  /* dirname + "/" + ".." + "\0" (This will save one realloc.) */
  filename_length = dirname_length + 2 + 1;
  if (!(filename = malloc(filename_length))) {
    error("failed to allocate memory for path: %s", strerror(errno));
    exit(1);
  }
  strcpy(filename, dirname);
  strcat(filename, "/");

  /* scandir() isn't POSIX, but it makes things easy. */
  entries = scandir(dirname, &namelist, valid_name, alphasort);
  if (entries < 0) {
    error("failed to open directory %s: %s", dirname, strerror(errno));
    exit(1);
  }

  i = reverse_mode ? 0 : entries;
  for (i = reverse_mode ? (entries - 1) : 0;
       reverse_mode ? (i >= 0) : (i < entries); reverse_mode ? i-- : i++) {
    if (filename_length < dirname_length + strlen(namelist[i]->d_name) + 1) {
      filename_length = dirname_length + strlen(namelist[i]->d_name) + 1;
      if (!(filename = realloc(filename, filename_length))) {
	error("failed to reallocate memory for path: %s", strerror(errno));
	exit(1);
      }
    }
    strcpy(filename + dirname_length, namelist[i]->d_name);

    strcpy(filename, dirname);
    strcat(filename, "/");
    strcat(filename, namelist[i]->d_name);

    result = lstat(filename, &st);
    if (result < 0) {
      if (exit_on_error_mode) {
        error("failed to lstat component %s: %s", filename, strerror(errno));
        exit(1);
      }
      else
	return;
    }

    if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
      if (!access(filename, X_OK)) {
	if (test_mode) {
	  printf("%s\n", filename);
	}
	else if (list_mode) {
	  if (!access(filename, R_OK))
	    printf("%s\n", filename);
	}
	else {
	  if (verbose_mode)
	    fprintf(stderr, "run-parts: executing %s\n", filename);
	  run_part(filename);
	  if (exitstatus != 0 && exit_on_error_mode) return;
	}
      }
      else if (!access(filename, R_OK)) {
	if (list_mode) {
	  printf("%s\n", filename);
	}
      }
      else if (S_ISLNK(st.st_mode)) {
	if (!list_mode) {
	  printf("run-parts: component %s is a broken symbolic link\n",filename);
	  exitstatus = 1;
	}
      }
    }
    else if (!S_ISDIR(st.st_mode)) {
      if (!list_mode) {
	printf("run-parts: component %s is not an executable plain file\n",
	       filename);
	exitstatus = 1;
      }
    }

    free(namelist[i]);
  }
  free(namelist);
  free(filename);
}

/* Process options */
int main(int argc, char *argv[])
{
  umask(022);
  add_argument(0);

  for (;;) {
    int c;
    int option_index = 0;

    static struct option long_options[] = {
      {"test", 0, &test_mode, 1},
      {"list", 0, &list_mode, 1},
      {"verbose", 0, 0, 'v'},
      {"report", 0, &report_mode, 1},
      {"reverse", 0, &reverse_mode, 1},
      {"umask", 1, 0, 'u'},
      {"arg", 1, 0, 'a'},
      {"help", 0, 0, 'h'},
      {"version", 0, 0, 'V'},
      {"lsbsysinit", 0, &lsbsysinit_mode, 1},
      {"exit-on-error", 0, &exit_on_error_mode, 1},
      {0, 0, 0, 0}
    };

    c = getopt_long(argc, argv, "u:ha:vV", long_options, &option_index);
    if (c == EOF)
      break;
    switch (c) {
    case 0:
      break;
    case 'u':
      set_umask();
      break;
    case 'a':
      add_argument(optarg);
      break;
    case 'h':
      usage();
      break;
    case 'v':
      verbose_mode = 1;
      break;
    case 'V':
      version();
      break;
    default:
      fprintf(stderr, "Try `run-parts --help' for more information.\n");
      exit(1);
    }
  }

  /* We require exactly one argument: the directory name */
  if (optind != (argc - 1)) {
    error("missing operand");
    fprintf(stderr, "Try run-parts --help' for more information.\n");
    exit(1);
  }

  if (list_mode && test_mode) {
    error("--list and --test can not be used together");
    fprintf(stderr, "Try run-parts --help' for more information.\n");
    exit(1);
  }

  run_parts(argv[optind]);

  return exitstatus;
}
