#!/usr/bin/env ruby
#
require 'find'
$start = Dir.pwd

actions = {
    '.svn' => proc { |path|
        Dir.chdir(path) do
            contents = `svn info`.match(/URL: (.*)/)[1]
            "  repository: " + contents
        end
    }, 
    'CVS' => proc { |path|
        Dir.chdir(path) do
            # cvs params
            "  repository: cvs -d" + IO.read(path + "/CVS/Root").gsub(/[\r\n]/, "") + " co " + IO.read(path + "/CVS/Repository").gsub(/[\r\n]/, "")
        end
    }, 
    '_darcs' => proc { |path|
        Dir.chdir(path) do
            "  repository: " + IO.read(path + "/_darcs/prefs/repos").gsub(/[\r\n]/, "")
        end
    }, 
    '.hg' => proc { |path|
        Dir.chdir(path) do
            "  repository: " + `hg showconfig`.match(/paths\.default=(.*)$/)[1]
        end
    }, 
    '.bzr' => proc { |path|
        Dir.chdir(path) do
            "  repository: " + `bzr info | tail -n 1`
        end
    }, 
    '.git' => proc { |path|
        Dir.chdir(path) do
            if File.file?(path + "/.git/branches/origin")
                "  repository: " + IO.read(path + "/.git/branches/origin").gsub(/[\r\n]/, "")
            else
                begin
                    "  repository: " + IO.read(path + "/.git/config").match(/url = (.*)$/)[1]
                rescue
                    "  an error occured (path: #{path}): " + $!.inspect
                end
            end
        end
    } 
}

Find.find($start) { |path|
    if FileTest.directory?(path)
        active_hash = nil
        has_source_control = %w(.svn CVS _darcs .hg .git .bzr).inject(false) { |memo, val|
            path_scm = path + "/" + val
            is_dir = File.directory?(path_scm)
            memo = memo || is_dir
            if is_dir
                active_hash = actions[val]
            end
            memo
        }
        if has_source_control
            puts "Found #{actions.index(active_hash)} source control in " + path
            puts active_hash.call(path)
            Find.prune       # Don't look any further into this directory.
        else
            next
        end
        else
    end
}
exit

