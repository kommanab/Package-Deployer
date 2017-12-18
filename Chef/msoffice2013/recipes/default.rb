#
# Cookbook:: msoffice2013
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "windows"

powershell_script 'MS Office Copy' do
code 'robocopy "\\\\192.168.10.12\\ChefLogs\\Report2\\msoffice2013" "C:\\chef_poc\\msoffice2013\\" /E /MIR'
  user             'devops.user1'
  password         'Password@2'
  domain           'irissoftware'
  sensitive true
 cwd Chef::Config[:file_cache_path]
 ignore_failure true
 retries 3
 timeout 1800
 end

windows_package 'office2013' do
  source 'C:\\chef_poc\\msoffice2013\\setup.exe'
  options '/config \"C:/chef_poc/msoffice2013/x86/standard.ww/config.xml\"'
  action :install
  installer_type :custom
  ignore_failure true
timeout 3600
end

powershell_script 'Office Installation Success Status' do
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
        Add-Content -Path $sFullPath -Value "MSOffice | Success" '
  only_if { ::File.exist?('C:\Program Files\Microsoft Office\Office15\msoia.exe') }
end

powershell_script 'Office Installation Fail Status' do
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
        Add-Content -Path $sFullPath -Value "MSOffice | Failed" '
  not_if { ::File.exist?('C:\Program Files\Microsoft Office\Office15\msoia.exe') }
end


