#requires -Module EZOut
#  Install-Module EZOut or https://github.com/StartAutomating/EZOut
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = 'PSClientBranding' #$($myFile | Split-Path -Leaf) -replace '\.ezformat\.ps1', '' -replace '\.ezout\.ps1', ''
$myRoot = $myFile | Split-Path | Split-Path
Push-Location $myRoot
$formatting = @(
    # Add your own Write-FormatView here,
    # or put them in a Formatting or Views directory
    foreach ($potentialDirectory in 'Formats','Views','Types') {
        Join-Path $myRoot $potentialDirectory |
            Get-ChildItem -ea ignore |
            Import-FormatView -FilePath {$_.Fullname}
    }
)

$destinationRoot = $myRoot

if ($formatting) {
    $myFormatFilePath = Join-Path $destinationRoot "$myModuleName.format.ps1xml"
    # You can also output to multiple paths by passing a hashtable to -OutputPath.
    $formatting | Out-FormatData -Module $MyModuleName -OutputPath $myFormatFilePath
}

$types = @(
    # Add your own Write-TypeView statements here
    # or declare them in the 'Types' directory
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
        Import-TypeView

)

if ($types) {
    $myTypesFilePath = Join-Path $destinationRoot "$myModuleName.types.ps1xml"
    # You can also output to multiple paths by passing a hashtable to -OutputPath.
    $types | Out-TypeData | Set-Content $myTypesFilePath -Encoding UTF8
    Get-Item $myTypesFilePath
}
Pop-Location
