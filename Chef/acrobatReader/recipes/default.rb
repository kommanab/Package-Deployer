#
# Cookbook:: acrobatReader
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Author:: Saurabh Singhal
# Cookbook Name:: Acrobat Reader
# Resource:: edition
#
# 
#

include_recipe "windows"

powershell_script 'Acrobat Reader Copy' do
 code 'robocopy "\\\\192.168.10.13\\FreewareSoftware\\ITS-DevOps\\Acrobat Reader" "C:\\chef_poc\\Acrobat Reader" /E /MIR'
  user          'devops.user1'
  password      'Password@2'       
  domain        'irissoftware'
  sensitive true
  cwd Chef::Config[:file_cache_path]
  retries 3
  ignore_failure true
  timeout 3600
end

windows_package 'AcrobatReader Installation' do
 source 'c:\\chef_poc\\Acrobat Reader\\AcroRdrDC1501620039_en_US.exe'
 options '/sAll' 
 action :install
 installer_type :custom
 ignore_failure true
 timeout 3600
end

powershell_script 'Acrobat Installation Success Status' do
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
        Add-Content -Path $sFullPath -Value "AcrobatReader | Success" '
  only_if { ::File.exist?('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe') }
end

powershell_script 'Acrobat Installation Fail Status' do
  guard_interpreter :powershell_script
  code '$LogPath=  "C:\Chef_Package\"
        New-Item -ItemType Directory -Force -Path  $LogPath
        $LogName = hostname
 	$fileName=$LogName+".txt"
        $sFullPath = $LogPath+$fileName #Check if file exists and delete if it does
        If(![System.IO.File]::Exists($sFullPath)){
            #Create file and start logging
            New-Item -Path $LogPath -Name $LogName -Force -ItemType File 
            Add-Content -Path $sFullPath -Value "Package | Status"
        }
        Add-Content -Path $sFullPath -Value "AcrobatReader | Failed" '
  not_if { ::File.exist?('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe') }
end
