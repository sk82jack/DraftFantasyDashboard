function Get-DraftLeagueConfigText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $LeagueId
    )

    $Query = @'
query LeagueTeams($leagueId: String!) {
  teams: leagueTeams(_id: $leagueId) {
    _id
    name
    user {
      _id
      name
      username
      hasAuctionAccess
      __typename
    }
    lineupPlayers {
      _id
      web_name
      first_name
      second_name
    }
    __typename
  }
}
'@
    $Variables = @"
{
    "leagueId": "$LeagueId"
}
"@
    $Body = '{{"query":"{0}","variables":{1},"operationName":null}}' -f ($Query -replace '"', '\"' -replace "`r?`n", '\n'), $Variables
    $Body = @{
        query         = $Query.Replace('"', '\"')
        variables     = @{
            leagueId = $LeagueId
        }
        operationName = 'LeagueTeams'
    } | ConvertTo-Json -Compress
    $Params = @{
        Uri         = 'https://draftfantasyfootball.co.uk/graphql'
        Method      = 'Post'
        Body        = $Body
        ContentType = 'application/json'
    }

    $Result = Invoke-RestMethod @Params

    $Teams = $Result.data.teams

    $KnownNameChanges = @{
        'Daniel Janny'      = 'Daniel Jansepar'
        'Will L'            = 'Will Lafferty'
        'eddie lyne'        = 'Eddie Lyne'
        'Lee W'             = 'Lee Waller'
        'James Gee'         = 'James Lowenthal'
        'Adam W'            = 'Adam Waller'
        'A-Robert ferguson' = 'Robert Ferguson'
        'rob turner'        = 'Rob Turner'
        'patrick Nielsen'   = 'Patrick Nielsen'
        'James beardsworth' = 'James Beardsworth'
        'david thomas'      = 'David Thomas'
        'tom field'         = 'Tom Field'
        'daniel barber'     = 'Daniel Barber'
        'liam McDonald'     = 'Liam McDonald'
        'Burna Boy'         = 'Daniel Tandy'
    }

    $Output = @"
`t`t`tLeagueId = '$LeagueId'
`t`t`tManagers = @{
"@
    $Output += foreach ($Team in $Teams) {
        if ($Team.user.name -in $KnownNameChanges.Keys) {
            $Name = $KnownNameChanges[$Team.user.name]
        }
        else {
            $Name = $Team.user.name
        }

        if ($Name.Contains("'")) {
            $Quote = '"'
        }
        else {
            $Quote = "'"
        }
        "`r`n`t`t`t`t'{0}' = {1}{2}{1}" -f $Team.user._id, $Quote, $Name
    }

    $Output += @"
`r`n`t`t`t}
`t`t`tTeams    = @{
"@
    $Output += foreach ($Team in $Teams) {
        if ($Team.user.name -in $KnownNameChanges.Keys) {
            $Name = $KnownNameChanges[$Team.user.name]
        }
        else {
            $Name = $Team.user.name
        }

        if ($Name.Contains("'")) {
            $Quote = '"'
        }
        else {
            $Quote = "'"
        }
        "`r`n`t`t`t`t'{0}' = {1}{2}{1}" -f $Team._id, $Quote, $Name
    }
    $Output += @"
`r`n`t`t`t}`r`n
"@

    $Output | Set-Clipboard -PassThru
}
