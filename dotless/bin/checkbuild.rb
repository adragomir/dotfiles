#!/opt/local/bin/ruby

$root = "http://ironchef.macromedia.com/zorn/ChangelistBuilds/Win/Mainline/ide_mainline/"

# check root 
root_value = `curl #{$root}`
puts root_value

exit
