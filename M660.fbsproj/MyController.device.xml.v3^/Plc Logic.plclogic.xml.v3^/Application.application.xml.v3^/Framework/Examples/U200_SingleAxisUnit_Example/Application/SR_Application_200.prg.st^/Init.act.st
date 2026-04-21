__METADATA__
{
  "v3Meta": {
    "objectGuid": "32ce37f4-0d3b-4b0d-9bc0-9d7dc7649faf",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbDiagHandler.InitHandler(i_udiId := 0, i_sName := 'Application', i_ifParent := 0);

fbDiagHandler.RegisterListener(i_ifDiagnosticListener := fbActiveDiagnostics);

stSubUnitConfigData.uiUnitId            := 1;
stSubUnitConfigData.sUnitName           := '200_SingleAxis';
stSubUnitConfigData.ifParentLoggerPoint := fbLoggerPoint;
stSubUnitConfigData.ifParentDiagHandler := fbDiagHandler;
stSubUnitConfigData.ifAxis				:= fbControlledAxis;
	
SR_200SingleAxisUnit.i_stConfiguration := stSubUnitConfigData;






























