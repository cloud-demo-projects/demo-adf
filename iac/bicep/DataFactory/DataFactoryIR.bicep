@description('The name of the existing Data Factory.')
param FactoryName string 

@description('Name of the integration runtime in Data Factory.')
param irADFName string 


resource existingDataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: FactoryName
}

resource symbolicname 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: irADFName
  parent: existingDataFactory
  properties: {
    description: 'Integration Runtime for Data Factory'
    type: 'SelfHosted'
    //see IntegrationRuntime objects
  }
}
