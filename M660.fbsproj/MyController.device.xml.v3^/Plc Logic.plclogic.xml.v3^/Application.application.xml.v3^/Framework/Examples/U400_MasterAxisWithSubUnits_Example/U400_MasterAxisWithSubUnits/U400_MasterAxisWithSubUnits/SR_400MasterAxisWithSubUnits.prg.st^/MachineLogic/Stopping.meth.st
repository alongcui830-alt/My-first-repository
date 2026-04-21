__METADATA__
{
  "v3Meta": {
    "objectGuid": "cfd6ffd3-25fb-4e59-9695-5d63849b1ee8",
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
			0: // move master axis to stop position - end of cycle
				fbSubUnitHandler.i_xMute := TRUE; // prevent Stop command to subunits while master axis moves to stop position
				IF fbLogicState.xEntryAction THEN
					IF fbMasterAxisMotion.ifGetAxisState.xErrorstop THEN
						fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
					ELSE
						fbMasterAxisMotion.ifCmd.MoveAbsolute(
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
				ELSIF fbMasterAxisMotion.ifGetAxisState.xStandstill OR fbMasterAxisMotion.ifGetAxisState.xErrorstop THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished stopping
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
		
ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual OR q_stOutputData.etActiveOperationMode = ET_OperationMode.JogMachine THEN
	
		CASE fbLogicState.diState OF
			0: 	IF fbLogicState.xEntryAction THEN
					IF fbMasterAxisMotion.ifGetAxisState.xErrorstop THEN
						fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
					ELSE
						fbMasterAxisMotion.ifCmd.xJogForward  := FALSE;
						fbMasterAxisMotion.ifCmd.xJogBackward := FALSE;
						fbMasterAxisMotion.ifCmd.Halt(
							i_lrDeceleration := lrStopDec,
							i_lrJerk         := lrJerk,
							i_diJobId        := 100
						);
					END_IF
				ELSIF fbMasterAxisMotion.ifGetAxisState.xStandstill OR fbMasterAxisMotion.ifGetAxisState.xErrorstop THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished stopping
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
		
END_IF
