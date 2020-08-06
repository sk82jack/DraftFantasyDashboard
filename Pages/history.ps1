New-UDPage -Name 'History' -Icon history -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDCollapsible -Items {
                New-UDCollapsibleItem -Title '2020' -FontColor 'White' -Content {
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
                New-UDCollapsibleItem -Title '2019' -FontColor 'White' -Content {
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
                    }
                }
                New-UDCollapsibleItem -Title '2018' -FontColor 'White' -Content {
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
            }
        }
    }
}
