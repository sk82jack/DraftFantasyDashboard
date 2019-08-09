New-UDPage -Name 'Teams' -Icon 'users' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -MediumOffset 2 -LargeSize 6 -LargeOffset 3 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Prem'
                        foreach ($Team in $Teams) {
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDTable -Headers 'PlayerName' -Content {
                                    $Team.Players | Out-UDTableData -Property 'WebName'
                                }
                            }
                        }
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Freak'
                        foreach ($Team in $Teams) {
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDTable -Headers 'PlayerName' -Content {
                                    $Team.Players | Out-UDTableData -Property 'WebName'
                                }
                            }
                        }
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Vermin'
                        foreach ($Team in $Teams) {
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDTable -Headers 'PlayerName' -Content {
                                    $Team.Players | Out-UDTableData -Property 'WebName'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
