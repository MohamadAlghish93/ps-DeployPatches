# ps-DeployPatches

## Table of Contents
- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration Files](#configuration-files)
  - [ServersList.csv](#serverslistcsv)
  - [FileTypes.csv](#filetypescsv)
  - [FilesToDeploy.csv](#filestodeploycsv)
- [Issue](#issue)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Description
ps-DeployPatches is a PowerShell-based project designed to automate the deployment of patches to various servers. This project uses CSV configuration files to define server lists, file types, and files to be deployed.

## Installation
To install and set up this project locally, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/MohamadAlghish93/ps-DeployPatches.git
    cd ps-DeployPatches
    ```

2. Ensure you have PowerShell installed on your machine.

## Usage
To use the deployment scripts, execute the main PowerShell script with the appropriate parameters. Below is an example of how to run the script:

```powershell
# Example usage
.\DeployPatches.ps1 -ConfigPath "path\to\config"
```

## Configuration Files

### ServersList.csv
This file contains the list of servers where patches will be deployed.

```
IP,Name,Environment
10.30.42.96,Server1,Production
10.30.42.97,Server2,Production
10.30.42.98,Server3,QA
```

### FileTypes.csv
This file defines the types of files and their respective server paths.

```
TypeName,ServerPath,Description
WebJS,C:\inetpub\wwwroot\TarasolSite\Correspondence\javascripts\,JavaScript files for web interface
ViewerJS,C:\inetpub\wwwroot\TarasolSite\Correspondence\H5Viewer\js\,JavaScript files for viewer component
APIBin,C:\inetpub\wwwroot\TarasolAPI4\bin\,DLL files for API
SiteBin,C:\inetpub\wwwroot\TarasolSite\bin\,DLL files for web site
```

### FilesToDeploy.csv
This file lists the files to be deployed and their corresponding types and descriptions.

```
SourcePath,Types,Description
D:\Patches\correspondence.js,WebJS,Main correspondence script
D:\Patches\viewer.js,ViewerJS,Viewer component script
D:\Patches\TarasolAPI.dll,APIBin,API core functionality
D:\Patches\TarasolObject.dll,"SiteBin,APIBin",Object model shared between site and API
D:\Patches\Tarasol.dll,APIBin,Main application library
D:\Patches\TarasolHelper.dll,"SiteBin,APIBin",Helper functions for both components
```

## Issue
If your client and server are not in the same domain, you need to add the remote server to the TrustedHosts list.

Run this on your local machine:

```powershell
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "192.168.83.1" -Force
```

```powershell
Get-Item WSMan:\localhost\Client\TrustedHosts
```

## Contributing
Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) for details on the code of conduct, and the process for submitting pull requests.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements
