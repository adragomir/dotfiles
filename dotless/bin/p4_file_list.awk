BEGIN {
	clientFile=""
	action=""
	fast=ENVIRON["fast"]
	if (fast) {
		show_added=ENVIRON["show_added"]
		show_branched=ENVIRON["show_branched"]
		show_deleted=ENVIRON["show_deleted"]
		show_edited=ENVIRON["show_edited"]
		show_integrated=ENVIRON["show_integrated"]
		show_not_modified=0
		show_unknown=0
	} else {
		show_added=0
		show_branched=0
		show_deleted=0
		show_edited=0
		show_integrated=0
		show_not_modified=ENVIRON["show_not_modified"]
		show_unknown=ENVIRON["show_unknown"]
	}
	full_path=ENVIRON["full_path"]
	quiet=ENVIRON["quiet"]
	dir=ENVIRON["dir"]
	dir_length=length(dir)
}

function print_file(type,filename) {
	if (filename != "") {
		if (!quiet) printf "%s: ", type
		printf "%s\n", filename
	}
}

function get_path(filename) {
	if (full_path) {
		return filename
	} else {
		return substr(filename,dir_length+2)
	}
}

function check_not_modified() {
	if (action == "" && clientFile != "") {
		if (show_not_modified) print_file("N",clientFile)
	}
}

$1 == "..." && $2 == "clientFile" {
	printf "action: %s\n", $2
	check_not_modified()

	if (index($3,dir) == 1) {
		clientFile=get_path(substr($0,index($0,$3)))
	} else {
		clientFile=""
	}
	action=""
}

$1 == "..." && $2 == "action" {
	action=$3
	printf "action: %s\n", action

	if (action == "add") {
		if (show_added) print_file("A",clientFile)
	} else if (action == "branch") {
		if (show_branched) print_file("B",clientFile)
	} else if (action == "delete") {
		if (show_deleted) print_file("D",clientFile)
	} else if (action == "edit") {
		if (show_edited) print_file("E",clientFile)
	} else if (action == "integrate") {
		if (show_integrated) print_file("I",clientFile)
	} else {
		print "error: file with unexpected action --", action, clientFile
	}
}

index($0," - no such file(s).") > 0 {
	check_not_modified()

	clientFile=get_path(substr($0,1,index($0," - no such file(s).")-1))
	if (show_unknown) print_file("U",clientFile)
	action="not modified"
}

END {
	check_not_modified()
}
