New-UDPage -Name 'Cup' -Icon trophy -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTable -Title "Round $([int]$Cache:CurrentGameweek - 5) Cup Rankings" -Headers @("Manager", "Round Points") -Endpoint {
                $Cache:CupInfo[[int]$Cache:CurrentGameweek] | Out-UDTableData -Property @("Manager", "Gameweekpoints")
            }
            New-UDTable -Title "Cup History" -Headers @("Round", "Eliminated", "Round Rankings") -Endpoint {
                $Output = foreach ($Gameweek in $Cache:CupInfo.Keys) {
                    if ($Gameweek -eq [int]$Cache:CurrentGameweek) {
                        continue
                    }

                    $Eliminated = ($Cache:CupInfo[$Gameweek].Where{$_.Eliminated} | Foreach-Object {
                        '{0} ({1})' -f $_.Manager, $_.Gameweekpoints
                    }) -join ', '

                    if (-not $Eliminated) {
                        $Eliminated = 'N/A'
                    }

                    $ViewRankingsEndpoint = New-UDEndpoint -ArgumentList $Cache:CupInfo[$Gameweek] -Endpoint {
                        Show-UDModal -Content {
                            New-UDTable -Title "Round $($Gameweek - 5) Cup Rankings" -Headers @("Manager", "Round Points") -Content {
                                $ArgumentList | Out-UDTableData -Property @("Manager", "Gameweekpoints")
                            }
                        }
                    }

                    [PSCustomObject]@{
                        Round        = $Gameweek - 5
                        Eliminated   = $Eliminated
                        ViewRankings = New-UDButton -Text "Round Rankings" -OnClick $ViewRankingsEndpoint
                    }
                }

                $Output | Out-UDTableData -Property @("Round", "Eliminated", "ViewRankings")
            }
        }
    }
}
