__METADATA__
{
  "v3Meta": {
    "objectGuid": "d1c238bf-8b13-4341-928f-5fbb6f76fcc8",
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
METHOD Starting
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF q_stOutputData.etActiveOperationMode = ET_OperationMode.Production THEN

	CASE fbLogicState.diState OF
		0: // start movement
			fbAxisMotion.ifCmd.MoveVelocity(
				i_etBufferMode   := MOIN.ET_Buffer_Mode.Aborting,
				i_lrVelocity     := lrProductionVel,
				i_lrAcceleration := lrProductionAcc,
				i_lrDeceleration := lrProductionDec,
				i_lrJerk         := lrJerk,
				i_etDirection    := MOIN.ET_Direction.PositiveDirection
			);
			fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
			
		10: IF fbAxisMotion.ifCmd.stGetRecentCmdState.xContinuous THEN
				xPackMlStateComplete := TRUE;
			END_IF
	END_CASE

ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual THEN
		// activate Jog and switch to PackML state execute
		fbAxisMotion.ifCmd.xJogForward  := FALSE;
		fbAxisMotion.ifCmd.xJogBackward := false;
		fbAxisMotion.ifCmd.Jog(
			i_lrVelocity     := lrJogVel,
			i_lrAcceleration := lrJogAcc,
			i_lrDeceleration := lrJogDec,
			i_lrJerk         := lrJerk,
		);
		xPackMlStateComplete := TRUE;

END_IF
