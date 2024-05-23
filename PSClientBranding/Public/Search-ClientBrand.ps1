Function Search-ClientBrand {
    <#
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$SearchTerm,
        [Parameter(Mandatory = $false)]
        [string]$ApiKey = $env:BRANDFETCH_API_KEY
    )

    Begin {
        $baseURI = 'https://api.brandfetch.io/v2/search/'
        $fullURI = $baseURI + $SearchTerm

        $headers = @{}
        $headers.Add('accept', 'application/json')

        $Bearer = "Bearer $ApiKey"
        $headers.Add('Authorization', $Bearer)
    }

    Process {
        $response = Invoke-RestMethod -Uri $fullURI -Headers $headers -Method Get

        $response
    }

    End {
    }
}
