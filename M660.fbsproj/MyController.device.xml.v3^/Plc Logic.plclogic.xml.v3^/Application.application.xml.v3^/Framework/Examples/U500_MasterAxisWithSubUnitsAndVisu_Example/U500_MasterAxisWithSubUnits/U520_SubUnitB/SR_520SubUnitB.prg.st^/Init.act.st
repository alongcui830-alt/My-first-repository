__METADATA__
{
  "v3Meta": {
    "objectGuid": "f42d54dc-064c-4ec0-acb1-8cf6141ac62b",
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
// define starting unit mode
fbPackMlState.CmdChangeUnitMode(i_diValue := ET_OperationMode.Production, q_etResult =>, q_sResultMsg => );
{endregion}

{region "Axis"}
fbAxisMotion.ifLoggerPoint.Register(i_sName := 'Axis', i_ifParent := fbLoggerPoint);
fbAxisMotion.Init(i_ifAxis := i_stConfiguration.ifAxis);
{endregion}

{region "Visualization"}
fbVisManager.Init(i_ifParent := i_stConfiguration.ifParentVisManager); //New Visu
{endregion}


q_stOutputData.xReady := TRUE;
