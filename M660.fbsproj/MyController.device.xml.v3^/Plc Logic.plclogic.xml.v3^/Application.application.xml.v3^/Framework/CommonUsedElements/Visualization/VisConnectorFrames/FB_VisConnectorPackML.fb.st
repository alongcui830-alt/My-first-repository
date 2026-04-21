__METADATA__
{
  "v3Meta": {
    "objectGuid": "211bd70f-1f96-4a7d-839a-73f6c284c801",
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
FUNCTION_BLOCK FB_VisConnectorPackML
VAR_INPUT
	i_pfbPackMlStateMachine : POINTER TO PackML.FB_UnitModeManager2;
END_VAR
VAR_OUTPUT
	q_etPackMlCmd : PackML.ET_Cmd;
END_VAR
VAR
	pfbPackMLStateMachine : POINTER TO PackML.FB_UnitModeManager2;
	xEnableDebugCmd       : BOOL;
	axPackMLCmdGiven      : ARRAY[0..10] OF BOOL;
	axPackMLCmdVoritten   : ARRAY[0..10] OF BOOL;
	etCurrentState        : PackML.ET_States;
	diStatesDisabled	  : DINT;
END_VAR
__IMPLEMENTATION__
pfbPackMLStateMachine := i_pfbPackMlStateMachine;
IF xEnableDebugCmd THEN
	IF i_pfbPackMlStateMachine <> 0 THEN
		etCurrentState := i_pfbPackMlStateMachine^.etStateCurrent;
		diStatesDisabled := i_pfbPackMlStateMachine^.ifUnitModeCurrent.diStatesDisabled;
	ELSE
		etCurrentState := PackML.ET_States.Aborted;
		diStatesDisabled := 2#111111111111111111;
	END_IF
	
	axPackMLCmdVoritten[PackML.ET_Cmd.Undefined] := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Abort]     := etCurrentState = PackML.ET_States.Aborting OR etCurrentState = PackML.ET_States.Aborted;
	axPackMLCmdVoritten[PackML.ET_Cmd.Stop]      :=
		etCurrentState = PackML.ET_States.Aborting OR
		etCurrentState = PackML.ET_States.Aborted OR
		etCurrentState = PackML.ET_States.Clearing OR
		etCurrentState = PackML.ET_States.Stopping OR
		etCurrentState = PackML.ET_States.Stopped;
	axPackMLCmdVoritten[PackML.ET_Cmd.Clear]     := etCurrentState <> PackML.ET_States.Aborted;
	axPackMLCmdVoritten[PackML.ET_Cmd.Reset]     := etCurrentState <> PackML.ET_States.Stopped AND etCurrentState <> PackML.ET_States.Complete;
	axPackMLCmdVoritten[PackML.ET_Cmd.Start]     := etCurrentState <> PackML.ET_States.Idle;
	axPackMLCmdVoritten[PackML.ET_Cmd.Hold]      := etCurrentState <> PackML.ET_States.Execute OR ((TO_UDINT(diStatesDisabled) AND TO_UDINT(PackML.ET_StateModelDefinition.Held)) > 0);
	axPackMLCmdVoritten[PackML.ET_Cmd.UnHold]    := etCurrentState <> PackML.ET_States.Held;
	axPackMLCmdVoritten[PackML.ET_Cmd.Suspend]   := etCurrentState <> PackML.ET_States.Execute OR ((TO_UDINT(diStatesDisabled) AND TO_UDINT(PackML.ET_StateModelDefinition.Suspended)) > 0);
	axPackMLCmdVoritten[PackML.ET_Cmd.UnSuspend] := etCurrentState <> PackML.ET_States.Suspended;
	axPackMLCmdVoritten[PackML.ET_Cmd.Complete]  := etCurrentState <> PackML.ET_States.Execute OR ((TO_UDINT(diStatesDisabled) AND TO_UDINT(PackML.ET_StateModelDefinition.Complete)) > 0);
	IF axPackMLCmdGiven[PackML.ET_Cmd.Abort] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Abort;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Stop] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Stop;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Clear] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Clear;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Reset] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Reset;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Start] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Start;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Hold] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Hold;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.UnHold] THEN
		q_etPackMlCmd := PackML.ET_Cmd.UnHold;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Suspend] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Suspend;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.UnSuspend] THEN
		q_etPackMlCmd := PackML.ET_Cmd.UnSuspend;
	ELSIF axPackMLCmdGiven[PackML.ET_Cmd.Complete] THEN
		q_etPackMlCmd := PackML.ET_Cmd.Complete;
	ELSE
		q_etPackMlCmd := PackML.ET_Cmd.Undefined;
	END_IF
	axPackMLCmdGiven[PackML.ET_Cmd.Abort]     := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Stop]      := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Clear]     := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Reset]     := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Start]     := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Hold]      := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.UnHold]    := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Suspend]   := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.UnSuspend] := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Complete]  := FALSE;
ELSE
	axPackMLCmdVoritten[PackML.ET_Cmd.Undefined] := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Abort]     := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Stop]      := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Clear]     := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Reset]     := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Start]     := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Hold]      := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.UnHold]    := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Suspend]   := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.UnSuspend] := TRUE;
	axPackMLCmdVoritten[PackML.ET_Cmd.Complete]  := TRUE;
	axPackMLCmdGiven[PackML.ET_Cmd.Abort]        := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Stop]         := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Clear]        := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Reset]        := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Start]        := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Hold]         := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.UnHold]       := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Suspend]      := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.UnSuspend]    := FALSE;
	axPackMLCmdGiven[PackML.ET_Cmd.Complete]     := FALSE;
	q_etPackMlCmd                                := PackML.ET_Cmd.Undefined;
END_IF
