__METADATA__
{
  "v3Meta": {
    "objectGuid": "99aeee89-1216-49b6-805f-55e154d72f35",
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
METHOD Stopping
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF q_stOutputData.etActiveOperationMode = ET_OperationMode.Production THEN
	
	CASE fbLogicState.diState OF
		0: // move axis to stop position - end of cycle
			IF NOT fbAxisMotion.ifGetAxisState.xErrorstop THEN
				fbAxisMotion.ifCmd.MoveAbsolute(
					i_etBufferMode   := MOIN.ET_Buffer_Mode.Aborting,
					i_lrPosition     := 0.0,
					i_lrVelocity     := lrStopVel,
					i_lrAcceleration := lrStopAcc,
					i_lrDeceleration := lrStopDec,
					i_lrJerk         := lrJerk,
					i_etDirection    := MOIN.ET_Direction.PositiveDirection,
					i_diJobId        := 90
				);
			END_IF
			fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
			
		10: IF fbAxisMotion.ifGetAxisState.xStandstill OR fbAxisMotion.ifGetAxisState.xErrorstop THEN
				xPackMlStateComplete := TRUE;
			END_IF
	END_CASE
	
ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual THEN
	
	fbAxisMotion.ifCmd.xJogForward  := FALSE;
	fbAxisMotion.ifCmd.xJogBackward := FALSE;
	IF fbLogicState.xEntryAction THEN
		IF fbAxisMotion.ifGetAxisState.xErrorstop THEN
			fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
		ELSE
			fbAxisMotion.ifCmd.Halt(
				i_lrDeceleration := lrStopDec,
				i_lrJerk         := lrJerk,
				i_diJobId        := 100
			);
		END_IF
	ELSIF fbAxisMotion.ifGetAxisState.xStandstill OR fbAxisMotion.ifGetAxisState.xErrorstop THEN
		xPackMlStateComplete := TRUE;
	END_IF
	
END_IF
