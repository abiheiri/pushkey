#!/usr/bin/env bash
#designed to pushkey to an ip eg. ./pushkey.sh 192.168.x.x
#20091229 - abiheiri@gmail.com
#20100601 - v0.8 - added keygen and detection of rsa or dsa keys
#20120106 - v1.0 - now it only password prompts once.. hoorah
#20121009 - v1.1 - added support for unique public keys
#20130112 - v1.2 - added support for specifying remote ssh port


REM_HOST=$1
KEYTYPE=
PORT=22
DIR=$HOME/.ssh

note () {
cat <<EOF

usage: pushkey user@ipaddress [/path/identityfile] [port]

examples: 
	pushkey 192.168.0.1
	pushkey al@myfqdn.com
	pushkey fqdn.com /path/id_key.pub
	pushkey 192.168.0.1 /path/file 666

If you dont specify identityfile then it will try $DIR/id_dsa.pub, else  id_rsa.pub.
You must specify path to identityfile if you are planning to specify a different port to pushkey

EOF
}

if [[ "$1" == "" ]]
then
	note
	exit 1
fi

if [[ "$2" != "" ]]
then
	KEYTYPE=$2
fi

if [[ "$3" = "[0-9]" ]]; then
	PORT=$3
fi

pushkey () {
	VAL=$(cat $KEYTYPE)
	ssh -p $PORT $REM_HOST "umask 077; test -d .ssh || mkdir .ssh; chmod 700 .ssh ; echo $VAL >> .ssh/authorized_keys; chmod 600 .ssh/*" || exit 2
	echo "Cheers! Now go verify remote host is set up correctly."
}

create_keys () {
        echo "No public keys found... Do you want rsa or dsa keys? If your not sure, choose RSA."
        read INPUT
        case "$INPUT" in
                rsa|RSA) ssh-keygen && KEYTYPE="id_rsa.pub" && pushkey;;
                dsa|DSA) ssh-keygen -t dsa && KEYTYPE="id_dsa.pub" && pushkey;;
                *) echo "*** You didnt specify dsa or rsa ***"; exit 3;;
        esac
}


if [[ $KEYTYPE != "" ]]
then
	if [[ -e $KEYTYPE ]]
	then
		pushkey
	else
		echo -e "\033[1mWho boofed? Problem occurred with specified path\033[0m"
		echo "$KEYTYPE <--- Does it exist? Permissions issue? I Dunno..."
		exit 4
	fi
elif [[ -e  $DIR/id_dsa.pub ]]
then
        KEYTYPE="$DIR/id_dsa.pub" && pushkey
elif [[ -e $DIR/id_rsa.pub ]] 
then
        KEYTYPE="$DIR/id_rsa.pub" && pushkey
else
        create_keys
fi

