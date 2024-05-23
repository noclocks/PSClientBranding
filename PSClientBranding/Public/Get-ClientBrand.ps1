Function Get-ClientBrand {
    <#
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$DomainName,
        [Parameter(Mandatory=$false)]
        [string]$ApiKey = $env:BRANDFETCH_API_KEY,
        [Parameter(Mandatory=$false)]
        [ValidateSet('name', 'domain', 'description', 'longDescription', 'links', 'colors', 'fonts', 'images', 'company', 'location', 'industries', 'logos')]
        [string[]]$Fields = @('*')
    )

    Begin {

        $baseURI = "https://api.brandfetch.io/v2/brands/"
        $fullURI = $baseURI + $DomainName

        $headers = @{}
        $headers.Add('accept', 'application/json')

        $Bearer = "Bearer $ApiKey"
        $headers.Add("Authorization", $Bearer)
    }

    Process {
        $response = Invoke-RestMethod -Uri $fullURI -Headers $headers -Method Get

        $name = $response.name
        $domain = $response.domain
        $description = $response.description
        $longDescription = $response.longDescription


        $links = $response.links | ForEach-Object {
            [PSCustomObject]@{
                name = $_.name
                url = $_.url
            }
        }

        $colors = $response.colors | ForEach-Object {
            [PSCustomObject]@{
                name = $_.name
                type = $_.type
                hex = $_.hex
            }
        }

        $fonts = $response.fonts | ForEach-Object {
            [PSCustomObject]@{
                name = $_.name
                type = $_.type
                origin = $_.origin
                originId = $_.originId
                weights = $_.weights
            }
        }

        $images = $response.images

        $company = $response.company | ForEach-Object {
            [PSCustomObject]@{
                location = $_.location | ForEach-Object {
                    [PSCustomObject]@{
                        country = $_.country
                        countryCode = $_.countryCode
                        state = $_.state
                        city = $_.city
                        region = $_.region
                        subregion = $_.subregion
                    }
                }
                industries = $_.industries | ForEach-Object {
                    [PSCustomObject]@{
                        id = $_.id
                        name = $_.name
                        score = $_.score
                        slug = $_.slug
                        parent = $_.parent | ForEach-Object {
                            [PSCustomObject]@{
                                id = $_.id
                                name = $_.name
                                slug = $_.slug
                                emoji = $_.emoji
                            }
                        }
                    }
                }
                employees  = $_.employees
                founded    = $_.foundedYear
                kind       = $_.kind
            }
        }

        $location = $company.location
        $industries = $company.industries

        $logos = @()

        $response.logos | ForEach-Object {
            $_.formats | ForEach-Object {
                $logos += [PSCustomObject]@{
                    type = $_.format
                    url    = $_.src
                    width  = $_.width
                    height = $_.height
                    background = $_.background
                    size       = $_.size
                }
            }
        }

        $brand = [PSCustomObject]@{PSTypeName = 'ClientBrand';
            name = $name
            domain = $domain
            description = $description
            longDescription = $longDescription
            links = $links
            colors = $colors
            fonts = $fonts
            images = $images
            company = $company
            location = $location
            industries = $industries
            logos = $logos
        }

    }

    End {
        $brand | Select-Object $Fields
    }

}
