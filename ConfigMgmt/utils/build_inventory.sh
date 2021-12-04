#!/bin/bash
  
master_file=$1
data_file=$2
echo > ../hosts
echo "[master-nodes]" >> ../hosts
cat $master_file >> ../hosts
echo "[data-nodes]" >> ../hosts
cat $data_file >> ../hosts
host_ips=""
cat $master_file >> tmp_hosts.txt
cat $data_file >> tmp_hosts.txt
file="tmp_hosts.txt"
last_line=$(wc -l < $file)
current_line=0
while read -r line; do
  current_line=$(($current_line + 1))

  if [[ $current_line -ne $last_line ]]; then 
    host_ips+="${line}:9300,"
  else
    host_ips+="${line}:9300"
  fi 
done < $file
for i in $(cat $file)
do
        ssh-keyscan $i >> ~/.ssh/known_hosts
done
rm $file
echo $host_ips

sed -i "/cluster.initial_master_nodes/c\      cluster.initial_master_nodes: \"$host_ips\"" $3
sed -i "/discovery.seed_hosts/c\      discovery.seed_hosts: \"$host_ips\"" $3
