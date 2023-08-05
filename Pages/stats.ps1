New-UDPage -Name 'Stats' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Current Season Stats' -Content {
                    New-UDChart -Title 'Total Scores by League' -Type Bar -Endpoint {
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League     = $_
                                TotalScore = ($Cache:Tables[$_].TotalScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty TotalScore -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Individual Scores by League' -Type Line -Endpoint {
                        $ChartData = foreach ($Rank in 1..12) {
                            $RankData = @{
                                Rank = $Rank
                            }
                            foreach ($League in $Cache:Tables.Keys) {
                                $RankData[$League] = $Cache:Tables[$League] | Sort-Object -Descending 'TotalScore' |
                                Select-Object -Index ($Rank - 1) | Select-Object -ExpandProperty 'TotalScore'
                            }
                            [pscustomobject]$RankData
                        }

                        $ChartData | Out-UDChartData -LabelProperty Rank -Dataset @(
                            foreach ($League in $Cache:Tables.Keys) {
                                $Colour = switch -Regex ($League) {
                                    'Prem' { 'Green' }
                                    'Freak' { 'Orange' }
                                    'Vermin' { 'Red' }
                                    'Plankton' { 'Pink' }
                                    'AlgaeN' { 'Blue' }
                                    'AlgaeS' { 'Yellow' }
                                }
                                New-UdChartDataset -DataProperty $League -AdditionalOptions @{fill = $false} -Label $League -BackgroundColor $Colour -BorderColor $Colour
                            }
                        )
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
                        $Sort = 'Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS'
                        $Cache:Tables.Keys | ForEach-Object {
                            [PSCustomObject]@{
                                League      = $_
                                WeeklyScore = ($Cache:Tables[$_].WeeklyScore | Measure-Object -Sum).Sum
                            }
                        } | Sort-Object {$Sort.IndexOf($_.League)} | Out-UDChartData -DataProperty WeeklyScore -LabelProperty League -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }

                    New-UDChart -Title 'Individual Scores by League' -Type Line -Endpoint {
                        $ChartData = foreach ($Rank in 1..12) {
                            $RankData = @{
                                Rank = $Rank
                            }
                            foreach ($League in $Cache:Tables.Keys) {
                                $RankData[$League] = $Cache:Tables[$League] | Sort-Object -Descending 'WeeklyScore' |
                                Select-Object -Index ($Rank - 1) | Select-Object -ExpandProperty 'WeeklyScore'
                            }
                            [pscustomobject]$RankData
                        }

                        $ChartData | Out-UDChartData -LabelProperty Rank -Dataset @(
                            foreach ($League in $Cache:Tables.Keys) {
                                $Colour = switch -Regex ($League) {
                                    'Prem' { 'Green' }
                                    'Freak' { 'Orange' }
                                    'Vermin' { 'Red' }
                                    'Plankton' { 'Pink' }
                                    'AlgaeN' { 'Blue' }
                                    'AlgaeS' { 'Yellow' }
                                }
                                New-UdChartDataset -DataProperty $League -AdditionalOptions @{fill = $false} -Label $League -BackgroundColor $Colour -BorderColor $Colour
                            }
                        )
                    }

                    New-UDChart -Title 'Top 5 Scores' -Type HorizontalBar -Endpoint {
                        $AllLeagueScores = $Cache:Tables.Values | ForEach-Object {$_}
                        $FilteredScores = $AllLeagueScores | Group-Object -Property 'GameweekPoints' | Sort-Object -Property {[int]$_.Name} -Descending | Select-Object -First 5

                        $FilteredScores.Group | ForEach-Object {$_} | Out-UDChartData -DataProperty GameweekPoints -LabelProperty Manager -BackgroundColor '#FF530D' -BorderColor 'black' -HoverBackgroundColor '#FF9F0D'
                    }
                }
            }
        }
    }
}
