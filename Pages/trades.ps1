New-UDPage -Name 'Trades' -Icon exchange_alt -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:PremTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:PremTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:PremWaiver | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:FreakTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:FreakTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:FreakWaiver | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:VerminTrades | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:VerminTrades | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:VerminWaiver | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
            }
        }
    }
}
