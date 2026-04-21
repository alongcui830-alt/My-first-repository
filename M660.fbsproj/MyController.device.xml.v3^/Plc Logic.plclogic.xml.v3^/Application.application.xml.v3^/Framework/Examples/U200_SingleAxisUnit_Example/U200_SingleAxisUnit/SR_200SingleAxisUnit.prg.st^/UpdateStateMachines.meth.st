__METADATA__
{
  "v3Meta": {
    "objectGuid": "c54ea300-1839-4e17-a05e-cf7c4417f2a2",
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
METHOD PRIVATE UpdateStateMachines
VAR CONSTANT
	c_uiErrorReaction : UINT := 1;
	c_uiUnitInternal  : UINT := 2;
	c_uiUnitInput     : UINT := 3;
	c_uiVisualization : UINT := 4;
END_VAR
__IMPLEMENTATION__
etPackMlStateLastCycle := fbPackMlState.etStateCurrent;

IF xPackMlStateComplete THEN
	fbPackMlState.StateComplete();
	xPackMlStateComplete := FALSE;
END_IF

fbPackMlCmdChannels.i_aetCmds[c_uiUnitInput]     := i_stInputData.etCmd;
fbPackMlCmdChannels.i_aetCmds[c_uiVisualization] := etPackMlVisCommand;
fbPackMlCmdChannels.i_aetCmds[c_uiErrorReaction]  := etErrorReactionCommand;
etPackMlVisCommand                               := PackML.ET_Cmd.Undefined; // TODO make the reset with adding a specific vis FB
fbPackMlCmdChannels(
	i_xEnable := TRUE, i_etState := fbPackMlState.etStateCurrent, i_aetCmds :=, q_etCmd =>, q_xCmdChanged =>, q_udiChangedByChannel =>
);
IF fbPackMlCmdChannels.q_xCmdChanged THEN
	CASE fbPackMlCmdChannels.q_etCmd OF
		PackML.ET_Cmd.Abort:
			fbPackMlState.CmdAbort();
		PackML.ET_Cmd.Stop:
			fbPackMlState.CmdStop();
		PackML.ET_Cmd.Clear:
			fbPackMlState.CmdClear();
		PackML.ET_Cmd.Reset:
			fbPackMlState.CmdReset();
		PackML.ET_Cmd.Start:
			fbPackMlState.CmdStart();
		PackML.ET_Cmd.Complete:
			fbPackMlState.CmdComplete();
		PackML.ET_Cmd.Hold:
			fbPackMlState.CmdHold();
		PackML.ET_Cmd.UnHold:
			fbPackMlState.CmdUnHold();
		PackML.ET_Cmd.Suspend:
			fbPackMlState.CmdSuspend();
		PackML.ET_Cmd.UnSuspend:
			fbPackMlState.CmdUnSuspend();
	END_CASE
END_IF
q_stOutputData.etPackMlState := fbPackMlState.etStateCurrent;

IF fbPackMlState.etStateCurrent <> etPackMlStateLastCycle THEN
	fbLogicState.Reset();
END_IF
fbLogicState.Update();
IF fbLogicState.xEntryAction THEN
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL2.ET_LogLevel.StatusMessage,
		i_udiDiagCode:= TO_UDINT(ET_Result.Ok),
		i_sMessage   := Standard.CONCAT('Enter logic state: ', TO_STRING(fbLogicState.diState))
	);
END_IF
