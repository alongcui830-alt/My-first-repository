__METADATA__
{
  "v3Meta": {
    "objectGuid": "301bbea2-de62-496b-8ff5-4093e9075267",
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
			0: // TODO
				fbSubUnitHandler.i_xMute := TRUE; // prevent Abort command to subunits while master unit aborts itself
				IF fbLogicState.xEntryAction THEN
					;
				ELSE
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished aborting
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Aborted:
		;
	PackML.ET_States.Clearing:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished clearing
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Stopping:
		CASE fbLogicState.diState OF
			0: // TODO
				fbSubUnitHandler.i_xMute := TRUE; // prevent Stop command to subunits while master unit stopps itself
				IF fbLogicState.xEntryAction THEN
					;
				ELSE
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished stopping
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Stopped:
		;
	PackML.ET_States.Resetting:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished resetting
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Idle:
		;
	PackML.ET_States.Starting:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Execute:
		;
	PackML.ET_States.Holding:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished holding
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Held:
		;
	PackML.ET_States.UnHolding:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished unholding
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Suspending:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished suspending
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Suspended:
		;
	PackML.ET_States.UnSuspending:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished unsuspending
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Completing:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished completing
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
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
