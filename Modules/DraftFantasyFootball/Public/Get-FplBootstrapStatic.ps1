function Get-FplBootstrapStatic {
    [CmdletBinding()]
    param ()
    Invoke-RestMethod -Uri 'https://fantasy.premierleague.com/api/bootstrap-static/'
}
