New-UDPage -Name 'Stats' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Current Season Stats' -Content {
                    New-UDChart -Title 'Total Scores by League' -Type Bar -Endpoint {
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League     = $_
                                TotalScore = ($Cache:Tables[$_].TotalScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty TotalScore -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Total Scores' -Type HorizontalBar -Endpoint {
                        $Cache:Tables.Values | ForEach-Object {$_} | Sort-Object -Descending TotalScore | Select-Object -First 10 | Out-UDChartData -DataProperty TotalScore -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Total Scores Against' -Type HorizontalBar -Endpoint {
                        $Cache:Tables.Values | ForEach-Object {$_} | Sort-Object -Descending TotalScoreAgainst | Select-Object -First 10 | Out-UDChartData -DataProperty TotalScoreAgainst -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Scores in a Single Gameweek' -Type HorizontalBar -Endpoint {
                        $AllLeagueScores = $Cache:LeaguePoints.Values | ForEach-Object {$_}
                        $Properties = $AllLeagueScores[0] | Get-Member -MemberType NoteProperty | Where-Object Name -match '^Gameweek(\d+)?points$' | Select-Object -Expand Name

                        $StructuredScores = foreach ($Manager in $AllLeagueScores) {
                            $Properties | Foreach-Object {
                                $Gameweek = $_ -replace '^Gameweek' -replace 'points$'
                                if (-not $Gameweek) {
                                    $Gameweek = $Cache:CurrentGameweek
                                }

                                [pscustomobject]@{
                                    Manager     = $Manager.Manager
                                    WeeklyScore = $Manager.$_
                                    Gameweek    = $Gameweek
                                }
                            }
                        }

                        $StructuredScores | Sort-Object -Descending WeeklyScore | Select-Object -First 10 | Out-UDChartData -DataProperty WeeklyScore -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }
                }
                New-UDTab -Text 'Current Gameweek Stats' -Content {
                    New-UDChart -Title 'Total Scores by League' -Type Bar -Endpoint {
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League      = $_
                                WeeklyScore = ($Cache:Tables[$_].WeeklyScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty WeeklyScore -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Scores' -Type HorizontalBar -Endpoint {
                        $AllLeagueScores = $Cache:LeaguePoints.Values | ForEach-Object {$_}

                        $AllLeagueScores | Sort-Object -Descending GameweekPoints | Select-Object -First 10 | Out-UDChartData -DataProperty GameweekPoints -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }
                }
            }
        }
    }
}
