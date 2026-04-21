__METADATA__
{
  "v3Meta": {
    "objectGuid": "267047c7-0eb4-4adb-a5bd-f8da83b0ec1d",
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
PROGRAM SR_400MasterAxisWithSubUnits
VAR_INPUT
	i_stConfiguration : ST_400MasterAxisWithSubUnitsConfigData;
	i_stInputData     : ST_400MasterAxisWithSubUnitsInputData;
END_VAR
VAR_OUTPUT
	q_stOutputData : ST_400MasterAxisWithSubUnitsOutputData;
END_VAR
VAR
	// Unit base elements
	fbLoggerPoint : APL2.FB_LoggerPoint;
	fbUnitState   : SE_CTBX.FB_FiniteStateMachine;
	// DiagHandler
	fbDiagHandler         : ApDiag.FB_DiagnosticHandler;
	fbDiagSender          : FB_DiagSender<c_uiDiagBufferSize>;
	auiReactionForwarding : ApDiag.ArrayReactionLevelForwarding;
	fbDiagResetState      : SE_CTBX.FB_FiniteStateMachine;
	xDiagQuitOngoing      : BOOL;
	// PackML state machines
	fbPackMlState          : PackML.FB_UnitModeManager2;
	fbPackMlCmdChannels    : FB_InputPackMlCommand<4>;
	etPackMlVisCommand     : PackML.ET_Cmd;
	etErrorReactionCommand : PackML.ET_Cmd;
	etPackMlStateLastCycle : PackML.ET_States;
	xPackMlStateComplete   : BOOL;
	// MasterAxis
	fbMasterAxisInstance : MOIN.FB_ControlledAxis;
	fbMasterAxisMotion   : MFB.FB_AxisMotion;
	// SubUnit handler
	fbSubUnitHandler        : SE_AFU.FB_PackMLSubUnitHandler<c_uiNrOfSubUnits>;
	xAllSubUnitsInitialized : BOOL;
	// SubUnit communication data
	stSubUnitAInputData  : ST_410SubUnitAInputData;
	stSubUnitAOutputData : ST_410SubUnitAOutputData;
	stSubUnitAConfigData : ST_410SubUnitAConfigData;
	stSubUnitBInputData  : ST_420SubUnitBInputData;
	stSubUnitBOutputData : ST_420SubUnitBOutputData;
	stSubUnitBConfigData : ST_420SubUnitBConfigData;
	// Unit logic
	fbLogicState : SE_CTBX.FB_FiniteStateMachine;
	
	xActivateDebugCommands : BOOL;
	
	lrProductionVel : LREAL := 100.0;
	lrProductionAcc : LREAL := 1_000.0;
	lrProductionDec : LREAL := 1_000.0;
	lrJogVel        : LREAL := 25.0;
	lrJogAcc        : LREAL := 250.0;
	lrJogDec        : LREAL := 1_000.0;
	lrStopVel       : LREAL := 100.0;
	lrStopAcc       : LREAL := 10_000.0;
	lrStopDec       : LREAL := 10_000.0;
	lrJerk          : LREAL := 100_000.0;
	
END_VAR
VAR CONSTANT
	c_uiNrOfSubUnits   : UINT := 2;
	c_uiSubUnitA       : UINT := 1;
	c_uiSubUnitB       : UINT := 2;
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
				i_sType    := 'SR_SmallUnit',
				i_sSource  := 'Application'
			);
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL2.ET_LogLevel.UserAction, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Unit initializing'
			);
			fbUnitState.SetNextState(i_diState := ET_UnitState.InitializeSubUnits);
		END_IF
		
	ET_UnitState.InitializeSubUnits:
		IF fbUnitState.xEntryAction THEN
			SubUnitConfiguration();
			stSubUnitAInputData.xEnable := TRUE;
			stSubUnitBInputData.xEnable := TRUE;
		ELSIF stSubUnitAOutputData.xReady AND stSubUnitBOutputData.xReady THEN
			fbUnitState.SetNextState(i_diState := ET_UnitState.InitializeOwnUnit);
		END_IF
		
	ET_UnitState.InitializeOwnUnit:
		Init();
		IF q_stOutputData.xReady THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL2.ET_LogLevel.StatusMessage, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Initializing done'
			);
			fbUnitState.SetNextState(i_diState := ET_UnitState.Working);
		END_IF
		
	ET_UnitState.Working:
		InputVerification();
		ErrorReactionHandling();
		SwitchOperationMode();
		UpdateStateMachines();
		MachineLogic();
		MasterAxis();
		CommandSubUnits();
		IF (fbPackMlState.etStateCurrent = PackMl.ET_States.Aborted) AND (NOT i_stInputData.xEnable) THEN
			q_stOutputData.xReady := FALSE;
			fbUnitState.SetNextState(i_diState := ET_UnitState.DisableSubUnits);
		END_IF
		
	ET_UnitState.DisableSubUnits:
		q_stOutputData.xActive := FALSE;
		fbLoggerPoint.AddLogEntry(
			i_etLogLevel := APL2.ET_LogLevel.StatusMessage, i_udiDiagCode := TO_UDINT(ET_Result.Ok), i_sMessage := 'Unit disabled'
		);
		fbUnitState.SetNextState(i_diState := ET_UnitState.Disabled);
	
END_CASE
SubUnitCommunication();
