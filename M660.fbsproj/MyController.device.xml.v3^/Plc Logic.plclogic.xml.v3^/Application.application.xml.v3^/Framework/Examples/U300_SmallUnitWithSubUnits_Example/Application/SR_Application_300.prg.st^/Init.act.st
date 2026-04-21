__METADATA__
{
  "v3Meta": {
    "objectGuid": "69bdc2b5-0006-4277-9ef5-2f6c502c2d36",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbDiagHandler.InitHandler(i_udiId := 0, i_sName := 'Application_300', i_ifParent := 0);
fbDiagHandler.RegisterListener(i_ifDiagnosticListener := fbActiveDiagnostics);

stSubUnitConfigData.uiUnitId            := 1;
stSubUnitConfigData.sUnitName           := '300_SmallUnitWithSubUnits';
stSubUnitConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitConfigData.ifParentDiagHandler := fbDiagHandler;
SR_300SmallUnitWithSubUnits.i_stConfiguration := stSubUnitConfigData;
