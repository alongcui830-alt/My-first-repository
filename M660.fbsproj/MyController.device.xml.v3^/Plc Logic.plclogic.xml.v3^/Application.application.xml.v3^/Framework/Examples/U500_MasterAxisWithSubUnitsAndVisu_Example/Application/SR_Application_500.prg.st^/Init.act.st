__METADATA__
{
  "v3Meta": {
    "objectGuid": "f61e65c9-3acb-4a10-bb20-80419e8c0a6a",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbDiagHandler.InitHandler(
	i_udiId    := 0,
	i_sName    := 'Application_500',
	i_ifParent := 0);
fbDiagHandler.RegisterListener(i_ifDiagnosticListener := fbActiveDiagnostics);

stSubUnitConfigData.uiUnitId            := 1;
stSubUnitConfigData.sUnitName           := '500_MasterAxisWithSubUnitsAndVisu';
stSubUnitConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitConfigData.ifParentDiagHandler := fbDiagHandler;
stSubUnitConfigData.ifAxisA             := fbAxisA;
stSubUnitConfigData.ifAxisB             := fbAxisB;

stSubUnitConfigData.ifParentVisManager  := fbVisManager;

SR_500MasterAxisWithSubUnits.i_stConfiguration := stSubUnitConfigData;

