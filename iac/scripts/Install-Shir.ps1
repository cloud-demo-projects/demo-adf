[CmdletBinding()
]
Param (
    [Parameter(Mandatory = $true)]
    [String] $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [String] $DataFactoryName,

    [Parameter(Mandatory = $true)]
    [String] $SelfHostedIntegrationRuntimeName
)

# Get Integration Service
$integrationServices = Get-Service -Name DIAHostService -ErrorAction SilentlyContinue

# Checking if the Integration Service exists
If ($integrationServices) {
    Write-Host "Integration Services allready installed"
}
Else {
    # Download and install the Integration Runtime
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    New-Item -Path "C:\" -Name "Download" -ItemType "Directory" -Force | Out-Null
    $uri = "https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_5.14.8055.1.msi"
    $outFileName = "C:\Download\IntegrationRuntime.msi"

    If (-not (Get-Item -Path $outFileName -ErrorAction "SilentlyContinue")) {
        Invoke-WebRequest -Uri $uri -OutFile $outFileName
    }

    Write-Host "Installing Integration Runtime..."
    msiexec.exe /i $outFileName INSTALLTYPE=AzureTemplate /quiet /norestart

    # Wait for the Integration Runtime Service to start
    Do {
        $integrationServicesRunning = Get-Service -Name DIAHostService -ErrorAction SilentlyContinue
        If ($integrationServicesRunning) {
            $integrationServicesStatus = $integrationServicesRunning.Status
        }
        Else {
            $integrationServicesStatus = "Service not found"
        }
        Start-Sleep -Seconds 15
        Write-Host "Waiting for the Integration Runtime Service to start...."
    }
    While (-not ($integrationServicesStatus -eq "Running"))

    Write-Host "Integration Runtime Service is now running!"

    # Setup Azure Datafactory
    Write-Host "Update Integration Runtime in Azure Data Factory"
    Set-AzDataFactoryV2IntegrationRuntime `
        -ResourceGroupName $ResourceGroupName `
        -DataFactoryName $DataFactoryName `
        -Name $SelfHostedIntegrationRuntimeName `
        -Type SelfHosted `
        -Description $SelfHostedIntegrationRuntimeName `
        -Confirm:$false `
        -Force

    $key = Get-AzDataFactoryV2IntegrationRuntimeKey `
        -ResourceGroupName $ResourceGroupName `
        -DataFactoryName $DataFactoryName `
        -Name $SelfHostedIntegrationRuntimeName

    $integrationRuntimeKey = $key.AuthKey1

    # Setup integration runtime on the VM
    Write-Host "Setting up the local VM for Integration Runtime"
    $keyReg = Get-Item "hklm:\Software\Microsoft\DataTransfer\DataManagementGateway\ConfigurationManager"
    $filePath = $keyReg.GetValue("DiacmdPath")
    Start-Process -FilePath $filePath -ArgumentList "-Stop" -Wait -PassThru -NoNewWindow
    Start-Process -FilePath $filePath -ArgumentList "-Start" -Wait -PassThru -NoNewWindow
    Start-Process -FilePath $filePath -ArgumentList "-EnableRemoteAccess 8060" -Wait -PassThru -NoNewWindow
    Start-Process -FilePath $filePath -ArgumentList "-RegisterNewNode $integrationRuntimeKey" -Wait -PassThru -NoNewWindow
    Start-Process -FilePath $filePath -ArgumentList "-Key $integrationRuntimeKey" -Wait -PassThru -NoNewWindow
}
