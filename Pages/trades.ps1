New-UDPage -Name 'Trades' -Icon exchange_alt -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -MediumOffset 2 -LargeSize 6 -LargeOffset 3 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDCollapsible -Items {
                        $Cache:PremTrades = Get-DraftTrade -League 'Prem'
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat') -Endpoint {
                                $Cache:PremTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat', 'Respondedat', 'Status') -Endpoint {
                                $Cache:PremTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                Get-DraftWaiverOrder -League 'Prem' | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDCollapsible -Items {
                        $Cache:FreakTrades = Get-DraftTrade -League 'Freak'
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat') -Endpoint {
                                $Cache:FreakTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat', 'Respondedat', 'Status') -Endpoint {
                                $Cache:FreakTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                Get-DraftWaiverOrder -League 'Freak' | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDCollapsible -Items {
                        $Cache:VerminTrades = Get-DraftTrade -League 'Vermin'
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat') -Endpoint {
                                $Cache:VerminTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'Createdat', 'Respondedat', 'Status') -Endpoint {
                                $Cache:VerminTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                Get-DraftWaiverOrder -League 'Vermin' | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
            }
        }
    }
}
