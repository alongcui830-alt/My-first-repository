__METADATA__
{
  "v3Meta": {
    "objectGuid": "1b37d2b5-e70f-4c89-818e-93c31ac79065",
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
METHOD PRIVATE Execute
VAR_INST
	xJogCmdActive : BOOL;
END_VAR

__IMPLEMENTATION__
IF q_stOutputData.etActiveOperationMode = ET_OperationMode.Production THEN
	;
ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual THEN
	fbAxisMotion.ifCmd.xJogForward  := i_stInputData.xJogForw;
	fbAxisMotion.ifCmd.xJogBackward := i_stInputData.xJogBack;
	
	IF lrJogVel <> i_stInputData.lrJogVelocity THEN
		lrJogVel := i_stInputData.lrJogVelocity;
		fbAxisMotion.ifCmd.Jog(
			i_lrVelocity     := lrJogVel,
			i_lrAcceleration := lrJogAcc,
			i_lrDeceleration := lrJogDec,
			i_lrJerk         := lrJerk,
		);
	END_IF

END_IF
