__METADATA__
{
  "v3Meta": {
    "objectGuid": "8106fbb6-7a08-449b-9abc-9a4994e4ed4c",
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
					IF fbAxisMotion.ifGetAxisState.xDisabled THEN
						xPackMlStateComplete := TRUE;
					ELSE
						fbAxisMotion.ifCmd.Stop(
							i_lrDeceleration := i_stConfiguration.ifAxis.lrErrorStopDec,
							i_lrJerk         := i_stConfiguration.ifAxis.lrErrorStopJerk,
							i_diJobId        := 99
						);
					END_IF
				ELSIF ABS(fbAxisMotion.ifGetMotionValues.lrVelocity) < 0.1 OR fbLogicState.timElapsedTimeInState > T#3S THEN
					fbAxisMotion.ifCmd.ResetCmdStopLock();
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: // disable axis
				IF fbLogicState.xEntryAction THEN
					fbAxisMotion.ifCmd.PowerOff();
				ELSIF NOT fbAxisMotion.ifGetAxisInfo.xPowerOn THEN
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
					IF NOT fbAxisMotion.ifGetAxisInfo.xIsModulo THEN
						// defining axis type reset xIsHomed, therefore set axis type only when necessary
						fbAxisMotion.ifConfiguration.SetAxisTypeModulo(i_lrPeriod := 360.0);
					END_IF
					IF NOT fbAxisMotion.ifGetAxisInfo.xIsHomed THEN
						// defining axis type reset xIsHomed, therefore set axis type only when necessary
						fbAxisMotion.ifConfiguration.SetHomeOk();
					END_IF
					fbAxisMotion.ifCmd.PowerOn();
				ELSIF fbAxisMotion.ifGetAxisInfo.xPowerOn THEN
					xPackMlStateComplete := TRUE;
				END_IF
		END_CASE
	PackML.ET_States.Stopping:
		CASE fbLogicState.diState OF
			0: 	IF fbLogicState.xEntryAction THEN
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
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10: xPackMlStateComplete := TRUE;
		END_CASE
	PackML.ET_States.Stopped:
		;
	PackML.ET_States.Resetting:
		CASE fbLogicState.diState OF
			0: // wait for possible diag quit finished
				IF NOT fbDiagHandler.xDiagQuitInProgress THEN
					fbLogicState.SetNextState(i_diState := fbLogicState.diState + 10);
				END_IF
			10:
				xPackMlStateComplete := TRUE;
		END_CASE
	PackML.ET_States.Idle:
		;
	PackML.ET_States.Starting:
		Starting();
	PackML.ET_States.Execute:
		Execute();
	PackML.ET_States.Holding:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Held:
		;
	PackML.ET_States.UnHolding:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Suspending:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Suspended:
		;
	PackML.ET_States.UnSuspending:
		xPackMlStateComplete := TRUE;
	PackML.ET_States.Completing:
		xPackMlStateComplete := TRUE;
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
