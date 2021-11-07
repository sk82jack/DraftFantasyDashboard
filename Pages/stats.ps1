New-UDPage -Name 'Stats' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Current Gameweek Stats' -Content {
                    New-UDChart -Title 'Total League Points' -Type Bar -Endpoint {
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League       = $_
                                WeeklyPoints = ($Cache:Tables[$_].WeeklyScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty WeeklyPoints -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Weekly League Points' -Type HorizontalBar -Endpoint {
                        $AllLeaguePoints = $Cache:LeaguePoints.Values | ForEach-Object {$_}
                        $Properties = $AllLeaguePoints[0] | Get-Member -MemberType NoteProperty | Where-Object Name -match '^Gameweek(\d+)?points$' | Select-Object -Expand Name

                        $StructuredPoints = foreach ($Manager in $AllLeaguePoints) {
                            $Properties | Foreach-Object {
                                $Gameweek = $_ -replace '^Gameweek' -replace 'points$'
                                if (-not $Gameweek) {
                                    $Gameweek = $Cache:CurrentGameweek
                                }

                                [pscustomobject]@{
                                    Manager      = $Manager.Manager
                                    WeeklyPoints = $Manager.$_
                                    Gameweek     = $Gameweek
                                }
                            }
                        }

                        $StructuredPoints | Sort-Object -Descending WeeklyPoints | Select-Object -First 10 | Out-UDChartData -DataProperty WeeklyPoints -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }
                }
                New-UDTab -Text 'Current Season Stats' -Content {
                    New-UDChart -Title 'Total League Points' -Type Bar -Endpoint {
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League      = $_
                                TotalPoints = ($Cache:Tables[$_].TotalScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty TotalPoints -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Individual League Points' -Type HorizontalBar -Endpoint {
                        $Cache:Tables.Values | ForEach-Object {$_} | Sort-Object -Descending TotalScore | Select-Object -First 10 | Out-UDChartData -DataProperty TotalScore -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Top 10 Individual League Points Against' -Type HorizontalBar -Endpoint {
                        $Cache:Tables.Values | ForEach-Object {$_} | Sort-Object -Descending TotalScoreAgainst | Select-Object -First 10 | Out-UDChartData -DataProperty TotalScoreAgainst -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }
                }
            }
        }
    }
}
