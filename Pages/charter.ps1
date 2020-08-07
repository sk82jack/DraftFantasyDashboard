New-UDPage -Name 'Charter' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UdHtml -Markup "<iframe
                    src='https://docs.google.com/document/d/1tNLMUNix_D2qVk-_Z7bb0nN6l5mcRHfw6liZzMt4lwY/pub?embedded=true'
                        style=
                            'background-color:white;
                            border:none;
                            width: 100%;
                            min-height: 600px;'>
                    </iframe>"
        }
    }
}
