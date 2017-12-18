#
# Cookbook:: chrome-windows
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Author:: Saurabh Singhal
# Cookbook Name:: Chrome-Windows
# Resource:: edition
#
# 
#

include_recipe "windows"

powershell_script 'Chrome Copy' do
 code 'robocopy "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\" "C:\\chef_poc" "GoogleChromeStandaloneEnterprise64.msi"'
  user        'devops.user1'
  password    'Password@2'
  domain      'irissoftware'
  cwd Chef::Config[:file_cache_path]
  sensitive true
  retries 3 
  ignore_failure true
timeout 3600
end


windows_package 'Chrome Installation' do
 source 'C:\\chef_poc\\GoogleChromeStandaloneEnterprise64.msi'
 options '/qn /quiet /norestart' 
 action :install
 installer_type :custom
 ignore_failure true
 timeout 3600
end

powershell_script 'Chrome Installation Status' do
  guard_interpreter :powershell_script
  code '$LogPath=  "C:\Chef_Package\"
        New-Item -ItemType Directory -Force -Path  $LogPath
        $LogName = hostname
 	$fileName=$LogName+".txt"
 	$sFullPath = $LogPath+$fileName        #Check if file exists and delete if it does
        If(![System.IO.File]::Exists($sFullPath)){
            #Create file and start logging
            New-Item -Path $LogPath -Name $LogName -Force -ItemType File 
            Add-Content -Path $sFullPath -Value "Package | Status"
        }
        Add-Content -Path $sFullPath -Value "Chrome | Success" '
  only_if { ::File.exist?('C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe') }
  user        'devops.user1'
  password    'Password@2'
  domain      'irissoftware'
end

powershell_script 'Chrome Installation Status' do
  guard_interpreter :powershell_script
  code '$LogPath=  "C:\Chef_Package\"
        New-Item -ItemType Directory -Force -Path  $LogPath
        $LogName = hostname
 	$fileName=$LogName+".txt"
 	$sFullPath = $LogPath+$fileName  
        #Check if file exists and delete if it does
        If(![System.IO.File]::Exists($sFullPath)){
            #Create file and start logging
            New-Item -Path $LogPath -Name $LogName -Force -ItemType File 
            Add-Content -Path $sFullPath -Value "Package | Status"
        }
        Add-Content -Path $sFullPath -Value "Chrome | Failed" '
  not_if { ::File.exist?('C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe') }
end
