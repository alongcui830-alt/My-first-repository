__METADATA__
{
  "v3Meta": {
    "objectGuid": "1524aa1d-81f4-4d20-9c8b-7b6c7e615973",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbDiagHandler.InitHandler(i_udiId := 0, i_sName := 'Application_100', i_ifParent := 0);
fbDiagHandler.RegisterListener(i_ifDiagnosticListener := fbActiveDiagnostics);

stSubUnitConfigData.uiUnitId            := 1;
stSubUnitConfigData.sUnitName           := '100_SmallUnit';
stSubUnitConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitConfigData.ifParentDiagHandler := fbDiagHandler;
SR_100SmallUnit.i_stConfiguration := stSubUnitConfigData;
