New-UDPage -Name 'Managers' -Endpoint {
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

                            $ProfilePic = '/profile_pics/{0}.jpg' -f $Team.Manager

                            [PSCustomObject]@{
                                Manager = New-UDElement -Tag 'a' -Attributes @{
                                    onClick = {
                                        Show-UDModal -Content {
                                            $ManagerProfile = Get-ManagerProfile $Team.Manager

                                            New-UDCard -Title $Team.Manager -TitleAlignment center -Image (New-UDImage -Url $ProfilePic -Height 200)
                                            New-UDCard -Title 'POSITION HISTORY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.PositionHistory -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'ACCOLADES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Accolades -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'MANAGERIAL STYLE' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Style -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'BIGGEST RIVALRY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Rivalries -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'QUOTES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Quotes -replace '\r?\n', "`r`n")
                                        }
                                    }
                                    style   = @{
                                        'cursor' = 'pointer'
                                    }
                                } -Content {
                                    New-UDRow -Columns {
                                        New-UDColumn {
                                            New-UDMuAvatar -Image $ProfilePic -Alt $Team.Manager
                                        }
                                        New-UDColumn {
                                            $Team.Manager
                                        }
                                    }
                                }
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

                            $ProfilePic = '/profile_pics/{0}.jpg' -f $Team.Manager

                            [PSCustomObject]@{
                                Manager = New-UDElement -Tag 'a' -Attributes @{
                                    onClick = {
                                        Show-UDModal -Content {
                                            $ManagerProfile = Get-ManagerProfile $Team.Manager

                                            New-UDCard -Title $Team.Manager -TitleAlignment center -Image (New-UDImage -Url $ProfilePic -Height 200)
                                            New-UDCard -Title 'POSITION HISTORY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.PositionHistory -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'ACCOLADES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Accolades -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'MANAGERIAL STYLE' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Style -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'BIGGEST RIVALRY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Rivalries -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'QUOTES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Quotes -replace '\r?\n', "`r`n")
                                        }
                                    }
                                    style   = @{
                                        'cursor' = 'pointer'
                                    }
                                } -Content {
                                    New-UDRow -Columns {
                                        New-UDColumn {
                                            New-UDMuAvatar -Image $ProfilePic -Alt $Team.Manager
                                        }
                                        New-UDColumn {
                                            $Team.Manager
                                        }
                                    }
                                }
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

                            $ProfilePic = '/profile_pics/{0}.jpg' -f $Team.Manager

                            [PSCustomObject]@{
                                Manager = New-UDElement -Tag 'a' -Attributes @{
                                    onClick = {
                                        Show-UDModal -Content {
                                            $ManagerProfile = Get-ManagerProfile $Team.Manager

                                            New-UDCard -Title $Team.Manager -TitleAlignment center -Image (New-UDImage -Url $ProfilePic -Height 200)
                                            New-UDCard -Title 'POSITION HISTORY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.PositionHistory -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'ACCOLADES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Accolades -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'MANAGERIAL STYLE' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Style -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'BIGGEST RIVALRY' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Rivalries -replace '\r?\n', "`r`n")
                                            New-UDCard -Title 'QUOTES' -TitleAlignment center -TextAlignment center -Text ($ManagerProfile.Quotes -replace '\r?\n', "`r`n")
                                        }
                                    }
                                    style   = @{
                                        'cursor' = 'pointer'
                                    }
                                } -Content {
                                    New-UDRow -Columns {
                                        New-UDColumn {
                                            New-UDMuAvatar -Image $ProfilePic -Alt $Team.Manager
                                        }
                                        New-UDColumn {
                                            $Team.Manager
                                        }
                                    }
                                }
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
