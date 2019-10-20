function Start-Dashboard {
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "Pages/fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "Pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $Images = @{}
    foreach ($File in (Get-ChildItem -Path $PSScriptRoot/Images)) {
        $Images[$File.BaseName] = 'Images/{0}' -f $File.Name
    }

    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules/DraftFantasyFootball/DraftFantasyFootball.psd1' -Variable 'Images'
    $Theme = Get-UDTheme Azure

    $Schedule = New-UDEndpointSchedule -Every 1 -Hour
    $EveryHour = New-UDEndpoint -Schedule $Schedule -Endpoint {
        $Cache:PremTeams = Get-DraftTeam -League 'Prem'
        $Cache:FreakTeams = Get-DraftTeam -League 'Freak'
        $Cache:VerminTeams = Get-DraftTeam -League 'Vermin'
        $Cache:PremH2H = Get-DraftHeadToHead -League 'Prem'
        $Cache:FreakH2H = Get-DraftHeadToHead -League 'Freak'
        $Cache:VerminH2H = Get-DraftHeadToHead -League 'Vermin'
        $Cache:PremPlayers = Get-DraftPlayer -League 'Prem'
        $Cache:FreakPlayers = Get-DraftPlayer -League 'Freak'
        $Cache:VerminPlayers = Get-DraftPlayer -League 'Vermin'
        $Cache:PremTable = Get-DraftLeagueTable -League 'Prem'
        $Cache:FreakTable = Get-DraftLeagueTable -League 'Freak'
        $Cache:VerminTable = Get-DraftLeagueTable -League 'Vermin'
        $Cache:PremTrades = Get-DraftTrade -League 'Prem'
        $Cache:FreakTrades = Get-DraftTrade -League 'Freak'
        $Cache:VerminTrades = Get-DraftTrade -League 'Vermin'
        $Cache:PremWaiver = Get-DraftWaiverOrder -League 'Prem'
        $Cache:FreakWaiver = Get-DraftWaiverOrder -League 'Freak'
        $Cache:VerminWaiver = Get-DraftWaiverOrder -League 'Vermin'
    }

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
        EndPoint               = $EveryHour
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    try {
        Start-UDDashboard -Dashboard $Dashboard -Port 8585 -Wait
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
