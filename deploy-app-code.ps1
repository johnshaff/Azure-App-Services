# Set the variables for app name, resource group, and other parameters
$AppName = "myWebApp77381"
$ResourceGroup = "webAppRG"
$Location = "Canada Central"
$Runtime = "PYTHON:3.9"
$SKU = "B1"
$DeploymentDir = "webapp-quickstart-python-fastapi"

# Store the current directory (which is az-web-app)
$OriginalDir = Get-Location

# Change to the directory containing the app code
Set-Location -Path $DeploymentDir

# Create a resource group
az group create --name $ResourceGroup --location $Location

# Deploy the app from the subdirectory containing the app code
az webapp up `
    --name $AppName `
    --resource-group $ResourceGroup `
    --location $Location `
    --runtime $Runtime `
    --sku $SKU

# Query the web app to check if the startup file is set
Write-Host "Checking if the startup file for the web app is set:" -ForegroundColor DarkGreen
az webapp config show `
    --name $AppName `
    --resource-group $ResourceGroup `
    --query "appCommandLine"

# Return to the original directory (az-web-app)
Set-Location -Path $OriginalDir

# Set the startup file
Write-Host "Setting the startup file for the web app..."
az webapp config set `
    --name $AppName `
    --resource-group $ResourceGroup `
    --startup-file startup.sh

# Query the web app to check if the startup file is set
Write-Host "The startup file for the web app is:" -ForegroundColor DarkGreen
az webapp config show `
    --name $AppName `
    --resource-group $ResourceGroup `
    --query "appCommandLine"

# Restart the web app
az webapp restart --name $AppName --resource-group $ResourceGroup

# Add a five minute wait to allow the web app to restart
Write-Host "Waiting for the web app to restart..." -ForegroundColor DarkGreen
Start-Sleep -s 300

# Generate the URL and output the link
$WebAppURL = "http://$AppName.azurewebsites.net"
Write-Host "Your web app is live at: $WebAppURL"