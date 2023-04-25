$sites =@(
"news.bbc.co.uk",
"www.google.co.uk"
)
#$ErrorActionPreference= 'silentlycontinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12;
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ;
$res=@() #results
#loop through $sites and GetExpirationDateString
foreach ($site in $sites){
try{
    $req = [Net.HttpWebRequest]::Create($site)
    $req.GetResponse() | Out-Null
    }catch{
        Write-Host "`r`n[!]$site error - "$_.Exception.Message" `r`n" -ForegroundColor Red
    }
    $res+=("<b>$($req.ServicePoint.Certificate.GetExpirationDateString())</b> - $($site)<br>")
}

$uri=""
#body of teams message
$body = [Ordered]@{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions>"
    "summary" = "SSL/TLS certificate expiration dates"
    "themeColor" = '336699'
    "title" = "SSL/TLS certificate expiration dates"
    “text” = "$($res)"
}
#POST to $uri - convert $body to json
Invoke-RestMethod -Uri $Uri -Method Post -Body $(ConvertTo-Json $body) -ContentType 'application/json'
