function Invoke-ApiQuery {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Query
    )

    $ApiUri = 'https://draftfantasyfootball.co.uk/graphql'
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
