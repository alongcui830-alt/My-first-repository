__METADATA__
{
  "v3Meta": {
    "objectGuid": "6811cda4-87eb-4c3d-8ff0-49e48a122082",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
CASE fbPackMlState.etStateCurrent OF
	PackML.ET_States.Aborting:
		CASE fbLogicState.diState OF
			0: // TODO: add user specific logic
				IF fbLogicState.xEntryAction THEN
					;
				ELSE
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // TODO: add user specific logic
				IF fbLogicState.xEntryAction THEN
					;
				ELSE
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Aborted:
		;
	PackML.ET_States.Clearing:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10:
				xPackMlStateComplete := TRUE;
		END_CASE
	PackML.ET_States.Stopping:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Stopped:
		;
	PackML.ET_States.Resetting:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10:
				xPackMlStateComplete := TRUE;
		END_CASE
	PackML.ET_States.Idle:
		;
	PackML.ET_States.Starting:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Execute:
		;
	PackML.ET_States.Holding:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Held:
		;
	PackML.ET_States.UnHolding:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Suspending:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Suspended:
		;
	PackML.ET_States.UnSuspending:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Completing:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Complete:
		;
	ELSE
		fbDiagSender.SetErrorData(
			i_xActive     := TRUE,
			i_diDiagCode  := ET_Result.PackMLStateInvalid,
			i_sMessage    := TO_STRING(ET_Result.PackMLStateInvalid),
			i_uiSeverity  := ET_DiagSeverity.FatalError,
			i_udiSourceId := i_stConfiguration.uiUnitId,
			i_sSource     := i_stConfiguration.sUnitName
		);
END_CASE
