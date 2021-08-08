New-UDPage -Name 'Charter' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UdHtml -Markup "
            <div style='background-color:white'>
                $Cache:Charter
            </div>
            "
        }
    }
}
