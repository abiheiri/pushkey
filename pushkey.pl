#!/usr/bin/env perl

use warnings;
use strict;

#use Data::Dumper;

sub note {
my $heredoc = <<END;

usage: pushkey user\@ipaddress [-i identityfile] [-p port]

examples: 
	pushkey 192.168.0.1
	pushkey al\@myfqdn.com
	pushkey fqdn.com /path/id_key.pub
	pushkey 192.168.0.1 /path/file 80


If you dont specify the path to the identityfile then it will try \$HOME/.ssh/id_dsa.pub, else id_rsa.pub
You must specify path to identityfile if you are planning to specify a different port to pushkey


END
print $heredoc; 
exit;
}

#0=host, 1=keypath, 2=port

exists $ARGV[0] or note ();

my $REM_HOST=$ARGV[0];
my $KEY="";
my $PORT=22;
my $DIR=$ENV{"HOME"};
my $VAL="";

if (defined $ARGV[1]) {
	$KEY=$ARGV[1];
}

if (defined $ARGV[2]) {
	if ($ARGV[2] =~ /^[0-9]+$/) {
		$PORT=$ARGV[2];
	}
}

sub pushkey {
	open (MYFILE, $KEY);
	while (<MYFILE>) {
	   	chomp;
		$VAL=$_;
	}
	close (MYFILE); 
	`ssh -p $PORT $REM_HOST "umask 077; test -d .ssh || mkdir .ssh; chmod 700 .ssh ; echo $VAL >> .ssh/authorized_keys; chmod 600 .ssh/*" || exit 2`;
	print "Cheers! Now go verify remote host is set up correctly.\n";
}

sub create_keys () {
        print "No public keys found... Do you want rsa or dsa keys? (default = rsa)\n";

        my $read=lc(<STDIN>);
        chomp($read);
        if ($read eq "rsa") {
                qx/ssh-keygen/;
                $KEY="$DIR/.ssh/id_rsa.pub";
                pushkey ();
        } elsif ($read eq "dsa") {
                qx/ssh-keygen -t dsa/;
                $KEY="$DIR/.ssh/id_dsa.pub";
                pushkey ();
        } else {
                        die "*** You didnt specify dsa or rsa ***\n";
        }
}

if ( $KEY ne "") {

	if ( -e $KEY ) {
		pushkey ();
	} else {
		print "The identity file path you specified failed.\n", "Does it actually exist? Possibly a permissions issue? I dunno.\n"
	}

}
elsif (-e "$DIR/.ssh/id_dsa.pub") {
	$KEY="$DIR/.ssh/id_dsa.pub";
	pushkey ();
} elsif (-e "$DIR/.ssh/id_rsa.pub") {
	$KEY="$DIR/.ssh/id_rsa.pub";
	pushkey ();
} else {
	create_keys ();
}

