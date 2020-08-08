New-UDPage -Name 'Charter' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UdHtml -Markup @'
<iframe
    src='https://docs.google.com/document/d/e/2PACX-1vSusM4Q5LXlVtUn6m8oQ9oemdU2X2XRJQXhM4Xd2e7t4yAaKzdJmUIQTiR39BUT2a3yv4M8raQbCnR6/pub?embedded=true'
    style='
      background-color:white;
      border:none;
      width: 100%;'
    height="1380"
</iframe>
'@
        }
    }
}
