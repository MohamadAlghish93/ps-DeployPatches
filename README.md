# CSV Configuration Files

## ServersList.csv
IP,Name,Environment
10.30.42.96,Server1,Production
10.30.42.97,Server2,Production
10.30.42.98,Server3,QA

## FileTypes.csv
TypeName,ServerPath,Description
WebJS,C:\inetpub\wwwroot\TarasolSite\Correspondence\javascripts\,JavaScript files for web interface
ViewerJS,C:\inetpub\wwwroot\TarasolSite\Correspondence\H5Viewer\js\,JavaScript files for viewer component
APIBin,C:\inetpub\wwwroot\TarasolAPI4\bin\,DLL files for API
SiteBin,C:\inetpub\wwwroot\TarasolSite\bin\,DLL files for web site

## FilesToDeploy.csv
SourcePath,Types,Description
D:\Patches\correspondence.js,WebJS,Main correspondence script
D:\Patches\viewer.js,ViewerJS,Viewer component script
D:\Patches\TarasolAPI.dll,APIBin,API core functionality
D:\Patches\TarasolObject.dll,"SiteBin,APIBin",Object model shared between site and API
D:\Patches\Tarasol.dll,APIBin,Main application library
D:\Patches\TarasolHelper.dll,"SiteBin,APIBin",Helper functions for both components

### Issue

- If your client and server are not in the same domain, you need to add the remote server to the TrustedHosts list.

> Run this on your local machine:

```powershell
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "192.168.83.1" -Force
```

```powershell
Get-Item WSMan:\localhost\Client\TrustedHosts
```
