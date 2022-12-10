
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
        [string]$Path,
        [Parameter(Mandatory=$false,Position=1)]
        [Alias('d', 'dst')]
        [string]$Destination,
        [Parameter(Mandatory=$false)]
        [Alias('j', 'json')]
        [switch]$AsList
    )
$PoplerPath='C:\\Tmp\tools\\poppler-0.68.0\\bin'

$p = "$ENV:PATH;$PoplerPath"
$Res=Set-EnvironmentVariable -Name "PATH" -Value $p -Scope Session

 $p = "$ENV:PATH;C:\Program Files\Tesseract-OCR"
 $t = "C:\Program Files\Tesseract-OCR\tessdata"
 $Res=Set-EnvironmentVariable -Name "TESSDATA_PREFIX" -Value $t -Scope Session
 $Res=Set-EnvironmentVariable -Name "PATH" -Value $p -Scope Session


$OutLog = "$PSScriptRoot\Out.log"
Out-File $OutLog -Encoding Unicode

$PyExe = (Get-Command 'py').Source
$ScriptPath = "$PSScriptRoot\Run.py"
$Path = $Path.Replace('\','\\')
Write-Verbose "Converting $Path"
$PythonCode = @"
from multilingual_pdf2text.pdf2text import PDF2Text
from multilingual_pdf2text.models.document_model.document import Document
import logging
logging.basicConfig(level=logging.INFO)

def main():
    ## create document for extraction with configurations
    pdf_document = Document(
        document_path='$Path',
        language='spa'
        )
    pdf2text = PDF2Text(document=pdf_document)
    content = pdf2text.extract()
    print(content)

if __name__ == "__main__":
    main()

"@
Write-Verbose "Writing $ScriptPath"
Set-Content $ScriptPath -Value $PythonCode
Write-Verbose "Running $ScriptPath"
&"$PyExe" $ScriptPath | Out-File $OutLog -Encoding Unicode

Write-Verbose "Deleting $ScriptPath"
del $ScriptPath

Write-Verbose "DOne" 
$ListData = get-content $OutLog | ConvertFrom-Json
$TextData = get-content $OutLog 
del $OutLog
if($Destination){
   Set-Content $Destination -Value $TextData  -Encoding Unicode
}elseif($AsList){
   $ListData
}else{
    $TextData 
}
