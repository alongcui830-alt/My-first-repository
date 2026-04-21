__METADATA__
{
  "v3Meta": {
    "objectGuid": "fec3d380-c3a2-489c-a00c-c53c1ccc5794",
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
	// start movement
		IF fbLogicState.xEntryAction THEN
			fbAxisMotion.ifCmd.GearIn(
				i_ifMaster		 := i_stConfiguration.ifMasterAxis,
				i_lrAcceleration := 500.0
			);
		ELSIF fbAxisMotion.ifCmd.stGetRecentCmdState.xContinuous THEN
			// when target velociy reached, switch to PackML state execute
			xPackMlStateComplete := TRUE;
		END_IF
		
ELSIF q_stOutputData.etActiveOperationMode = ET_OperationMode.Manual THEN

	 // activate Jog and switch to PackML state execute
		fbAxisMotion.ifCmd.xJogForward  := FALSE;
		fbAxisMotion.ifCmd.xJogBackward := FALSE;
		lrJogVel := i_stInputData.lrJogVel;
		fbAxisMotion.ifCmd.Jog(
			i_lrVelocity     := lrJogVel,
			i_lrAcceleration := lrJogAcc,
			i_lrDeceleration := lrJogDec,
			i_lrJerk         := lrJerk);
		xPackMlStateComplete := TRUE;
		
END_IF
