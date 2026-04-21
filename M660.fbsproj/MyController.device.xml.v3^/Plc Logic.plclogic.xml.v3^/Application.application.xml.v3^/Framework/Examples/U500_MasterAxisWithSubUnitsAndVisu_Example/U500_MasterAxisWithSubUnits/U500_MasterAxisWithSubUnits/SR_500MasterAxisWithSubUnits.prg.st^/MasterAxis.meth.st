__METADATA__
{
  "v3Meta": {
    "objectGuid": "347cec91-c22e-43d3-a0b7-ab6249501a31",
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
METHOD PRIVATE MasterAxis
VAR_INST
	xErrorBuffer     : BOOL;
	etResultBuffer   : MFB.ET_Result;
	sResultMsgBuffer : STRING;
END_VAR
__IMPLEMENTATION__
IF fbDiagResetState.diState = ET_ResetState.StartReset THEN
	fbMasterAxisMotion.ifAdministrative.ResetError();
END_IF
fbMasterAxisMotion.Cycle(q_xError => xErrorBuffer, q_etResult => etResultBuffer, q_sResultMsg => sResultMsgBuffer);
fbDiagSender.SetErrorData(
	i_xActive     := xErrorBuffer,
	i_diDiagCode  := TO_DINT(etResultBuffer),
	i_sMessage    := Standard.CONCAT(TO_STRING(etResultBuffer), sResultMsgBuffer),
	i_uiSeverity  := SEL(fbMasterAxisMotion.ifGetAxisState.xErrorstop, ET_DiagSeverity.Error, ET_DiagSeverity.FatalError),
	i_udiSourceId := i_stConfiguration.uiUnitId,
	i_sSource     := 'MFB:MasterAxisControl'
);
xDiagQuitOngoing := xDiagQuitOngoing OR fbMasterAxisMotion.ifAdministrative.xGetResetOngoing;
