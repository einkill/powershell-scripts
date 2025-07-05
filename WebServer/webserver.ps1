$HttpListener = New-Object System.Net.HttpListener
$HttpListener.Prefixes.Add("http://localhost:9090/")
$HttpListener.AuthenticationSchemes = [System.Net.AuthenticationSchemes]::Basic
$HttpListener.Start()

$AuthUser = "rest"
$AuthPassword = "api"
$AuthCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${AuthUser}:${AuthPassword}"))

while ($HttpListener.IsListening) {

    $Context = $HttpListener.GetContext()
    
    $RequestCredentials = $Context.Request.Headers["Authorization"]
        $RequestCredentials = $RequestCredentials -replace "Basic\s"
        if ( $RequestCredentials -ne $AuthCredentials ) {

            $Context.Response.StatusCode = 200
            $Context.Response.ContentType = 'text/HTML'
            $WebContent = Get-Content  -Path 'C:\Training\PShell\inetpub\deny.html' -Encoding UTF8
            $EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
            $Context.Response.OutputStream.Write($EncodingWebContent , 0, $EncodingWebContent.Length)
            $Context.Response.OutputStream.Close()

        }

        else {

            if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {

            $Context.Response.StatusCode = 200
            $Context.Response.ContentType = 'text/HTML'
            $WebContent = Get-Content  -Path 'C:\Training\PShell\inetpub\index.html' -Encoding UTF8
            $EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
            $Context.Response.OutputStream.Write($EncodingWebContent , 0, $EncodingWebContent.Length)
            $Context.Response.OutputStream.Close()

            }

            if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/second.html') {

                $Context.Response.StatusCode = 200
                $Context.Response.ContentType = 'text/HTML'
                $WebContent = Get-Content  -Path 'C:\Training\PShell\inetpub\second.html' -Encoding UTF8
                $EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
                $Context.Response.OutputStream.Write($EncodingWebContent , 0, $EncodingWebContent.Length)
                $Context.Response.OutputStream.Close()

            }

        }

}