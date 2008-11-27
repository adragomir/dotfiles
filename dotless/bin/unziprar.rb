#!/usr/bin/env ruby
folder = File.expand_path(".")
files = Dir[folder + "/*.zip"]
files.each { |f|
	`unzip -o #{f} -d #{folder}`
}

rar_files = Dir[folder + "/*.rar"]
files.each { |f|
	`unzip -o #{f} -d #{folder}`
}


