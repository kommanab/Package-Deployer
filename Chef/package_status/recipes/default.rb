#
# Cookbook:: package_status
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "windows"

powershell_script 'Package Status' do
 code '$LogPath="C:\\Chef_Package\\"
 $LogName = hostname
 $fileName=$LogName+".txt"
 $sFullPath = $LogPath+$fileName
 robocopy  $LogPath "\\\\192.168.10.12\\ChefLogs\\Report1" $fileName'
 user             'devops.user1'
 password         'Password@2'
 domain           'irissoftware'
 sensitive true
 timeout 18000
end

