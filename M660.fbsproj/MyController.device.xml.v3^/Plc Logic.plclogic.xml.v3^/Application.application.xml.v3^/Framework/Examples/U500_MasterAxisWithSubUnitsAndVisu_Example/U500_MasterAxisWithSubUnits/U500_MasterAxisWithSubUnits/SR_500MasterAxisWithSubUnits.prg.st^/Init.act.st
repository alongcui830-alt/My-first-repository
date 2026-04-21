__METADATA__
{
  "v3Meta": {
    "objectGuid": "95fbb515-9ab0-4bec-8d82-07a86c78ee64",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
{region "Diagnostics handler"}
fbDiagHandler.InitHandler(
	i_udiId := i_stConfiguration.uiUnitId, i_sName := i_stConfiguration.sUnitName, i_ifParent := i_stConfiguration.ifParentDiagHandler
);
fbDiagSender.Init(i_ifDiagHandler := fbDiagHandler);
fbDiagResetState.Reset();
// For synchron stop of SubUnits, error reaction is not forwarded to the SubUnits, 
// instead master axis in this unit is stopped and afterwards SubUnit is ordered to Stop/Abort
auiReactionForwarding[ET_DiagReaction.ControlledStop] := ET_DiagReaction.None;
auiReactionForwarding[ET_DiagReaction.ErrorStop]  := ET_DiagReaction.None;
fbDiagHandler.ConfigReactionLevelForwarding(i_xSetConfigForAllTargets := TRUE, i_ifTargetChild := 0, i_auiReactionLevel := auiReactionForwarding);
{endregion}

{region "PackML state machine"}
fbPackMlState.RegisterLoggerPoint(i_ifParent := fbLoggerPoint, i_sName := 'PackML StateMachine', q_etResult =>, q_sResultMsg => );

fbPackMlState.DefineUnitMode(
	i_diValue                   := ET_OperationMode.Production,
	i_sName                     := TO_STRING(ET_OperationMode.Production),
	i_diStatesDisabled          := PackML.FC_StateSelectionAsDintFromBool(i_xCompleting := TRUE, i_xComplete := TRUE),
	i_diStatesModeChangeAllowed := PackML.FC_StateSelectionAsDintFromBool(i_xAborted := TRUE, i_xStopped := TRUE, i_xIdle := TRUE),
	i_etInitialState            := PackML.ET_States.Aborted,
	q_etResult                  =>,
	q_sResultMsg                =>
);
fbPackMlState.DefineUnitMode(
	i_diValue          := ET_OperationMode.Manual,
	i_sName            := TO_STRING(ET_OperationMode.Manual),
	i_diStatesDisabled :=
		PackML.FC_StateSelectionAsDintFromBool(
			i_xCompleting   := TRUE,
			i_xComplete     := TRUE,
			i_xHolding      := TRUE,
			i_xHeld         := TRUE,
			i_xUnHolding    := TRUE,
			i_xSuspending   := TRUE,
			i_xSuspended    := TRUE,
			i_xUnSuspending := TRUE
		),
	i_diStatesModeChangeAllowed := PackML.FC_StateSelectionAsDintFromBool(i_xAborted := TRUE, i_xStopped := TRUE, i_xIdle := TRUE),
	i_etInitialState            := PackML.ET_States.Aborted,
	q_etResult                  =>,
	q_sResultMsg                =>
);
fbPackMlState.DefineUnitMode(
	i_diValue          := ET_OperationMode.JogMachine,
	i_sName            := TO_STRING(ET_OperationMode.JogMachine),
	i_diStatesDisabled :=
		PackML.FC_StateSelectionAsDintFromBool(
			i_xCompleting   := TRUE,
			i_xComplete     := TRUE,
			i_xHolding      := TRUE,
			i_xHeld         := TRUE,
			i_xUnHolding    := TRUE,
			i_xSuspending   := TRUE,
			i_xSuspended    := TRUE,
			i_xUnSuspending := TRUE
		),
	i_diStatesModeChangeAllowed := PackML.FC_StateSelectionAsDintFromBool(i_xAborted := TRUE, i_xStopped := TRUE, i_xIdle := TRUE),
	i_etInitialState            := PackML.ET_States.Aborted,
	q_etResult                  =>,
	q_sResultMsg                =>
);	
// define starting unit mode
fbPackMlState.CmdChangeUnitMode(i_diValue := ET_OperationMode.Production, q_etResult =>, q_sResultMsg => );
{endregion}
	
{region "MasterAxis"}
fbMasterAxisMotion.ifLoggerPoint.Register(i_sName	:= 'MasterAxis', i_ifParent := fbLoggerPoint);
fbMasterAxisMotion.Init(i_ifAxis := fbMasterAxisInstance);
{endregion}

{region "Visualization"}
fbVisManager.Init(i_ifParent := i_stConfiguration.ifParentVisManager);
{endregion}
	
q_stOutputData.xReady := TRUE;
