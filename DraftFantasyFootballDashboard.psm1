function Start-Dashboard {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $Port = 8585,

        [Parameter()]
        [string]
        $CertificatePath
    )
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "Pages/fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "Pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $Images = @{}
    foreach ($File in (Get-ChildItem -Path $PSScriptRoot/Images)) {
        $Images[$File.BaseName] = Join-Path -Path $PSScriptRoot -ChildPath ('Images/{0}' -f $File.Name)
    }

    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules/DraftFantasyFootball/DraftFantasyFootball.psd1' -Variable 'Images'
    $Theme = Get-UDTheme Azure

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    $EveryHour = New-UDEndpoint -Schedule (New-UDEndpointSchedule -Every 1 -Hour) -Endpoint {
        $Cache:CurrentGameweek = (Get-FplBootstrapStatic).events.Where{$_.is_current}.id
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
        $Cache:CupInfo = Get-DraftCupInfo
    }

    $StartDashboardSplat = @{
        Dashboard = $Dashboard
        Port      = $Port
        Wait      = $true
        EndPoint  = $EveryHour
    }
    if ($CertificatePath) {
        $StartDashboardSplat['Cert'] = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($CertificatePath)
    }
    try {
        Start-UDDashboard @StartDashboardSplat
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
