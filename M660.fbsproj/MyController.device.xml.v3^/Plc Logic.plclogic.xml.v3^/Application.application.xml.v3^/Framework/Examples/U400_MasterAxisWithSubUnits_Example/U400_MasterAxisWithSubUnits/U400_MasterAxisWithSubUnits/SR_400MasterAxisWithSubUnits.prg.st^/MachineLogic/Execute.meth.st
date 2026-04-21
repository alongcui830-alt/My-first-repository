__METADATA__
{
  "v3Meta": {
    "objectGuid": "3ec58cad-8c51-4e34-9324-f8221c26201d",
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

	IF lrProductionVel <> i_stInputData.lrProducingVelocity THEN
		lrProductionVel := i_stInputData.lrProducingVelocity;
		fbMasterAxisMotion.ifCmd.MoveVelocity(
			i_etBufferMode   := MOIN.ET_Buffer_Mode.Aborting,
			i_lrVelocity     := lrProductionVel,
			i_lrAcceleration := lrProductionAcc,
			i_lrDeceleration := lrProductionDec,
			i_lrJerk         := lrJerk,
			i_etDirection    := MOIN.ET_Direction.PositiveDirection
		);
	END_IF
		
ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual OR q_stOutputData.etActiveOperationMode = ET_OperationMode.JogMachine THEN
	fbMasterAxisMotion.ifCmd.xJogForward  := i_stInputData.xJogForw;
	fbMasterAxisMotion.ifCmd.xJogBackward := i_stInputData.xJogBack;
	
	IF lrJogVel <> i_stInputData.lrJogVelocity THEN
		lrJogVel := i_stInputData.lrJogVelocity;
		fbMasterAxisMotion.ifCmd.Jog(
			i_lrVelocity     := lrJogVel,
			i_lrAcceleration := lrJogAcc,
			i_lrDeceleration := lrJogDec,
			i_lrJerk         := lrJerk,
		);
	END_IF
END_IF
