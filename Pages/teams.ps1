New-UDPage -Name 'Teams' -Icon 'users' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Title 'Team Lineups' -Headers @('Manager', 'Team') -Endpoint {
                        $Output = foreach ($Team in $Cache:Teams['Prem']) {
                            $ViewTeamEndpoint = New-UDEndpoint -ArgumentList $Team -Endpoint {
                                Show-UDModal -Content {
                                    New-UDTable -Title "Starting XI" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{-not $_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                    New-UDTable -Title "Subs" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{$_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                }
                            }

                            [PSCustomObject]@{
                                Manager = $Team.Manager
                                Team    = New-UDButton -Text 'Team' -OnClick $ViewTeamEndpoint
                            }
                        }

                        $Output | Out-UDTableData -Property @('Manager', 'Team')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Title 'Team Lineups' -Headers @('Manager', 'Team') -Endpoint {
                        $Output = foreach ($Team in $Cache:Teams['Freak']) {
                            $ViewTeamEndpoint = New-UDEndpoint -ArgumentList $Team -Endpoint {
                                Show-UDModal -Content {
                                    New-UDTable -Title "Starting XI" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{-not $_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                    New-UDTable -Title "Subs" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{$_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                }
                            }

                            [PSCustomObject]@{
                                Manager = $Team.Manager
                                Team    = New-UDButton -Text 'Team' -OnClick $ViewTeamEndpoint
                            }
                        }

                        $Output | Out-UDTableData -Property @('Manager', 'Team')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Title 'Team Lineups' -Headers @('Manager', 'Team') -Endpoint {
                        $Output = foreach ($Team in $Cache:Teams['Vermin']) {
                            $ViewTeamEndpoint = New-UDEndpoint -ArgumentList $Team -Endpoint {
                                Show-UDModal -Content {
                                    New-UDTable -Title "Starting XI" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{-not $_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                    New-UDTable -Title "Subs" -Headers @('Name', 'Team', 'Position', 'Upcoming Fixture') -Content {
                                        $ArgumentList.Players.Where{$_.IsSub} | Out-UDTableData -Property @('WebName', 'TeamNameShort', 'Position', 'TeamAgainst')
                                    }
                                }
                            }

                            [PSCustomObject]@{
                                Manager = $Team.Manager
                                Team    = New-UDButton -Text 'Team' -OnClick $ViewTeamEndpoint
                            }
                        }

                        $Output | Out-UDTableData -Property @('Manager', 'Team')
                    }
                }
            }
        }
    }
}
