New-UDPage -Name 'Teams' -Icon 'users' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Prem'
                        foreach ($Team in $Teams) {
                            $Subs = $Team.Players.Where{$_.IsSub}
                            $GK = $Team.Players[0..10].Where{$_.ElementTypeId -eq 1}
                            $DEF = $Team.Players[0..10].Where{$_.ElementTypeId -eq 2}
                            $MID = $Team.Players[0..10].Where{$_.ElementTypeId -eq 3}
                            $FWD = $Team.Players[0..10].Where{$_.ElementTypeId -eq 4}
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDRow -Columns {
                                    New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDCard -Title $GK.WebName -Text $GK.TeamAgainst -TextAlignment center -Image (
                                                New-UDImage -Path $Images[$GK.TeamNameShort]
                                            )
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($DEF.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $DEF[0].WebName -Text $DEF[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$DEF[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Defender in $DEF[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($MID.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $MID[1].WebName -Text $MID[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Midfielder in $MID[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($FWD.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Forward in $FWD) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Forward.WebName -Text $Forward.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Forward.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $FWD[0].WebName -Text $FWD[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $FWD[1].WebName -Text $FWD[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 1) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                                New-UDCard -Title $FWD.WebName -Text $FWD.TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD.TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Freak'
                        foreach ($Team in $Teams) {
                            $Subs = $Team.Players.Where{$_.IsSub}
                            $GK = $Team.Players[0..10].Where{$_.ElementTypeId -eq 1}
                            $DEF = $Team.Players[0..10].Where{$_.ElementTypeId -eq 2}
                            $MID = $Team.Players[0..10].Where{$_.ElementTypeId -eq 3}
                            $FWD = $Team.Players[0..10].Where{$_.ElementTypeId -eq 4}
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDRow -Columns {
                                    New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDCard -Title $GK.WebName -Text $GK.TeamAgainst -TextAlignment center -Image (
                                                New-UDImage -Path $Images[$GK.TeamNameShort]
                                            )
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($DEF.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $DEF[0].WebName -Text $DEF[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$DEF[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Defender in $DEF[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($MID.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $MID[1].WebName -Text $MID[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Midfielder in $MID[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($FWD.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Forward in $FWD) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Forward.WebName -Text $Forward.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Forward.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $FWD[0].WebName -Text $FWD[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $FWD[1].WebName -Text $FWD[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 1) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                                New-UDCard -Title $FWD.WebName -Text $FWD.TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD.TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDCollapsible -Items {
                        $Teams = Get-DraftTeam -League 'Vermin'
                        foreach ($Team in $Teams) {
                            $Subs = $Team.Players.Where{$_.IsSub}
                            $GK = $Team.Players[0..10].Where{$_.ElementTypeId -eq 1}
                            $DEF = $Team.Players[0..10].Where{$_.ElementTypeId -eq 2}
                            $MID = $Team.Players[0..10].Where{$_.ElementTypeId -eq 3}
                            $FWD = $Team.Players[0..10].Where{$_.ElementTypeId -eq 4}
                            New-UDCollapsibleItem -Title $Team.Manager -Content {
                                New-UDRow -Columns {
                                    New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDCard -Title $GK.WebName -Text $GK.TeamAgainst -TextAlignment center -Image (
                                                New-UDImage -Path $Images[$GK.TeamNameShort]
                                            )
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($DEF.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Defender in $DEF) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($DEF.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $DEF[0].WebName -Text $DEF[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$DEF[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Defender in $DEF[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Defender.WebName -Text $Defender.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Defender.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($MID.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $MID[1].WebName -Text $MID[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 4) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            foreach ($Midfielder in $MID) {
                                                New-UDColumn -SmallSize 3 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($MID.Count -eq 5) {
                                        New-UDColumn -SmallSize 8 -SmallOffset 2 -Content {
                                            New-UDColumn -SmallSize 2 -SmallOffset 1 {
                                                New-UDCard -Title $MID[0].WebName -Text $MID[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$MID[0].TeamNameShort]
                                                )
                                            }
                                            foreach ($Midfielder in $MID[1..4]) {
                                                New-UDColumn -SmallSize 2 {
                                                    New-UDCard -Title $Midfielder.WebName -Text $Midfielder.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Midfielder.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                New-UDRow -Columns {
                                    if ($FWD.Count -eq 3) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            foreach ($Forward in $FWD) {
                                                New-UDColumn -SmallSize 4 {
                                                    New-UDCard -Title $Forward.WebName -Text $Forward.TeamAgainst -TextAlignment center -Image (
                                                        New-UDImage -Path $Images[$Forward.TeamNameShort]
                                                    )
                                                }
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 2) {
                                        New-UDColumn -SmallSize 6 -SmallOffset 3 -Content {
                                            New-UDColumn -SmallSize 3 -SmallOffset 3 {
                                                New-UDCard -Title $FWD[0].WebName -Text $FWD[0].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[0].TeamNameShort]
                                                )
                                            }
                                            New-UDColumn -SmallSize 3 -Content {
                                                New-UDCard -Title $FWD[1].WebName -Text $FWD[1].TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD[1].TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                    elseif ($FWD.Count -eq 1) {
                                        New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                            New-UDColumn -SmallSize 4 -SmallOffset 4 -Content {
                                                New-UDCard -Title $FWD.WebName -Text $FWD.TeamAgainst -TextAlignment center -Image (
                                                    New-UDImage -Path $Images[$FWD.TeamNameShort]
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
