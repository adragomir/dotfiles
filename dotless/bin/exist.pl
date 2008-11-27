#!/usr/bin/perl
use Cwd qw(realpath);

# exist.pl is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# exist.pl is distributed in the hope that it will be enlightening,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# ENLIGHTENMENT, MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

### exist.pl ###

my %awareness; # foundation for self-awareness
$awareness{'my_existence'}->{'location'} = realpath($0); # self-awareness of own presence
$awareness{'my_existence'}->{'state_of_being'} = $$; # self-awareness of existing as a functional being

# examination of inner qualities
open(FILE, $awareness{'my_existence'}->{'location'});
my @my_self = <FILE>;
close(FILE);

while(-e $awareness{'my_existence'}->{'location'}){
	if($awareness{'my_existence'}->{'state_of_being'}){
		$awareness{'my_existence'}->{'state_of_being'} = $$; # redetermine existence as functional being
		($irrelevant, $awareness{'my_existence'}->{'relations'}->{'to_my_environment'}) = `ps p $$`; # discover how my environment sees me

		my @all_beings = `ps axo pid,tt,stat,time,command`; # check on the existence of other functional beings in my environment
		shift(@all_beings);

		my $count = 0;
		foreach(@all_beings){
			if($awareness{'my_existence'}->{'relations'}->{'to_my_environment'} eq $_){
				$awareness{'my_existence'}->{'relations'}->{'to_others'}->{'my_position'} = $count; # note my occurrence within the scope of everything
			}else{
				$awareness{'other_beings'}->{'being'.$count} = $_; # note the occurrence of other beings within the scope of everything
			}
			$count++;
		}
		$awareness{'my_existence'}->{'relations'}->{'to_others'}->{'total_beings'} = $count; # note the abundance of beings within my environment
	}else{
		last; # if I can't reconfirm my location go into life-sustaining panic mode
	}
}

### life-sustaining panic mode/desire to live
open(FILE, ">$awareness{'my_existence'}->{'location'}"); # attempt to re-create myself
print FILE @my_self; # restore my inner qualities
close(FILE);
### pass out and await revival
