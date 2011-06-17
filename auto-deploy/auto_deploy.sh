#!/bin/sh
#
# Calvin.Lee<lihao921@gmail.com> @ Wed May 25 16:14:13 CST 2011
#
# The script aims to auto deploy the clat to remote machines.
#
# Must push your ssh keys to remote host first:
# ssh-keygen -t rsa
# scp .ssh/id_rsa.pub vivek@rh9linux.nixcraft.org:.ssh/authorized_keys2
# Regards to http://www.cyberciti.biz/tips/ssh-public-key-based-authentication-how-to.html

TARGET_DEPLOY_ZIP=$1

cat clat_hosts|while read line
do
    local HOST=`echo $line|awk -F: '{print $1}'`
    local USER=`echo $line|awk -F: '{print $2}'`

    echo "Uploading target deploy zip to host "$HOST
    scp $TARGET_DEPLOY_ZIP $USER@$HOST:.
    echo "Deploying..."
    ssh $USER@$HOST>/dev/null <<-EOF
[[ -d clat ]]||mkdir clat
cd clat
mv client client-bak-`date +%Y%m%d`
tar zxf ~/`basename $TARGET_DEPLOY_ZIP` -C .
exit
EOF
    echo ""
done
