Function Get-ClientBrandImages {
    <#
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ClientBrand,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath = $PWD
    )

    Begin {
        $BrandImages = $ClientBrand.logos
    }

    Process {
        $BrandImages | ForEach-Object {
            $name = Split-Path -Path $_ -Leaf
            $outFile = Join-Path -Path $OutputPath -ChildPath $name
            Invoke-WebRequest -Uri $_ -OutFile $outFile
        }
    }

    End {
        Write-Output "Images downloaded successfully"
    }
}

# $logos = $Brand.logos

# $logosTable = $logos |


# $logos.url | ForEach-Object {
#     $name = Split-Path -Path $_ -Leaf
#     Invoke-WebRequest -Uri $_ -OutFile $name
# }

# Invoke-WebRequest -Uri "https://asset.brandfetch.io/id1vzz_tJL/id7byIk3db.png" -OutFile Image.png
