__METADATA__
{
  "v3Meta": {
    "objectGuid": "049fdfa1-d827-43de-9f4d-208c436aa7a2",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD PRIVATE InputVerification
VAR
END_VAR
__IMPLEMENTATION__
fbDiagSender.SetErrorData(
	i_xActive :=
		NOT i_stInputData.xEnable AND
		NOT (fbPackMlState.etStateCurrent = PackML.ET_States.Aborted) AND
		NOT (fbPackMlState.etStateCurrent = PackML.ET_States.Aborting),
	i_diDiagCode  := TO_DINT(ET_Result.EnableLost),
	i_sMessage    := TO_STRING(ET_Result.EnableLost),
	i_uiSeverity  := ET_DiagSeverity.FatalError,
	i_udiSourceId := i_stConfiguration.uiUnitId,
	i_sSource     := i_stConfiguration.sUnitName
);
