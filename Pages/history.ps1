New-UDPage -Name 'History' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDCollapsible -Items {
                New-UDCollapsibleItem -Title '2022 League Standings' -FontColor 'White' -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text 'Prem' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Prem' -DataType 'Standings' -Year 2022 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Freak' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Freak' -DataType 'Standings' -Year 2022 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Vermin' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Vermin' -DataType 'Standings' -Year 2022 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Plankton' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Plankton' -DataType 'Standings' -Year 2022 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                    }
                }
                New-UDCollapsibleItem -Title '2020 League Standings' -FontColor 'White' -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text 'Prem' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Prem' -DataType 'Standings' -Year 2020 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Freak' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Freak' -DataType 'Standings' -Year 2020 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Vermin' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Vermin' -DataType 'Standings' -Year 2020 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                    }
                }
                New-UDCollapsibleItem -Title '2019 League Standings' -FontColor 'White' -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text 'Prem' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Prem' -DataType 'Standings' -Year 2019 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Freak' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Freak' -DataType 'Standings' -Year 2019 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Vermin' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Vermin' -DataType 'Standings' -Year 2019 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                    }
                }
                New-UDCollapsibleItem -Title '2018 League Standings' -FontColor 'White' -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text 'Prem' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Prem' -DataType 'Standings' -Year 2018 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Freak' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Freak' -DataType 'Standings' -Year 2018 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                    }
                }
                New-UDCollapsibleItem -Title '2017 League Standings' -FontColor 'White' -Content {
                    New-UDTabContainer -Tabs {
                        New-UDTab -Text 'Prem' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Prem' -DataType 'Standings' -Year 2017 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                        New-UDTab -Text 'Freak' -Content {
                            New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                                Import-DraftData -League 'Freak' -DataType 'Standings' -Year 2017 | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                            }
                        }
                    }
                }
                New-UDCollapsibleItem -Title 'Points by Draft Order' -FontColor 'White' -Content {
                    New-UdChart -Title "Points by Draft Order" -Type Line -Endpoint {
                        $Leagues = [ordered]@{
                            'Prem 2022'     = Import-DraftData -League Prem -Year 2022 -DataType Picks
                            'Prem 2020'     = Import-DraftData -League Prem -Year 2020 -DataType Picks
                            'Prem 2019'     = Import-DraftData -League Prem -Year 2019 -DataType Picks
                            'Prem 2018'     = Import-DraftData -League Prem -Year 2018 -DataType Picks
                            'Prem 2017'     = Import-DraftData -League Prem -Year 2017 -DataType Picks
                            'Freak 2022'    = Import-DraftData -League Freak -Year 2022 -DataType Picks
                            'Freak 2020'    = Import-DraftData -League Freak -Year 2020 -DataType Picks
                            'Freak 2019'    = Import-DraftData -League Freak -Year 2019 -DataType Picks
                            'Freak 2018'    = Import-DraftData -League Freak -Year 2018 -DataType Picks
                            'Freak 2017'    = Import-DraftData -League Freak -Year 2017 -DataType Picks
                            'Vermin 2022'   = Import-DraftData -League Vermin -Year 2022 -DataType Picks
                            'Vermin 2020'   = Import-DraftData -League Vermin -Year 2020 -DataType Picks
                            'Vermin 2019'   = Import-DraftData -League Vermin -Year 2019 -DataType Picks
                            'Plankton 2022' = Import-DraftData -League Plankton -Year 2022 -DataType Picks
                        }

                        $ChartData = foreach ($Pick in 1..12) {
                            $PickData = @{
                                Pick    = $Pick
                                Average = $null
                            }

                            foreach ($League in $Leagues.Keys) {
                                $Round1CurrentPick = $Leagues[$League].Where{$_.Round -eq 1 -and $_.PickNo -eq $Pick}

                                if (-not $Round1CurrentPick) {
                                    continue
                                }

                                $LeagueName, $Year = $League.split()
                                $Managers = $Leagues[$League] | Group-Object Manager -AsHashTable -AsString
                                $PickData[$League] = ($Managers[$Round1CurrentPick.Manager].PlayerPoints | Measure-Object -Sum).Sum
                            }
                            [pscustomobject]$PickData
                        }

                        foreach ($Object in $ChartData) {
                            $ObjectStats = $Object.psobject.Properties.Where{$_.Name -ne 'Pick'}.Value | Measure-Object -Sum
                            $Object.Average = $ObjectStats.Sum / $ObjectStats.Count
                        }

                        $ChartData | Sort-Object Pick | Out-UDChartData -LabelProperty Pick -Dataset @(
                            foreach ($League in $Leagues.Keys) {
                                $Colour = switch -Regex ($League) {
                                    'Prem' { 'Green' }
                                    'Freak' { 'Orange' }
                                    'Vermin' { 'Red' }
                                    'Plankton' { 'Purple' }
                                }
                                $DataSet = New-UdChartDataset -DataProperty $League -AdditionalOptions @{fill = $false} -Label $League -BackgroundColor $Colour -BorderColor $Colour
                                $DataSet.hidden = $true
                                $DataSet
                            }

                            New-UdChartDataset -DataProperty 'Average' -AdditionalOptions @{fill = $false} -Label 'Average' -BackgroundColor 'Blue' -BorderColor 'Blue'
                        )
                    }
                }
            }
        }
    }
}
