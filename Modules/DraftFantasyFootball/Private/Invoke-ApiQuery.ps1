function Invoke-ApiQuery {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Query,

        [Parameter()]
        [int]
        $Year
    )

    switch ($Year) {
        2019 {$ApiUri = 'https://epl19.draftfantasyfootball.co.uk/graphql'}
        2018 {$ApiUri = 'https://epl18.draftfantasyfootball.co.uk/graphql'}
        2017 {$ApiUri = 'https://epl17.draftfantasyfootball.co.uk/graphql'}
        default {$ApiUri = 'https://draftfantasyfootball.co.uk/graphql'}
    }

    $Body = '{{"query":"{0}","variables":null,"operationName":null}}' -f $Query.Replace('"', '\"') -replace "`r?`n", '\n'
    $Params = @{
        Uri         = $ApiUri
        Method      = 'Post'
        Body        = $Body
        ContentType = 'application/json'
    }

    Write-Verbose -Message $Body
    Invoke-RestMethod @Params
}
