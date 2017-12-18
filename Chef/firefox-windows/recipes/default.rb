#
#
#cookbook:: Firefox Windows
# Recipe:: default
# Copyright:: 2017, The Authors, IRIS
#
# Author:: Saurabh Singhal
# Cookbook Name:: Firefox-windows
# Resource:: edition
#
# 
#

include_recipe "windows"

powershell_script 'FireFox Copy' do

 code 'robocopy "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\" "C:\\chef_poc" "Firefox Setup 56.0.exe"'
  user             'devops.user1'
  password         'Password@2'       
  domain           'irissoftware'
  cwd Chef::Config[:file_cache_path]
  sensitive true
  retries 3 
  ignore_failure true
 timeout 36000
end

windows_package 'Firefox Installation' do
 source 'C:\\chef_poc\\Firefox Setup 56.0.exe'
 options '/S' 
 action :install
 installer_type :custom
 ignore_failure true
 timeout 3600
end

powershell_script 'Firefox Installation Success Status' do
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
        Add-Content -Path $sFullPath -Value "Firefox | Success" '
  only_if { ::File.exist?('C:\Program Files\Mozilla Firefox\firefox.exe') }
end

powershell_script 'Firefox Installation Failed Status' do
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
        Add-Content -Path $sFullPath -Value "Firefox | Failed" '
  not_if { ::File.exist?('C:\Program Files\Mozilla Firefox\firefox.exe') }
end

