__METADATA__
{
  "v3Meta": {
    "objectGuid": "ac8efb0f-361f-471c-b70a-8f082a9f011e",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
{region 'SubUnit Alpha'}
stSubUnitAConfigData.uiUnitId            := i_stConfiguration.uiUnitId * 100 + c_uiSubUnitA;
stSubUnitAConfigData.sUnitName           := 'SubUnit A';
stSubUnitAConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitAConfigData.ifParentDiagHandler := fbDiagHandler;
// ... Application specific configuration
SR_310SubUnitA.i_stConfiguration := stSubUnitAConfigData;
{endregion}

{region 'SubUnit Bravo'}
stSubUnitBConfigData.uiUnitId            := i_stConfiguration.uiUnitId * 100 + c_uiSubUnitB;
stSubUnitBConfigData.sUnitName           := 'SubUnit B';
stSubUnitBConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitBConfigData.ifParentDiagHandler := fbDiagHandler;
// ... Application specific configuration
SR_320SubUnitB.i_stConfiguration := stSubUnitBConfigData;
{endregion}
