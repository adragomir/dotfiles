#!/usr/bin/ruby

# == Synopsis
#
# hello: greets user, demonstrates command line parsing
#
# == Usage
#
# hello [OPTION] ... DIR
#
# -h, --help:
#    show help
#
# --repeat x, -n x:
#    repeat x times
#
# --name [name]:
#    greet user by name, if name not supplied default is John
#
# DIR: The directory in which to issue the greeting.

require 'pathname'
require 'fileutils'
require 'getoptlong'
require 'rdoc/usage'

PROJECT_DIR =".code_database" 
PROJECT_FILE=".code_database/.project"

class CodeDatabaseBuilder
  def initialize(path)
    @cscope = get_cscope_location
    @ctags = get_ctags_location
    @path = Pathname.new(path)
    @name = @path.basename
  end

  def run()
    read_config
    create_file_list
    exec
  end

  def exec()

    Dir.chdir(@path) {

      puts "Cleaning old files ..."
      `rm "#{PROJECT_DIR}/#{@name}_tags" "#{PROJECT_DIR}/cscope.in.out" "#{PROJECT_DIR}/cscope.out" "#{PROJECT_DIR}/cscope.po.out"`
      puts "Building #{@name} ctags database..."
      `#{@ctags} -L "#{PROJECT_DIR}/#{@name}.files" --language-force=#{@language} -f "#{PROJECT_DIR}/#{@name}_tags" --c++-kinds=+p --fields=+iaS --extra=+q`
      puts "Building #{@name} cscope database..." 
      `#{@cscope} -b -q -i "#{PROJECT_DIR}/#{@name}.files" -k -l`
      `mv cscope.in.out #{PROJECT_DIR}/`
      `mv cscope.po.out #{PROJECT_DIR}/`
      `mv cscope.out #{PROJECT_DIR}/`
      #`rm "#{PROJECT_DIR}/#{@name}.files"`
    }

    File.open(Pathname.new(@path) + "#{@name}.vim", "wb+") { |f|
      f.write(<<EOT
set tags-=#{@path}/#{PROJECT_DIR}/#{@name}_tags
set tags+=#{@path}/#{PROJECT_DIR}/#{@name}_tags
cscope add #{@path}/#{PROJECT_DIR}/cscope.out
EOT
)
    }

  end

  def read_config()
    File.open(Pathname.new(@path) + PROJECT_FILE, "rb+") { |f|
      content = f.read()
      includes = []
      excludes = []
      language = ""
      eval(content)
      print includes
      @language = language
      @includes = includes
      @excludes = excludes
    }
  end
  def create_file_list()
    file_list = []
    @includes.each { |i|
      puts "include: #{i}"
      tmp = Dir.glob("#{i}")
      file_list.push(tmp)
    }
    file_list.flatten!

    @excludes.each do |e|
      puts e 
      file_list = file_list.reject { |f|
        case e
        when Regexp
          f =~ e
        when String
          f.index(e) >= 0
        else
          false
        end
      }
    end
    file_list = file_list.collect{|i| File.expand_path(i) }
    File.open(@path + Pathname.new("#{PROJECT_DIR}/#{@name}.files"), "wb+") { |f|
      f.write(file_list.join("\n"));
    }
  end

  def get_cscope_location()
    'cscope'
  end

  def get_ctags_location()
    os = `uname`
    if os.strip() == 'Darwin'
      ctags = '/opt/local/bin/ctags'
    else 
      ctags = 'ctags'
    end
    ctags
  end

end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--vim', '-v', GetoptLong::NO_ARGUMENT ]
)
do_vim = false
opts.each do |opt, arg|
  case opt
    when '--help'
      RDoc::usage
    when '--vim'
      do_vim = true
  end
end

cb = CodeDatabaseBuilder.new(File.expand_path('.'))
cb.run()
