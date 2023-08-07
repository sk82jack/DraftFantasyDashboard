function Confirm-DraftLeagueConfig {
    [CmdletBinding()]
    param ()

    $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath '..\Config\Leagues.psd1'
    $Data = Import-PowershellDataFile -Path $ConfigFile

    $Managers = @()
    foreach ($Year in $Data.Keys) {
        foreach ($League in $Data[$Year].Keys) {
            if ($League -eq 'Cup') {
                continue
            }
            foreach ($Manager in $Data[$Year][$League].Managers.Keys) {
                $Existing = $Managers.Where{$_.ID -eq $Manager}
                if ($Existing) {
                    $Existing[0].Name += $Data[$Year][$League].Managers[$Manager]
                    $Existing[0].Name = @($Existing[0].Name | Sort-Object -Unique)
                    $Existing[0].UniqueCount = $Existing[0].Name.Length
                    $Existing[0].TotalCount += 1
                }
                else {
                    $Managers += [pscustomobject]@{
                        ID          = $Manager
                        Name        = @($Data[$Year][$League].Managers[$Manager])
                        TotalCount  = 1
                        UniqueCount = 1
                    }
                }
            }
        }
    }

    $Managers | Sort-Object @{E = 'UniqueCount'; Descending = $true}, @{E = 'TotalCount'; Descending = $false}
    #$Managers.Name | Sort-Object -Unique
}
