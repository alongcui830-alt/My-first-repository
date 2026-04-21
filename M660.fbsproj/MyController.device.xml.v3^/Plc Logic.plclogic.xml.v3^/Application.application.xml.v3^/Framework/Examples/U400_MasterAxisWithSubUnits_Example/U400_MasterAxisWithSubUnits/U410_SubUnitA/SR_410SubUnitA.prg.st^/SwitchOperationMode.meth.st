__METADATA__
{
  "v3Meta": {
    "objectGuid": "09eee0cd-473f-48be-9c84-740ccfd0bd62",
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
METHOD PRIVATE SwitchOperationMode
VAR
	etResultBuffer   : PackML.ET_Result;
	sResultMsgBuffer : STRING;
END_VAR
__IMPLEMENTATION__
IF fbPackMlState.ifUnitModeCurrent.diValue <> i_stInputData.etOperationMode THEN
	IF
		FC_IsModeChangeAllowed(
			i_etCurrentState := fbPackMlState.etStateCurrent, i_diAllowedModeChanges := fbPackMlState.ifUnitModeCurrent.diStatesModeChangeAllowed
		)
	THEN
		fbPackMlState.CmdChangeUnitMode(i_diValue := i_stInputData.etOperationMode, q_etResult => etResultBuffer, q_sResultMsg => sResultMsgBuffer);
		IF etResultBuffer <> PackML.ET_Result.Ok THEN
			fbDiagSender.SetErrorData(
				i_xActive     := TRUE,
				i_diDiagCode  := TO_DINT(etResultBuffer),
				i_sMessage    := Standard.CONCAT(TO_STRING(etResultBuffer), sResultMsgBuffer),
				i_uiSeverity  := ET_DiagSeverity.Error,
				i_udiSourceId := i_stConfiguration.uiUnitId,
				i_sSource     := 'PackML:PackMLState.cmdChangeUnitMode'
			);
		ELSE
			q_stOutputData.etActiveOperationMode := i_stInputData.etOperationMode;
		END_IF
	END_IF
END_IF
