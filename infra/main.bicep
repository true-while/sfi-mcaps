targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string

@description('Current IP')
param IP string

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
  'SecurityControl': 'Ignore'
}


resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module sds 'sds.bicep' = {
  scope: rg
  name: 'SFI'
  params: {
    location: location
    myindentity: principalId
    privateIP: IP
  }
}


output KEYVAULT_ID string = sds.outputs.KEYVAULT_ID
output USER string = sds.outputs.USER
output BLOB_ID string = sds.outputs.BLOB_ID
output COSMOS_NAME string = sds.outputs.COSMOS_NAME
output COSMOS_ROLE1 string =sds.outputs.COSMOS_ROLE1
output COSMOS_ROLE2 string = sds.outputs.COSMOS_ROLE2
output RGNAME string = rg.name
