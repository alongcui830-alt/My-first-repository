__METADATA__
{
  "v3Meta": {
    "objectGuid": "f22455eb-2767-4ab3-9764-a7d9c5bda445",
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
METHOD PRIVATE ErrorReactionHandling
VAR_STAT
	uiReactionLevel_old : UINT;
END_VAR
__IMPLEMENTATION__
{region "command error reaction"}
IF fbDiagHandler.uiReactionLevel <> uiReactionLevel_old THEN
	uiReactionLevel_old := fbDiagHandler.uiReactionLevel;
	CASE fbDiagHandler.uiReactionLevel OF
		//ET_DiagReaction.None:
		//ET_DiagReaction.LoggerEntry:
		//ET_DiagReaction.ReducePerformance:
		ET_DiagReaction.Halt, ET_DiagReaction.ControlledStop:
			etErrorReactionCommand := PackML.ET_Cmd.Stop;
		ET_DiagReaction.ErrorStop:
			etErrorReactionCommand := PackML.ET_Cmd.Abort;
		ELSE
			etErrorReactionCommand := PackML.ET_Cmd.Undefined;
	END_CASE
END_IF
{endregion}

{region "handle error reset"}
CASE fbDiagResetState.diState OF
	ET_ResetState.WaitForReset:
		IF fbDiagHandler.xDiagQuitInProgress THEN
			fbDiagSender.Reset();
			fbDiagResetState.SetNextState(i_diState := ET_ResetState.StartReset);
		END_IF
	ET_ResetState.StartReset:
		// Keep state for one cycle to trigger all necessary resets in unit
		fbDiagResetState.SetNextState(i_diState := ET_ResetState.ResetOngoing);
		xDiagQuitOngoing := FALSE; // set back reset flag, will be set again if a part of the unit is still resetting
	ET_ResetState.ResetOngoing:
		IF NOT xDiagQuitOngoing THEN
			// whait till all resets inside unit finished, then signal that this units reset is finished
			fbDiagHandler.DiagQuitDone(i_xRecursiveToTop := TRUE);
		END_IF
		xDiagQuitOngoing := FALSE; // set back reset flag, will be set again if a part of the unit is still resetting
		IF NOT fbDiagHandler.xDiagQuitInProgress THEN
			// when all other (sub)Units finished DiagQuit, whait for next diag quit
			fbDiagResetState.SetNextState(i_diState := ET_ResetState.WaitForReset);
		END_IF
END_CASE
fbDiagResetState.Update();
{endregion}
