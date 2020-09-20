New-UDPage -Name 'Cup' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            $Cache:AllCupRounds = [int[]]$Cache:CupInfo.Keys
            $CupRounds = $Cache:AllCupRounds | Measure-Object -Maximum -Minimum
            if ($Cache:CupInfo[[int]$CupRounds.Maximum].Winner -eq $true) {
                New-UDCard -Title 'CUP WINNER' -Size 'small' -FontColor 'White' -TextSize Large -Text $Cache:CupInfo[[int]$CupRounds.Maximum].Manager -TextAlignment 'center'
                $Cache:AllCupRounds = $Cache:AllCupRounds -ne $CupRounds.Maximum
            }
            else {
                New-UDTable -Title "Gameweek $Cache:CurrentGameweek Cup Rankings" -Headers @("Manager", "Gameweek Points") -Endpoint {
                    $Cache:CupInfo[[int]$Cache:CurrentGameweek] | Out-UDTableData -Property @("Manager", "Gameweekpoints")
                }
            }

            New-UDTable -Title "Cup History" -Headers @("Gameweek", "Eliminated", "Gameweek Rankings") -Endpoint {
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

                    $ViewRankingsEndpoint = New-UDEndpoint -ArgumentList $Cache:CupInfo[$Gameweek] -Endpoint {
                        Show-UDModal -Content {
                            New-UDTable -Title "Gameweek $Gameweek Cup Rankings" -Headers @("Manager", "Gameweek Points") -Content {
                                $ArgumentList | Out-UDTableData -Property @("Manager", "Gameweekpoints")
                            }
                        }
                    }

                    [PSCustomObject]@{
                        Gameweek     = $Gameweek
                        Eliminated   = $Eliminated
                        ViewRankings = New-UDButton -Text "Gameweek $Gameweek Rankings" -OnClick $ViewRankingsEndpoint
                    }
                }

                $Output | Out-UDTableData -Property @("Gameweek", "Eliminated", "ViewRankings")
            }

        }
    }
}
