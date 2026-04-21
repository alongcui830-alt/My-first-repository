__METADATA__
{
  "v3Meta": {
    "objectGuid": "9981cf33-278e-440f-891f-7cc638180ef4",
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
				IF fbLogicState.xEntryAction THEN
					lrProductionVel := i_stInputData.lrProducingVelocity;
					fbMasterAxisMotion.ifCmd.MoveVelocity(
						i_etBufferMode   := MOIN.ET_Buffer_Mode.Aborting,
						i_lrVelocity     := lrProductionVel,
						i_lrAcceleration := lrProductionAcc,
						i_lrDeceleration := lrProductionDec,
						i_lrJerk         := lrJerk,
						i_etDirection    := MOIN.ET_Direction.PositiveDirection
					);
				ELSIF fbMasterAxisMotion.ifCmd.stGetRecentCmdState.xContinuous THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished Starting
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
		
	ELSIF (q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual OR q_stOutputData.etActiveOperationMode = ET_OperationMode.JogMachine) THEN
		CASE fbLogicState.diState OF
			0: // activate Jog and switch to PackML state execute
				fbMasterAxisMotion.ifCmd.xJogForward  := FALSE;
				fbMasterAxisMotion.ifCmd.xJogBackward := FALSE;
				lrJogVel := i_stInputData.lrJogVelocity;
				fbMasterAxisMotion.ifCmd.Jog(
					i_lrVelocity     := lrJogVel,
					i_lrAcceleration := lrJogAcc,
					i_lrDeceleration := lrJogDec,
					i_lrJerk         := lrJerk);
				fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
			10: // wait till sub units have finished Starting
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	END_IF
