<#PSScriptInfo
.VERSION 1.1
.GUID 1db3a669-88dc-44fd-a9cb-8d029702be66
.AUTHOR takescake@outlook.com
.TAGS 
 Windows 11
 Windows Upgrade
 Automation
.LICENSEURI https://github.com/CakeRepository/Install-Windows11/blob/main/LICENSE
.PROJECTURI https://github.com/CakeRepository/Install-Windows11
.RELEASENOTES
 1.1 - Updated URI's for project 
#>

<# 
.DESCRIPTION 
 Downloads the Windows 11 ISO from the any URL hosting it, mounts it to the Windows Operating system, and then attempts to install it will fail if it doesn't meet the strict Windows 11 requirements. 
.PARAMETER arguments
 These are the arguments to give to the Windows 11 setup.exe after it is mounted.
 These switches can be found here - https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-command-line-options
 Default: /auto upgrade /DynamicUpdate Disable /quiet
.PARAMETER DownloadPath
 The path where the Windows 11 ISO will be downloaded. 
 Default: C:\windows\temp\win11.iso
.PARAMETER DownloadURL
 The URL for the Windows 11 ISO you can grab a download link here https://www.microsoft.com/en-us/software-download/windows11 that lasts for 24 hours       
.EXAMPLE
 Install-Windows11 -DownloadURL "https://software-download.microsoft.com/pr/Win11_English_x64.iso?t=91df36a5-c6e0-46b5-8ad8-960c29aae6a4&e=1634707003&h=1f1e014b5f7389e51b98958c9c2d0949"
 Install-Windows11 -arguments "/auto upgrade /DynamicUpdate Disable" -DownloadURL "https://software-download.microsoft.com/pr/Win11_English_x64.iso?t=91df36a5-c6e0-46b5-8ad8-960c29aae6a4&e=1634707003&h=1f1e014b5f7389e51b98958c9c2d0949"
 Install-Windows11 -DownloadPath "C:\temp\win11.iso" `
    -DownloadURL "https://software-download.microsoft.com/pr/Win11_En
#> 
param(
        [Parameter(Mandatory=$false, HelpMessage="Specify the URL for Windows 11 ISO")]
        [string]$DownloadURL = "\\file-share\ISO\Windows11.iso",
        [Parameter(Mandatory=$false, HelpMessage="Specify path for the Windows 11 ISO to be downloaded")]
        [ValidateScript({Test-Path $_ -IsValid})]
        [string]$DownloadPath = "C:\windows\temp\win11.iso",
        [Parameter(Mandatory=$false, HelpMessage="Specify Arguments to run with setup.exe")]
        [string]$Arguments = "/auto upgrade /DynamicUpdate Enable /eula accept /quiet"
    
)
Write-Output "Downloading ISO from $DownloadURL to $DownloadPath"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($DownloadURL, $DownloadPath)

Write-Output "Mounting ISO File"
$vol = Mount-DiskImage -ImagePath $DownloadPath  -PassThru |
    Get-DiskImage | 
    Get-Volume
$setup = '{0}:\setup.exe' -f $vol.DriveLetter

Write-Output "Starting Windows 11 Upgrade"
Start-Process cmd.exe -Wait -ArgumentList "/c $setup $Arguments"

Write-Output "Finished installing - if errors run without the /quiet command"
