__METADATA__
{
  "v3Meta": {
    "objectGuid": "729cd080-eb13-4a79-90c4-84acb496acb8",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
CASE fbPackMlState.etStateCurrent OF
	PackML.ET_States.Aborting:
		CASE fbLogicState.diState OF
			0: // stop axis
				IF fbLogicState.xEntryAction THEN
					IF fbMasterAxisMotion.ifGetAxisState.xDisabled THEN
						xPackMlStateComplete := TRUE;
					ELSE
						fbMasterAxisMotion.ifCmd.Stop(i_lrDeceleration := 1000.0, i_lrJerk := 10000.0, i_diJobId := 99);
					END_IF
				ELSIF ABS(fbMasterAxisMotion.ifGetMotionValues.lrVelocity) < 0.1 OR fbLogicState.timElapsedTimeInState > T#3S THEN
					fbMasterAxisMotion.ifCmd.ResetCmdStopLock();
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // disable axis
				IF fbLogicState.xEntryAction THEN
					fbMasterAxisMotion.ifCmd.PowerOff();
				ELSIF NOT fbMasterAxisMotion.ifGetAxisInfo.xPowerOn THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			20: // wait till sub units have finished aborting
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Aborted:
		;
	PackML.ET_States.Clearing:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // set axis type and enable power
				IF fbLogicState.xEntryAction THEN
					IF NOT fbMasterAxisMotion.ifGetAxisInfo.xIsModulo THEN
						// defining axis type reset xIsHomed, therefore set axis type only when necessary
						fbMasterAxisMotion.ifConfiguration.SetAxisTypeModulo(i_lrPeriod := 360.0);
					END_IF
					IF NOT fbMasterAxisMotion.ifGetAxisInfo.xIsHomed THEN
						// defining axis type reset xIsHomed, therefore set axis type only when necessary
						fbMasterAxisMotion.ifConfiguration.SetHomeOk();
					END_IF
					fbMasterAxisMotion.ifCmd.PowerOn();
				ELSIF fbMasterAxisMotion.ifGetAxisInfo.xPowerOn THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			20: // wait till sub units have finished clearing
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Stopping:
		Stopping();
	PackML.ET_States.Stopped:
		;
	PackML.ET_States.Resetting:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // wait till sub units have finished stopping
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Idle:
		;
	PackML.ET_States.Starting:
		Starting();
	PackML.ET_States.Execute:
		Execute();
	PackML.ET_States.Holding:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished holding
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Held:
		;
	PackML.ET_States.UnHolding:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished unholding
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Suspending:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished suspending
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Suspended:
		;
	PackML.ET_States.UnSuspending:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished unsuspending
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Completing:
		CASE fbLogicState.diState OF
			0: // wait till sub units have finished completing
				IF fbSubUnitHandler.q_xActingStateConcluded THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Complete:
		;
	ELSE
		fbDiagSender.SetErrorData(
			i_xActive     := TRUE,
			i_diDiagCode  := ET_Result.PackMLStateInvalid,
			i_sMessage    := TO_STRING(ET_Result.PackMLStateInvalid),
			i_uiSeverity  := ET_DiagSeverity.FatalError,
			i_udiSourceId := i_stConfiguration.uiUnitId,
			i_sSource     := i_stConfiguration.sUnitName
		);
END_CASE
