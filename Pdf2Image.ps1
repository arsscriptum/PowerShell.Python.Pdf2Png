
[CmdletBinding()]
    param(
        [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist"
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a File. Directory paths are not allowed."
        }
        return $true 
        })]
        [Parameter(Mandatory=$true,Position=0)]
        [Alias('s', 'src')]
        [string]$Path
    )
$PoplerPath='C:\\Tmp\tools\\poppler-0.68.0\\bin'
$PyExe = (Get-Command 'py').Source
$ScriptPath = "$PSScriptRoot\Run.py"
$Path = $Path.Replace('\','\\')
Write-Host "Converting $Path"
$PythonCode = @"
from pdf2image import convert_from_path
images = convert_from_path("$Path", 500,poppler_path=r'$PoplerPath')
for i, image in enumerate(images):
    fname = 'image'+str(i)+'.png'
    image.save(fname, "PNG")

"@
Write-Host "Writing $ScriptPath"
Set-Content $ScriptPath -Value $PythonCode
Write-Host "Running $ScriptPath"
&"$PyExe" $ScriptPath
Write-Host "Deleting $ScriptPath"
del $ScriptPath
Write-Host "DOne" -f Green
dir *.png