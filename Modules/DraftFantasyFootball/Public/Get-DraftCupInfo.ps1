function Get-DraftCupInfo {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $StartGameweek,

        # The gameweek that double elminations occur until (including)
        [Parameter()]
        [int]
        $DoubleEliminationUntil,

        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS')]
        [string[]]
        $Leagues,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $CupFile = Join-Path -Path $PSScriptRoot -ChildPath "..\Data\$Year\LeagueCup.xml"
    if (Test-Path -Path $CupFile) {
        Import-DraftData -Cup -Year $Year
        return
    }

    if (-not $StartGameweek) {
        $StartGameweek = $Script:ConfigData[$Year]['Cup']['StartGameweek']
        Write-Verbose "StartGameweek: $StartGameweek"
    }

    if (-not $DoubleEliminationUntil) {
        $DoubleEliminationUntil = $Script:ConfigData[$Year]['Cup']['DoubleEliminationUntil']
        Write-Verbose "DoubleEliminationUntil: $DoubleEliminationUntil"
    }

    if (-not $Leagues) {
        $Leagues = $Script:ConfigData[$Year]['Cup']['Leagues']
        Write-Verbose "Leagues: $($Leagues -join ', ')"
    }

    $CurrentGW = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    if (-not $CurrentGW) {
        $CurrentGW = 38
    }
    elseif ($CurrentGW -gt 38) {
        $CurrentGW += -9
    }

    if ($CurrentGW -lt $StartGameweek) {
        $ScoreGameweeks = $CurrentGW
        $StartGameweek = $CurrentGW
    }
    else {
        $ScoreGameweeks = $StartGameweek..$CurrentGW
    }

    $Scores = foreach ($League in $Leagues) {
        Get-DraftLeaguePoints -League $League -Gameweek $ScoreGameweeks
    }

    $CupHash = @{}
    $CupHash[$StartGameweek] = $Scores | Sort-Object -Property "Gameweek$($StartGameweek)points" -Descending | Select-Object -ExcludeProperty 'Gameweekpoints' -Property *, @{
        Name       = 'Gameweekpoints'
        Expression = {$_."Gameweek$($StartGameweek)points"}
    }
    $EliminatedManagers = [System.Collections.Generic.List[string]]::new()

    if ($CurrentGW -eq $StartGameweek) {
        $CupHash
        return
    }

    foreach ($Gameweek in ($StartGameweek + 1)..$CurrentGW) {
        # The eliminations are worked out on the following week so if the eliminations are to GW 13 inclusive then
        # we still need +2 on GW 14 for the calculation of GW 13 eliminations
        if ($Gameweek -le ($DoubleEliminationUntil + 1)) {
            $EliminationNumber += 2
        }
        else {
            $EliminationNumber += 1
        }

        if ($EliminationNumber -eq $Scores.Count) {
            $EliminationNumber -= 1
        }

        $LastGameweek = $Gameweek - 1
        $LastGameweekRanking = $CupHash[$LastGameweek]
        $LastCutOffScore = $LastGameweekRanking[ - $EliminationNumber]."Gameweekpoints"
        $LastCutoffManager = $LastGameweekRanking.Where( {$_."Gameweekpoints" -eq $LastCutoffScore}, 'SkipUntil')

        if ($LastCutoffManager.Count -eq $EliminationNumber) {
            $LastCutoffManager | Add-Member -MemberType NoteProperty -Name Eliminated -Value $true
            $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
            $EliminationNumber = 0
        }
        else {
            $UniqueScores = $LastCutoffManager."Gameweekpoints" | Sort-Object -Unique

            if ($UniqueScores.count -ne 1) {
                $LastCutoffManager = foreach ($Score in $UniqueScores) {
                    $ScoreManager = $LastCutoffManager.Where{$_."Gameweekpoints" -eq $Score}

                    if ($ScoreManager.Count -lt $EliminationNumber) {
                        $ScoreManager
                        $EliminationNumber = $EliminationNumber - $ScoreManager.Count
                    }
                }
                $LastCutoffManager | Add-Member -MemberType NoteProperty -Name Eliminated -Value $true
                $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
            }
        }

        $Scores = $Scores.Where{
            $_.Manager -notin $EliminatedManagers
        }

        $Properties = [System.Collections.Generic.List[psobject]]@(
            '*'
            @{
                Name       = 'Gameweekpoints'
                Expression = {$_."Gameweek$($Gameweek)points"}
            }
            @{
                Name       = 'Winner'
                Expression = {$false}
            }
        )

        if (@($Scores).Count -eq 1) {
            $Properties[2]['Expression'] = {$true}
        }

        $CupHash[$Gameweek] = $Scores | Sort-Object -Property "Gameweek$($Gameweek)points" -Descending | Select-Object -ExcludeProperty 'Gameweekpoints' -Property $Properties

        if (@($Scores).Count -eq 1) {
            break
        }
    }
    $CupHash
}
