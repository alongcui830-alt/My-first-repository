__METADATA__
{
  "v3Meta": {
    "objectGuid": "67e2ccc3-63e5-4600-8070-7c4bc55b451b",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
PROGRAM SR_000MainUnit
VAR_INPUT
	i_stConfiguration : ST_000MainUnitConfigData;
	i_stInputData     : ST_000MainUnitInputData;
END_VAR
VAR_OUTPUT
	q_stOutputData : ST_000MainUnitOutputData;
END_VAR
VAR
	// Unit base elements
	fbLoggerPoint : APL2.FB_LoggerPoint;
	fbUnitState   : SE_CTBX.FB_FiniteStateMachine;
	// DiagHandler
	fbDiagHandler    : ApDiag.FB_DiagnosticHandler;
	fbDiagSender     : FB_DiagSender<c_uiDiagBufferSize>;
	fbDiagResetState : SE_CTBX.FB_FiniteStateMachine;
	xDiagQuitOngoing : BOOL;
	// PackML state machines
	fbPackMlState          : PackML.FB_UnitModeManager2;
	fbPackMlCmdChannels    : FB_InputPackMlCommand<4>;
	etPackMlVisCommand     : PackML.ET_Cmd;
	etErrorReactionCommand : PackML.ET_Cmd;
	etPackMlStateLastCycle : PackML.ET_States;
	xPackMlStateComplete   : BOOL;
	// Unit logic
	fbLogicState : SE_CTBX.FB_FiniteStateMachine;
	
	xActivateDebugCommands	: BOOL;
	
END_VAR
VAR CONSTANT
	c_uiDiagBufferSize : UINT := 20;
END_VAR
__IMPLEMENTATION__
fbUnitState.Update();
CASE fbUnitState.diState OF
	ET_UnitState.Disabled:
		IF i_stInputData.xEnable THEN
			q_stOutputData.xActive := TRUE;
			fbLoggerPoint.RegisterLoggerPoint(
				i_ifParent := i_stConfiguration.ifParentLoggerPoint,
				i_sName    := i_stConfiguration.sUnitName,
				i_sType    := 'SR_MainUnit',
				i_sSource  := 'Application'
			);
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL2.ET_LogLevel.UserAction, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Unit initializing start'
			);
			fbUnitState.SetNextState(i_diState := ET_UnitState.InitializeSubUnits);
		END_IF
	ET_UnitState.InitializeSubUnits:
		fbUnitState.SetNextState(i_diState := ET_UnitState.InitializeOwnUnit);
	ET_UnitState.InitializeOwnUnit:
		Init();
		IF q_stOutputData.xReady THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL2.ET_LogLevel.StatusMessage, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Unit initializing done'
			);
			fbUnitState.SetNextState(i_diState := ET_UnitState.Working);
		END_IF
	ET_UnitState.Working:
		InputVerification();
		ErrorReactionHandling();
		SwitchOperationMode();
		UpdateStateMachines();
		MachineLogic();
		IF (fbPackMlState.etStateCurrent = PackMl.ET_States.Aborted) AND (NOT i_stInputData.xEnable) THEN
			q_stOutputData.xReady := FALSE;
			fbUnitState.SetNextState(i_diState := ET_UnitState.DisableSubUnits);
		END_IF
	ET_UnitState.DisableSubUnits:
		q_stOutputData.xActive := FALSE;
		fbLoggerPoint.AddLogEntry(
			i_etLogLevel := APL2.ET_LogLevel.StatusMessage, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Unit disabeling done'
		);
		fbUnitState.SetNextState(i_diState := ET_UnitState.Disabled);
END_CASE
