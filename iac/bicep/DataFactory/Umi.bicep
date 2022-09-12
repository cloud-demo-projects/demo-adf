@description('The name of the user assigned identity.')
param identityName string 

@description('The location of the Virtual Machine.')
param location string = resourceGroup().location

resource symbolicname 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: identityName
  location: location
}
