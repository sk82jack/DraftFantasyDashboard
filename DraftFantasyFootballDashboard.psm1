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
    $ThemeDefinition = Import-PowerShellDataFile -Path (Join-Path $PSScriptRoot '/Themes/DraftFantasy.ps1')
    $Theme = New-UDTheme -Name $ThemeDefinition['Name'] -Definition $ThemeDefinition['Definition']

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    $EveryHour = New-UDEndpoint -Schedule (New-UDEndpointSchedule -Every 1 -Hour) -Endpoint {
        $Cache:CurrentGameweek = (Get-FplBootstrapStatic).events.Where{$_.is_current}.id
        $Cache:Teams = @{
            'Prem'   = Get-DraftTeam -League 'Prem'
            'Freak'  = Get-DraftTeam -League 'Freak'
            'Vermin' = Get-DraftTeam -League 'Vermin'
        }
        $Cache:H2H = @{
            'Prem'   = Get-DraftHeadToHead -League 'Prem'
            'Freak'  = Get-DraftHeadToHead -League 'Freak'
            'Vermin' = Get-DraftHeadToHead -League 'Vermin'
        }
        $Cache:Players = @{
            'Prem'   = Get-DraftPlayer -League 'Prem'
            'Freak'  = Get-DraftPlayer -League 'Freak'
            'Vermin' = Get-DraftPlayer -League 'Vermin'
        }
        $Cache:Tables = @{
            'Prem'   = Get-DraftLeagueTable -League 'Prem'
            'Freak'  = Get-DraftLeagueTable -League 'Freak'
            'Vermin' = Get-DraftLeagueTable -League 'Vermin'
        }
        $Cache:Trades = @{
            'Prem'   = Get-DraftTrade -League 'Prem'
            'Freak'  = Get-DraftTrade -League 'Freak'
            'Vermin' = Get-DraftTrade -League 'Vermin'
        }
        $Cache:Waivers = @{
            'Prem'   = Get-DraftWaiverOrder -League 'Prem'
            'Freak'  = Get-DraftWaiverOrder -League 'Freak'
            'Vermin' = Get-DraftWaiverOrder -League 'Vermin'
        }
        $Cache:CupInfo = Get-DraftCupInfo
    }

    $StartDashboardSplat = @{
        Dashboard = $Dashboard
        Port      = $Port
        Wait      = $true
        EndPoint  = $EveryHour
    }
    if ($CertificatePath) {
        $StartDashboardSplat['Certificate'] = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($CertificatePath)
    }
    try {
        Start-UDDashboard @StartDashboardSplat
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
