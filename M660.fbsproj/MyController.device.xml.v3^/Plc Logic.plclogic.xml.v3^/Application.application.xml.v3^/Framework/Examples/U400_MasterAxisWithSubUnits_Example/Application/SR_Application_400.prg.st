__METADATA__
{
  "v3Meta": {
    "objectGuid": "2b019dc9-8aae-40d7-9478-6b09464791a0",
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
PROGRAM SR_Application_400
VAR
	stVisuInputs         : ST_ApplicationInputData_400;
	stHmiInputs          : ST_ApplicationInputData_400;
	stScadaInputs        : ST_ApplicationInputData_400;
	fbEStopButtonInput   : FB_InputBool<c_uiInputChannels>;
	fbStopButtonInput    : FB_InputBool<c_uiInputChannels>;
	fbResetButtonInput   : FB_InputBool<c_uiInputChannels>;
	fbStartButtonInput   : FB_InputBool<c_uiInputChannels>;
	fbOperationModeInput : FB_InputOperationMode<c_uiInputChannels>;
	
	fbApplicationState      : SE_CTBX.FB_FiniteStateMachine;
	fbLoggerPoint           : APL2.FB_LoggerPoint;
	fbStackLightsAndButtons : SE_AFU.FB_StacklightsAndButtons;
	fbDiagHandler           : ApDiag.FB_DiagnosticHandler;
	fbActiveDiagnostics     : ApDiag.FB_ActiveDiagnostics<c_uiMaxNumberOfDiagMsgs>;
	astActiveDiagMsgs       : ARRAY[1..c_uiMaxNumberOfDiagMsgs] OF ApDiag.ST_DiagMessageListener;
	
	stSubUnitInputData  : ST_400MasterAxisWithSubUnitsInputData;
	stSubUnitOutputData : ST_400MasterAxisWithSubUnitsOutputData;
	stSubUnitConfigData : ST_400MasterAxisWithSubUnitsConfigData;
	
	fbAxisA : MOIN.FB_ControlledAxis;
	fbAxisB : MOIN.FB_ControlledAxis;
END_VAR
VAR CONSTANT
	c_uiInputChannels       : UINT := 3;
	c_uiMaxNumberOfDiagMsgs : UINT := 40;
END_VAR
__IMPLEMENTATION__
stSubUnitOutputData := SR_400MasterAxisWithSubUnits.q_stOutputData;
fbApplicationState.Update();
CASE fbApplicationState.diState OF
	0: // Register logging service
		APL2.G_ifApplicationLogger.RegisterCommunicationService(
			q_xError     =>,
			q_etResult   =>,
			q_sResultMsg => );
		fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 10);
	10: // register logger point
		fbLoggerPoint.RegisterLoggerPoint(
			i_ifParent := APL2.G_ifApplicationLogger,
			i_sName    := 'Application',
			i_sType    := 'SR_Application',
			i_sSource  := 'Applicaiton');
		// choose default log level e.g. Nothing, Exception, UserAction, StatusMessage, DebugMessage
		fbLoggerPoint.etLogLevel := APL2.ET_LogLevel.StatusMessage;
		fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 10);
	20: // activate sercos bus communication
		{IF defined (pou: S3M.FC_SlaveGetCommunicationState)}
		// On M262 use S3M library
		IF fbApplicationState.xEntryAction THEN
			SercosMaster.SercosPhaseChanger.DesiredPhase := S3M.ET_SercosPhase.Phase4;
		ELSIF SercosMaster.SercosPhaseChanger.ActualState = S3M.ET_SercosState.Error THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 5);
		ELSIF SercosMaster.SercosPhaseChanger.ActualState = S3M.ET_SercosState.Phase4 THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 10);
		END_IF
		{ELSE}
		// On M660 use SMI library
		IF fbApplicationState.xEntryAction THEN
			SercosMaster.SercosPhaseChanger.DesiredPhase := SMI.ET_SercosPhase.Phase4;
		ELSIF SercosMaster.SercosPhaseChanger.ActualState = SMI.ET_SercosState.Error THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 5);
		ELSIF SercosMaster.SercosPhaseChanger.ActualState = SMI.ET_SercosState.Phase4 THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 10);
		END_IF
		{END_IF}
	25: // reset Sercos error
		{IF defined (pou: S3M.FC_SlaveGetCommunicationState)}
		// On M262 sercos master reset sercos phase to NRT
		IF fbApplicationState.xEntryAction THEN
			SercosMaster.SercosPhaseChanger.DesiredPhase := S3M.ET_SercosPhase.NRT;
		ELSIF SercosMaster.SercosPhaseChanger.ActualState <= S3M.ET_SercosState.Phase0 THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState - 5);
		END_IF
		{ELSE}
		// On M6xx sercos master trigger a sercos diag quit
		IF fbApplicationState.xEntryAction THEN
			SMM6xx.FC_SercosDiagQuit();
		ELSIF SercosMaster.SercosPhaseChanger.ActualState <= SMI.ET_SercosState.Phase0 THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState - 5);
		END_IF
		{END_IF}
	30: // initialize machine
		Init();
		stSubUnitInputData.xEnable := TRUE;
		IF SR_400MasterAxisWithSubUnits.q_stOutputData.xReady THEN
			fbApplicationState.SetNextState(i_diState := fbApplicationState.diState + 10);
		END_IF
	40: // work
		InputsAndCommands();
		fbActiveDiagnostics.GetDiagList(iq_astDiagMsgs := astActiveDiagMsgs);
END_CASE
SR_400MasterAxisWithSubUnits.i_stInputData := stSubUnitInputData;
SR_400MasterAxisWithSubUnits();
