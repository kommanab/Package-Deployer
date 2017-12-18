#
# Cookbook:: vs-windows
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

powershell_script 'Visual Studio' do
  code 'robocopy "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\VS 2015 Pro with Update 3" "C:\\chef_poc\\VS 2015" /E /MIR'
  user             'devops.user1'
  password         'Password@2'       
  domain           'irissoftware'
 cwd Chef::Config[:file_cache_path]
 ignore_failure true
 retries 3
 timeout 36000
end


windows_package 'vs_professional' do
 source 'C:\\chef_poc\\VS 2015\\vs_professional.exe'
 options '/Passive /NoRestart'  
 action :install
 installer_type :custom
 ignore_failure true
 timeout 36000
end

powershell_script ' Visual Studio Installation Success Status' do
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
        Add-Content -Path $sFullPath -Value "Visual Studio | Success" '
  only_if { ::File.exist?('C:\Program Files (x86)\Microsoft Visual Studio 14.0\Xml\SnippetsIndex.xml') }
end

powershell_script ' Visual Studio Installation Fail Status' do
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
        Add-Content -Path $sFullPath -Value "Visual Studio | Failed" '
  not_if { ::File.exist?('C:\Program Files (x86)\Microsoft Visual Studio 14.0\Xml\SnippetsIndex.xml') }
end
