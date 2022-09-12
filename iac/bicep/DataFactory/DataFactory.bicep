//targetScope = 'subscription'

@description('The Azure env into which the resources should be deployed.')
param environmentType string = 'development'

@description('The Azure rg into which the resources should be deployed.')
@maxLength(13)
param rgName string

@description('The Azure rg into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The Azure KV into which the resources should be deployed.')
param keyVaultName string

@description('The SQL Server into which the DB should be deployed.')
param sqlServerName string

@description('The SQL Server Database into which data should be stored.')
param sqlServerDBName string

resource resourceGrp 'Microsoft.Resources/resourceGroups@2020-06-01' existing = {
  name: rgName
  scope: subscription()
}

module keyVaultModule 'modules/keyVault.bicep' = {
  name: 'keyVaultModuleDeploy'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
  dependsOn: [
    resourceGrp
  ]
}

module storageAccountModule 'modules/storageAccount.bicep' = {
  name: 'storageAccountModuleDeploy'
  params: {
    environmentType: environmentType
    location: location
  }
}

module storageBlobModule 'modules/storageBlob.bicep' = {
  name: 'storageBlobModuleDeploy'
  params: {
    sacName: storageAccountModule.outputs.sacName
  }
  dependsOn: [
    storageAccountModule
  ]
}

module sqlServerModule 'modules/sqlServer.bicep' = {
  name: 'sqlServerModuleDeploy'
  params: {
    sqlServerName: sqlServerName
    sqlServerDBName: sqlServerDBName
    location: location
  }
}

