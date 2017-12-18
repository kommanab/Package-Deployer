#
# Cookbook:: JRE Windows
# Recipe:: default
# Copyright:: 2017, The Authors, IRIS
#
# Author:: Saurabh Singhal
# Cookbook Name:: Acrobat Reader
# Resource:: edition
#
# 
#

include_recipe "windows"

powershell_script 'jre-windows copy' do
 # code 'Copy-Item  "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\jre-8u144-windows-x64.exe" "E:\\chef_poc"'
 code 'robocopy "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\" "C:\\chef_poc\\" "jre-8u144-windows-x64.exe"'
  user                'devops.user1'
  password            'Password@2'       
  domain               'irissoftware'
 cwd Chef::Config[:file_cache_path]
 sensitive true 
 ignore_failure true
 retries 3
 timeout 3600
end

windows_package 'jre-windows install' do
 source 'C:\\chef_poc\\jre-8u144-windows-x64.exe'
 options '/s' 
 action :install
 installer_type :custom
 ignore_failure true
 timeout 3600
end

powershell_script 'Java Installation Success Status' do
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
        Add-Content -Path $sFullPath -Value "java | Success" '
  only_if { ::File.exist?('C:\Program Files\Java\jre1.8.0_144\bin\java.exe') }
end

powershell_script 'Java Installation Fail Status' do
  guard_interpreter :powershell_script
  code '$LogPath=  "C:\Chef_Package\"
        New-Item -ItemType Directory -Force -Path  $LogPath
        $LogName = "Status.txt"
        $sFullPath = $LogPath+$LogName  
        #Check if file exists and delete if it does
        If(![System.IO.File]::Exists($sFullPath)){
            #Create file and start logging
            New-Item -Path $LogPath -Name $LogName -Force -ItemType File 
            Add-Content -Path $sFullPath -Value "Package | Status"
        }
        Add-Content -Path $sFullPath -Value "Java | Failed" '
  not_if { ::File.exist?('C:\Program Files\Java\jre1.8.0_144\bin\java.exe') }
end
