

$InstallLink_64="https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-v5.2.0.20220712.exe"
$InstallLink_32="https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w32-setup-v5.2.0.20220712.exe"
$LocalPath = "C:\Tmp\Tesseract\tesseract-ocr-w64-setup-v5.2.0.20220712.exe"
cls
Write-Host "Please wait while getting Tesseract"

Save-OnlineFileWithProgress -Url $InstallLink_64 -Path "$LocalPath" 

if(Test-PAth $LocalPath){
    Write-Host "Success" -f Green
    $LocalPath
}else{
    Write-Host "Failed" -f Red
}

 $p = "$ENV:PATH;C:\Program Files\Tesseract-OCR"
 $t = "C:\Program Files\Tesseract-OCR\tessdata"
 Set-EnvironmentVariable -Name "TESSDATA_PREFIX" -Value $t -Scope Session
 Set-EnvironmentVariable -Name "PATH" -Value $p -Scope Session