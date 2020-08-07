New-UDPage -Name 'Cup' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            $Cache:AllCupRounds = [int[]]$Cache:CupInfo.Keys
            $CupRounds = $Cache:AllCupRounds | Measure-Object -Maximum -Minimum
            if ($Cache:CupInfo[[int]$CupRounds.Maximum].Winner) {
                New-UDCard -Title 'CUP WINNER' -Size 'small' -FontColor 'White' -TextSize Large -Text $Cache:CupInfo[[int]$CupRounds.Maximum].Manager -TextAlignment 'center'
                $Cache:AllCupRounds = $Cache:AllCupRounds -ne $CupRounds.Maximum
            }
            else {
                New-UDTable -Title "Round $([int]$Cache:CurrentGameweek - 5) Cup Rankings" -Headers @("Manager", "Round Points") -Endpoint {
                    $Cache:CupInfo[[int]$Cache:CurrentGameweek] | Out-UDTableData -Property @("Manager", "Gameweekpoints")
                }
            }

            New-UDTable -Title "Cup History" -Headers @("Round", "Eliminated", "Round Rankings") -Endpoint {
                $Output = foreach ($Gameweek in $Cache:AllCupRounds) {
                    if ($Gameweek -eq [int]$Cache:CurrentGameweek) {
                        continue
                    }

                    $Eliminated = (
                        $Cache:CupInfo[$Gameweek].Where{$_.Eliminated} | Foreach-Object {
                            '{0} ({1})' -f $_.Manager, $_.Gameweekpoints
                        }
                    ) -join ', '

                    if (-not $Eliminated) {
                        $Eliminated = 'N/A'
                    }

                    $RoundNumber = $Gameweek - 5
                    $ViewRankingsEndpoint = New-UDEndpoint -ArgumentList $Cache:CupInfo[$Gameweek] -Endpoint {
                        Show-UDModal -Content {
                            New-UDTable -Title "Round $RoundNumber Cup Rankings" -Headers @("Manager", "Round Points") -Content {
                                $ArgumentList | Out-UDTableData -Property @("Manager", "Gameweekpoints")
                            }
                        }
                    }

                    [PSCustomObject]@{
                        Round        = $RoundNumber
                        Eliminated   = $Eliminated
                        ViewRankings = New-UDButton -Text "Round $RoundNumber Rankings" -OnClick $ViewRankingsEndpoint
                    }
                }

                $Output | Out-UDTableData -Property @("Round", "Eliminated", "ViewRankings")
            }
        }
    }
}
