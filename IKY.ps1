### I KNOW YOU ###
# ps1 script to get information in an specific webserver
# Made by sp1d3rm0rph3us
# Based on DESEC Security's script


param([string]$url)

if (!$url){
	echo "Usage: .\iky.ps1 [url]"
}

### MAIN ###

cls
# BANNER #

$banner = @"
██     ██   ██ ███    ██  ██████  ██     ██     ██    ██  ██████  ██    ██ 
██     ██  ██  ████   ██ ██    ██ ██     ██      ██  ██  ██    ██ ██    ██ 
██     █████   ██ ██  ██ ██    ██ ██  █  ██       ████   ██    ██ ██    ██ 
██     ██  ██  ██  ██ ██ ██    ██ ██ ███ ██        ██    ██    ██ ██    ██ 
██     ██   ██ ██   ████  ██████   ███ ███         ██     ██████   ██████  
"@                                                                           


Write-Host $banner -ForegroundColor DarkRed
Write-Host "- Obliterating your privacy, as usual" -ForegroundColor Red
Start-Sleep -Seconds 1

## SERVER RECON SECTION ##

Write-Host "[*] Getting information on $url..."
Start-Sleep -Seconds 0.5

try {
	$webOptions = Invoke-WebRequest -uri $url -Method Options
	Write-Host "[+] Server's running: " -ForegroundColor Yellow
	Start-Sleep -Seconds 0.2
	$webOptions.headers.server
	Write-Host ""
	Start-Sleep -Seconds 0.2
	Write-Host "[+] Server accepts the following methods: $($webOptions.headers.allow)" -ForegroundColor Yellow
	Write-Host ""
	Start-Sleep -Seconds 0.2
}
catch {

	Write-Host "[-] An error occured while requesting server info: $_" -ForegroundColor DarkRed
}

## HTML PARSING SECTION ##
Write-Host "[*] Getting site's related links..."
Start-Sleep -Seconds 0.5
try {
	$webGet = Invoke-WebRequest -uri $url
	Write-Host "[+] Related URL found in server's webpage: " -ForegroundColor Yellow
	foreach ($link in $webGet.links.href -match "http://|https://") {
		Write-Host "[+] Found: $link)" -ForegroundColor Green
		Start-Sleep -Seconds 0.2
	}
}
catch {
	Write-Host "[-] An error occured while trying to parse the site's HTML: $_" -ForegroundColor DarkRed
}
