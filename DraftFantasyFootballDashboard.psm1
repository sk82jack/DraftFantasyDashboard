function Start-Dashboard {
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "pages\fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $Images = @{}
    foreach ($File in (Get-ChildItem -Path .\Images)) {
        $Images[$File.BaseName] = 'Images\{0}' -f $File.Name
    }
    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules\DraftFantasyFootball\DraftFantasyFootball.psd1' -Variable 'Images'
    $Theme = Get-UDTheme Azure
    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    try {
        Start-UDDashboard -Dashboard $Dashboard -Port 10000
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
