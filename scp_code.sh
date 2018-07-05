#！/bin/bash

#base info
Remote_ip="45.249.246.204"
User_name="scpuser"
Passwd="SZgj@002#"
File_list="list"
Code_path="/data/"
Remote_path="/var/www/"
Timeout=5
#deal with the path in file list
sed -i 's/^\/website\///g' ${File_list}


#function scp
function scp_file(){

file_local="$1"
file_remote="$2"

expect -c "
set timeout 5
spawn scp ${file_local} ${User_name}@${Remote_ip}:${file_remote}
        expect {
                \"*no\" {send \"yes\r\"; exp_continue}
                \"*password\" {send \"SZgj@002#\r\"; exp_continue}
                \"*Password*\" {send \"SZgj@002#\r\";}
              }
"
}


#function main
function main(){
	for i in $(cat ${File_list});do
		echo ${i}
		file_dir=${Remote_path}$(dirname ${i})
		Command=$(echo "[ -d ${file_dir} ] || mkdir -p ${file_dir}")
		./cmd.exp ${Remote_ip} ${User_name} ${Passwd} "${Command}" ${Timeout}
		scp_file ${i} ${Remote_path}${i}
		
	done
}

main
