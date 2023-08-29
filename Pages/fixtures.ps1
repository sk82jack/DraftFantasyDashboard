New-UDPage -Name 'Fixtures' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        # Collapsibles with scores, collapsible items with teams
                        $Cache:H2H['Prem'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        $Cache:H2H['Freak'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        $Cache:H2H['Vermin'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Plankton' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        $Cache:H2H['Plankton'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Algae N' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        $Cache:H2H['AlgaeN'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Algae S' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        $Cache:H2H['AlgaeS'].Where{$_.Gameweek -eq $Cache:CurrentGameweek} | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
            }
        }
    }
}
