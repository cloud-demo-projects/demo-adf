@minLength(3)
@maxLength(63)
@description('The name of the Azure Data Factory.')
param FactoryName string 

@description('The location of the Virtual Machine.')
param location string = resourceGroup().location

 @description('The location of the Virtual Machine.')
 param vaultBaseUrl string 

@description('The name of the key with Get, Unwrap key and Wrap key permissions.')
param keyName string 

@description('The current version of the ADF key.')
param keyVersion string = 'd26e0c21fd0446e7aada06f04ec1103f'

@description('The name of the user assigned identity.')
param identityName string 

@description('userManagedIdentity resource id to be lined with DataFactory.')
param userManagedIdentity string 

resource ADF 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: FactoryName
  location: location
    identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {'${userManagedIdentity}${identityName}': {}
    }
  }
  properties: {
    encryption: {
      identity: {
        userAssignedIdentity: '${userManagedIdentity}${identityName}'
      }
      vaultBaseUrl: vaultBaseUrl
      keyName: keyName
      keyVersion: keyVersion
    }
    publicNetworkAccess: 'Disabled'
  }
}
