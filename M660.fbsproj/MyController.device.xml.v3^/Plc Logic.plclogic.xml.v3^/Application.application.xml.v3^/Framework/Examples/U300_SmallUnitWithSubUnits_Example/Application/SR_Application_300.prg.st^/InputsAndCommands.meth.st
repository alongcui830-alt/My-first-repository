__METADATA__
{
  "v3Meta": {
    "objectGuid": "12648201-7440-4ba5-8f00-3315d9562411",
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
METHOD PRIVATE InputsAndCommands
VAR CONSTANT
	c_uiHmi		: UINT := 1;
	c_uiVisu	: UINT := 2;
	c_uiScada	: UINT := 3;
END_VAR
__IMPLEMENTATION__
{region "OperationMode"}
fbOperationModeInput.i_aetValues[c_uiHmi]   := stHmiInputs.etOperationModeSelected;
fbOperationModeInput.i_aetValues[c_uiVisu]  := stVisuInputs.etOperationModeSelected;
fbOperationModeInput.i_aetValues[c_uiScada] := stScadaInputs.etOperationModeSelected;
fbOperationModeInput(i_xEnable := TRUE, i_etDefault := ET_OperationMode.Production, q_udiChangedByChannel => );
{endregion}

{region "E-Stop"}
fbEStopButtonInput.i_axValues[c_uiHmi]   := stHmiInputs.xEStopButtonPressed;
fbEStopButtonInput.i_axValues[c_uiVisu]  := stVisuInputs.xEStopButtonPressed;
fbEStopButtonInput.i_axValues[c_uiScada] := stScadaInputs.xEStopButtonPressed;
fbEStopButtonInput(i_xEnable := TRUE, i_xDefault := FALSE, q_udiChangedByChannel => );
IF fbEStopButtonInput.q_xPositiveFlank THEN
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel  := APL2.ET_LogLevel.UserAction,
		i_udiDiagCode := TO_UINT(ET_Result.EStopButtonPressed),
		i_sMessage    := Standard.CONCAT('Button E-Stop pressed by Channel:', TO_STRING(fbEStopButtonInput.q_udiChangedByChannel))
	);
END_IF
{endregion}

{region "Stop"}
fbStopButtonInput.i_axValues[c_uiHmi]   := stHmiInputs.xStopButtonPressed;
fbStopButtonInput.i_axValues[c_uiVisu]  := stVisuInputs.xStopButtonPressed;
fbStopButtonInput.i_axValues[c_uiScada] := stScadaInputs.xStopButtonPressed;
fbStopButtonInput(i_xEnable := TRUE, i_xDefault := FALSE, q_udiChangedByChannel => );
IF fbStopButtonInput.q_xPositiveFlank THEN
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel  := APL2.ET_LogLevel.UserAction,
		i_udiDiagCode := TO_UINT(ET_Result.StopButtonPressed),
		i_sMessage    := Standard.CONCAT('Button Stop pressed by Channel:', TO_STRING(fbEStopButtonInput.q_udiChangedByChannel))
	);
END_IF
{endregion}

{region "Reset"}
fbResetButtonInput.i_axValues[c_uiHmi]   := stHmiInputs.xResetButtonPressed;
fbResetButtonInput.i_axValues[c_uiVisu]  := stVisuInputs.xResetButtonPressed;
fbResetButtonInput.i_axValues[c_uiScada] := stScadaInputs.xResetButtonPressed;
fbResetButtonInput(i_xEnable := TRUE, i_xDefault := FALSE, q_udiChangedByChannel => );
IF fbResetButtonInput.q_xPositiveFlank THEN
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel  := APL2.ET_LogLevel.UserAction,
		i_udiDiagCode := TO_UINT(ET_Result.ResetButtonPressed),
		i_sMessage    := Standard.CONCAT('Button Reset pressed by Channel:', TO_STRING(fbEStopButtonInput.q_udiChangedByChannel))
	);
	fbDiagHandler.DiagQuit();
ELSIF fbDiagHandler.xDiagQuitInProgress THEN
	// no steps neccessary for diag quit in Application, SubUnits signal diag quit done on their own
	fbDiagHandler.DiagQuitDone(i_xRecursiveToTop := TRUE);
END_IF
{endregion}

{region "Start"}
fbStartButtonInput.i_axValues[c_uiHmi]   := stHmiInputs.xStartButtonPressed;
fbStartButtonInput.i_axValues[c_uiVisu]  := stVisuInputs.xStartButtonPressed;
fbStartButtonInput.i_axValues[c_uiScada] := stScadaInputs.xStartButtonPressed;
fbStartButtonInput(i_xEnable := TRUE, i_xDefault := FALSE, q_udiChangedByChannel => );
IF fbStartButtonInput.q_xPositiveFlank THEN
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel  := APL2.ET_LogLevel.UserAction,
		i_udiDiagCode := TO_UINT(ET_Result.StartButtonPressed),
		i_sMessage    := Standard.CONCAT('Button Start pressed by Channel:', TO_STRING(fbEStopButtonInput.q_udiChangedByChannel))
	);
END_IF
{endregion}

fbStackLightsAndButtons(
	i_xEnable             := TRUE,
	i_etState             := stSubUnitOutputData.etPackMlState,
	i_xEStopButtonPressed := fbEStopButtonInput.q_xValue,
	i_xStopButtonPressed  := fbStopButtonInput.q_xPositiveFlank,
	i_xResetButtonPressed := fbResetButtonInput.q_xPositiveFlank,
	i_xStartButtonPressed := fbStartButtonInput.q_xPositiveFlank,
	i_xMaterialLow        :=,
	i_xStarvedUpstream    :=,
	i_timFlashTime        := T#500MS,
	q_etCmd               =>,
	q_xRedLightOn         =>,
	q_xAmberLightOn       =>,
	q_xBlueLightOn        =>,
	q_xGreenLightOn       =>,
	q_xStartButtonLightOn =>,
	q_xResetButtonLightOn =>
);

stSubUnitInputData.etCmd           := fbStackLightsAndButtons.q_etCmd;

stSubUnitInputData.etOperationMode := fbOperationModeInput.q_etValue;
