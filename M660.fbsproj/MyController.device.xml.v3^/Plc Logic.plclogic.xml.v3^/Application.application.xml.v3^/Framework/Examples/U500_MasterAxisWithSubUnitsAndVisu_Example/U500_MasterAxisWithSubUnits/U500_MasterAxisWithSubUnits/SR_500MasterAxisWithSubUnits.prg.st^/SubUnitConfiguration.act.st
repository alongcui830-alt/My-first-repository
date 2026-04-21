__METADATA__
{
  "v3Meta": {
    "objectGuid": "1e485f16-be04-4051-b6e5-dfb0b53cbeef",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
{region 'SubUnit A'}
stSubUnitAConfigData.uiUnitId            := i_stConfiguration.uiUnitId * 100 + c_uiSubUnitA;
stSubUnitAConfigData.sUnitName           := 'SubUnit A';
stSubUnitAConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitAConfigData.ifParentDiagHandler := fbDiagHandler;
stSubUnitAConfigData.ifMasterAxis        := fbMasterAxisInstance;
stSubUnitAConfigData.ifAxis              := i_stConfiguration.ifAxisA;
stSubUnitAConfigData.ifParentVisManager  := fbVisManager; 
// ... Application specific configuration
SR_510SubUnitA.i_stConfiguration := stSubUnitAConfigData;
{endregion}

{region 'SubUnit B'}
stSubUnitBConfigData.uiUnitId            := i_stConfiguration.uiUnitId * 100 + c_uiSubUnitB;
stSubUnitBConfigData.sUnitName           := 'SubUnit B';
stSubUnitBConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitBConfigData.ifParentDiagHandler := fbDiagHandler;
stSubUnitBConfigData.ifMasterAxis        := fbMasterAxisInstance;
stSubUnitBConfigData.ifAxis              := i_stConfiguration.ifAxisB;
stSubUnitBConfigData.ifParentVisManager  := fbVisManager; 
// ... Application specific configuration
SR_520SubUnitB.i_stConfiguration := stSubUnitBConfigData;
{endregion}
