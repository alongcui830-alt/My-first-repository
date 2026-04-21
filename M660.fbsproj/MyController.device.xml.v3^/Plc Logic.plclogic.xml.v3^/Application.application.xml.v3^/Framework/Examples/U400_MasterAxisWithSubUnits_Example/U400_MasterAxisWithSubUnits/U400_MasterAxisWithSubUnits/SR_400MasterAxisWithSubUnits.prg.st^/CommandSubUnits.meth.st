__METADATA__
{
  "v3Meta": {
    "objectGuid": "bff8a34b-d741-4ce1-a3d6-ee8134d4ce40",
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
METHOD PRIVATE CommandSubUnits
VAR_INPUT
END_VAR
__IMPLEMENTATION__
fbSubUnitHandler.i_astSubUnitUpstreamData[c_uiSubUnitA].etState := stSubUnitAOutputData.etPackMlState;
fbSubUnitHandler.i_astSubUnitUpstreamData[c_uiSubUnitB].etState := stSubUnitBOutputData.etPackMlState;

fbSubUnitHandler(
	i_xEnable                  := TRUE,
	i_etState                  := fbPackMlState.etStateCurrent,
	i_xMute                    :=,
	i_astSubUnitUpstreamData   :=,
	q_xActive                  =>,
	q_xReady                   =>,
	q_xSubUnitsAligned         =>,
	q_xActingStateConcluded    =>,
	q_astSubUnitDownstreamData =>
);
IF NOT fbSubUnitHandler.i_xMute THEN
	stSubUnitAInputData.etCmd := fbSubUnitHandler.q_astSubUnitDownstreamData[c_uiSubUnitA].etCmd;
	stSubUnitBInputData.etCmd := fbSubUnitHandler.q_astSubUnitDownstreamData[c_uiSubUnitB].etCmd;
END_IF

// reset SubUnit command delay, so it only has to be set in state where it is needed
fbSubUnitHandler.i_xMute := FALSE;
fbDiagSender.SetErrorData(
	i_xActive     := NOT fbSubUnitHandler.q_xSubUnitsAligned,
	i_diDiagCode  := TO_DINT(ET_Result.SubUnitNotAlligned),
	i_sMessage    := TO_STRING(ET_Result.SubUnitNotAlligned),
	i_uiSeverity  := ET_DiagSeverity.Error,
	i_udiSourceId := i_stConfiguration.uiUnitId,
	i_sSource     := 'SE_AFU:SubUnitHandler'
);
