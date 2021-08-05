New-UDPage -Name 'Charter' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UdHtml -Markup "
            <div class='responsiveFrame'>
                <iframe
                    src='https://docs.google.com/document/d/e/2PACX-1vQRuKOpjpCzrxiGALWK6NaxtCcHgbewS3gnFoVB3miKn9DNO52SC5baZ2PQko6Ngo1Mf_wWeKGLuLDv/pub?embedded=true'
                    width='290' height='218'
                    frameborder='0'
                    allowfullscreen
                </iframe>
            </div>"
        }
    }
}
