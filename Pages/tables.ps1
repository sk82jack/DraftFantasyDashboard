New-UDPage -Name 'Tables' -Icon futbol -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -MediumOffset 2 -LargeSize 6 -LargeOffset 3 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        Get-DraftLeagueTable -League 'Prem' | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        Get-DraftLeagueTable -League 'Freak' | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        Get-DraftLeagueTable -League 'Vermin' | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
            }
        }
    }
}
