node=$1
echo "node name is " $node

ip=$2
echo "Client ip is "$ip

package=$3
echo "Package : " $3

########################### Goto the chef path
cd /root/chef-repo/.chef

############################# Knife delete the node to bootstrap if it exists
knife node delete $node -y

############################# Knife command to bootstrap any node
knife bootstrap windows winrm $ip  --winrm-user 'IRISSOFTWARE\devops.user1' --winrm-password 'Password@2' --node-name $node -y

############################# Knife command to add the cookbook to the server
IFS=",";
packageArray=($package)
for ((i=0; i<${#packageArray[@]}; ++i));
 do
    cookbook=`echo ${packageArray[$i]}`
    knife node run_list add $node 'recipe['"$cookbook"']'
 done


############################## knife command to run the cookbook on client
knife winrm 'name:'"$node"'' 'chef-client' --winrm-user 'IRISSOFTWARE\devops.user1' --winrm-password 'Password@2'

############################## Status of cookbook installation
if [ $? -ne 0 ]
then
 sh test.sh
else
 echo "success"
fi



