__METADATA__
{
  "v3Meta": {
    "objectGuid": "5ea73ded-9910-4535-80bc-f8ae50a30e19",
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
FUNCTION_BLOCK FB_InputPackMlCommand

VAR_GENERIC CONSTANT
	c_udiNumberOfChannels : UDINT := 5;
END_VAR
VAR_INPUT
	i_xEnable : BOOL;
	i_etState	: PackML.ET_States;
	i_aetCmds : ARRAY[1..c_udiNumberOfChannels] OF PackML.ET_Cmd;
END_VAR
VAR_OUTPUT
	q_etCmd               : PackML.ET_Cmd;
	q_xCmdChanged         : BOOL;
	q_udiChangedByChannel : UDINT;
END_VAR
VAR
	xEnableFlag    : BOOL;
	udiCounter     : UDINT;
	aetCmdsLatched : ARRAY[1..c_udiNumberOfChannels] OF PackML.ET_Cmd;
	etNewCmd       : PackML.ET_Cmd;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	FOR udiCounter := 1 TO c_udiNumberOfChannels DO
		aetCmdsLatched[udiCounter] := PackML.ET_Cmd.Undefined;
	END_FOR
	q_etCmd               := PackML.ET_Cmd.Undefined;
	etNewCmd              := q_etCmd;
	q_xCmdChanged         := FALSE;
	q_udiChangedByChannel := 0;
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag           := FALSE;
	q_etCmd               := PackML.ET_Cmd.Undefined;
	q_xCmdChanged         := FALSE;
	q_udiChangedByChannel := 0;
END_IF
IF i_xEnable THEN
	q_xCmdChanged := FALSE;
	q_udiChangedByChannel := 0;
	FOR udiCounter := 1 TO c_udiNumberOfChannels DO
		IF i_aetCmds[udiCounter] <> aetCmdsLatched[udiCounter] THEN
			etNewCmd              := PrioritiseCmd(i_etState := i_etState, i_etCurrentCmd := q_etCmd, i_etNewCmd := i_aetCmds[udiCounter]);
			IF (etNewCmd <> q_etCmd) THEN
				q_xCmdChanged := TRUE;
			END_IF
			q_etCmd               := etNewCmd;
			q_udiChangedByChannel := udiCounter;
		END_IF
	END_FOR
	aetCmdsLatched := i_aetCmds;
END_IF
