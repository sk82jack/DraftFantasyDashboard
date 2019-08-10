function ConvertTo-DraftObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $InputObject,

        [Parameter(Mandatory)]
        [ValidateSet(
            'HeadToHead', 'LeagueTable', 'Trade', 'Team', 'Player', 'WaiverOrder'
        )]
        [string]
        $Type,

        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    switch ($Type) {
        'HeadToHead' {}
        'LeagueTable' {}
        'Trade' {}
        'Team' {}
        'Player' {
            if ($League) {
                $Teams = Get-DraftTeam -League $League
            }
        }
        'WaiverOrder' {
            foreach ($Manager in $InputObject) {
                [PSCustomObject]@{
                    Manager = $Script:ConfigData[$League]['Teams'][$Manager]
                }
            }
            return
        }
    }

    foreach ($Object in $InputObject) {
        $Hashtable = Convert-DiacriticProperties -Object $Object

        switch ($Type) {
            'HeadToHead' {
                $Hashtable['Manager1'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team1Id']]
                $Hashtable['Manager2'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team2Id']]
                $Hashtable['Team1score'] = $Hashtable['Team1score'] -as [int]
                $Hashtable['Team2score'] = $Hashtable['Team2score'] -as [int]
            }
            'LeagueTable' {
                $Hashtable['Played'] = [int]$Hashtable['headToHeadData'].played
                $Hashtable['Won'] = $Hashtable['headToHeadData'].won
                $Hashtable['Drawn'] = $Hashtable['headToHeadData'].drawn
                $Hashtable['Lost'] = $Hashtable['headToHeadData'].lost
                $Hashtable['Points'] = $Hashtable['headToHeadData'].headToHeadLeaguepoints
                $Hashtable['Manager'] = $Script:ConfigData[$League]['Managers'][$Hashtable['UserId']]
                $Hashtable['Position'] = $Position += 1
            }
            'Trade' {
                [string]$Hashtable['InManager'] = if ($Hashtable['inTeamId']) {
                    $Script:ConfigData[$League]['Teams'][$Hashtable['inTeamId']]
                }
                $Hashtable['PlayersIn'] = foreach ($Player in $Hashtable['Playersinids']) {
                    $Script:Players.Where{$_.Id -eq $Player}.WebName
                }
                $Hashtable['OutManager'] = $Script:ConfigData[$League]['Teams'][$Hashtable['outTeamId']]
                $Hashtable['PlayersOut'] = foreach ($Player in $Hashtable['Playersoutids']) {
                    $Script:Players.Where{$_.Id -eq $Player}.WebName
                }
                foreach ($Property in 'createdAt', 'respondedAt', 'updatedAt') {
                    $Hashtable[$Property] = ConvertFrom-PosixTime -PosixTime $Hashtable[$Property]
                    if (-not $Hashtable[$Property]) {
                        $Hashtable[$Property] = '-'
                    }
                }
                $Hashtable['PlayersIn'] = $Hashtable['PlayersIn'] -join ', '
                $Hashtable['PlayersOut'] = $Hashtable['PlayersOut'] -join ', '
            }
            'Team' {
                $Manager = $Script:ConfigData[$League]['Teams'][$Hashtable.Id]
                $Hashtable['Manager'] = $Manager
                $Hashtable['Players'] = [System.Collections.Generic.List[psobject]]::new()
                foreach ($Player in $Hashtable.LineupPlayers) {
                    $PlayerHash = Convert-DiacriticProperties -Object $Player
                    $PlayerHash['IsSub'] = $False
                    $PlayerHash['Manager'] = $Manager
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
                $Hashtable['Players'] = [System.Collections.Generic.List[psobject]]($Hashtable['Players'] | Sort-Object ElementTypeId)
                foreach ($Player in $Hashtable.SubPlayers) {
                    $PlayerHash = Convert-DiacriticProperties -Object $Player
                    $PlayerHash['IsSub'] = $True
                    $PlayerHash['Manager'] = $Manager
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
            }
            'Player' {
                if ($League) {
                    $OwnedBy = $Teams.Players.Where{$_.Id -eq $Hashtable.Id}[0].Manager
                    $Hashtable['Status'] = if ($OwnedBy) {
                        'Owned'
                    }
                    else {
                        $OwnedBy = '-'
                        switch ($Hashtable['Waiverstatus']) {
                            'blocked' {
                                'Blocked'
                                break
                            }
                            'on_waivers' {
                                'Waivers'
                                break
                            }
                            'off_waivers' {
                                'Free'
                                break
                            }
                        }
                    }
                    $Hashtable['Owner'] = $OwnedBy
                }
            }
            'WaiverOrder' {}
        }
        [pscustomobject]$Hashtable
    }
}
