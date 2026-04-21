__METADATA__
{
  "v3Meta": {
    "objectGuid": "d7b264b6-2c1b-4f1e-99a1-e369faabdd69",
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
METHOD PRIVATE PrioritiseCmd : PackML.ET_Cmd
VAR_INPUT
	i_etState		: PackML.ET_States;
	i_etCurrentCmd	: PackML.ET_Cmd;
	i_etNewCmd		: PackML.ET_Cmd;
END_VAR
__IMPLEMENTATION__
CASE i_etState OF
	PackML.ET_States.Aborted:
		IF i_etCurrentCmd = PackML.ET_Cmd.Clear OR i_etNewCmd = PackML.ET_Cmd.Clear THEN
			PrioritiseCmd := PackML.ET_Cmd.Clear;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Clearing,
	PackML.ET_States.Stopping:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Resetting,
	PackML.ET_States.Starting,
	PackML.ET_States.Completing,
	PackML.ET_States.Holding,
	PackML.ET_States.UnHolding,
	PackML.ET_States.Suspending,
	PackML.ET_States.UnSuspending:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Stopped:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Reset OR i_etNewCmd = PackML.ET_Cmd.Reset THEN
			PrioritiseCmd := PackML.ET_Cmd.Reset;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Complete:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Reset OR i_etNewCmd = PackML.ET_Cmd.Reset THEN
			PrioritiseCmd := PackML.ET_Cmd.Reset;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Idle:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Start OR i_etNewCmd = PackML.ET_Cmd.Start THEN
			PrioritiseCmd := PackML.ET_Cmd .Start;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Execute:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Complete OR i_etNewCmd = PackML.ET_Cmd.Complete THEN
			PrioritiseCmd := PackML.ET_Cmd .Complete;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Hold OR i_etNewCmd = PackML.ET_Cmd.Hold THEN
			PrioritiseCmd := PackML.ET_Cmd .Hold;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Suspend OR i_etNewCmd = PackML.ET_Cmd.Suspend THEN
			PrioritiseCmd := PackML.ET_Cmd .Suspend;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Suspended:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Hold OR i_etNewCmd = PackML.ET_Cmd.Hold THEN
			PrioritiseCmd := PackML.ET_Cmd .Hold;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.UnSuspend OR i_etNewCmd = PackML.ET_Cmd.UnSuspend THEN
			PrioritiseCmd := PackML.ET_Cmd .UnSuspend;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	PackML.ET_States.Held:
		IF i_etCurrentCmd = PackML.ET_Cmd.Abort OR i_etNewCmd = PackML.ET_Cmd.Abort THEN
			PrioritiseCmd := PackML.ET_Cmd.Abort;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.Stop OR i_etNewCmd = PackML.ET_Cmd.Stop THEN
			PrioritiseCmd := PackML.ET_Cmd .Stop;
		ELSIF i_etCurrentCmd = PackML.ET_Cmd.UnHold OR i_etNewCmd = PackML.ET_Cmd.UnHold THEN
			PrioritiseCmd := PackML.ET_Cmd .UnHold;
		ELSE
			PrioritiseCmd := i_etCurrentCmd;
		END_IF
	
END_CASE
