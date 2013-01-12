#!/usr/bin/env perl

use warnings;
use strict;

sub note {
my $heredoc = <<END;

usage: pushkey user\@ipaddress [-i identityfile] [-p port]

examples: 
	pushkey 192.168.0.1
	pushkey al\@myfqdn.com
	pushkey fqdn.com -i /path/id_key.pub
	pushkey 192.168.0.1 -p 666

if you dont specify identityfile then it will try \$DIR/id_dsa.pub, else  id_rsa.pub


END
print $heredoc; 
}

if (@ARGV < 1) {
	note();
}

my $ip=$ARGV[0];

if (defined $ARGV[1]) {
	my $key=$ARGV[1];
}

if (defined $ARGV[2]) {
	my $port=$ARGV[2];
}
else {
	my $port=22;
}
