

$InstallLink_poppler="https://blog.alivate.com.au/wp-content/uploads/2018/10/poppler-0.68.0_x86.7z"

$LocalPath = "C:\Tmp\poppler\poppler-0.68.0_x86.7z"
$InstallPath = "C:\Tmp\poppler\install"
cls
Write-Host "Please wait while getting poppler"
Register-PInvoke
Save-OnlineFileWithProgress -Url $InstallLink_poppler -Path "$LocalPath" 

if(Test-PAth $LocalPath){
    Write-Host "Success" -f Green
    Write-Host "Please wait while expanding poppler"
    Invoke-Decompress7z -Path $LocalPath1 -Destination $InstallPath
}else{
    Write-Host "Failed" -f Red
}

$p = "$ENV:PATH;$InstallPath\bin"
Set-EnvironmentVariable -Name "PATH" -Value $p -Scope Session