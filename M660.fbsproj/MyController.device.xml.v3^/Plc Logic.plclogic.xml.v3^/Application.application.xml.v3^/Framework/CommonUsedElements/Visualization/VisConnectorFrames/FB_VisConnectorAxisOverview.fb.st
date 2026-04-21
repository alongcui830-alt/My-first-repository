__METADATA__
{
  "v3Meta": {
    "objectGuid": "6e2e03f3-175b-49c0-9140-e9d295ec2f11",
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
FUNCTION_BLOCK FB_VisConnectorAxisOverview
VAR_INPUT
	i_aifAxis : ARRAY[1..c_uiMaxNrOfAxis] OF MOIN.IF_Axis;
	i_asAxisName : ARRAY[1..c_uiMaxNrOfAxis] OF STRING[30];
END_VAR
VAR
	xMoveUp           : BOOL;
	xMoveUpPossible   : BOOL;
	xMoveDown         : BOOL;
	xMoveDownPossible : BOOL;
	aifVisAxis        : ARRAY[1..5] OF MOIN.IF_Axis;
	asVisAxisName	  : ARRAY[1..5] OF STRING[30];
	uiIndex           : UINT;
END_VAR
VAR CONSTANT
	c_uiMaxNrOfAxis : UDINT := 10;
END_VAR
__IMPLEMENTATION__
IF xMoveUp THEN
	uiIndex := uiIndex - 1;
	xMoveUp := FALSE;
END_IF
IF xMoveDown THEN
	uiIndex   := uiIndex + 1;
	xMoveDown := FALSE;
END_IF
IF uiIndex < 1 OR uiIndex > (c_uiMaxNrOfAxis - 4) THEN
	uiIndex := 1;
END_IF
aifVisAxis[1]    := i_aifAxis[uiIndex];
asVisAxisName[1] := i_asAxisName[uiIndex];
aifVisAxis[2]    := i_aifAxis[uiIndex + 1];
asVisAxisName[2] := i_asAxisName[uiIndex + 1];
aifVisAxis[3]    := i_aifAxis[uiIndex + 2];
asVisAxisName[3] := i_asAxisName[uiIndex + 2];
aifVisAxis[4]    := i_aifAxis[uiIndex + 3];
asVisAxisName[4] := i_asAxisName[uiIndex + 3];
aifVisAxis[5]    := i_aifAxis[uiIndex + 4];
asVisAxisName[5] := i_asAxisName[uiIndex + 4];
IF uiIndex <= 1 THEN
	xMoveUpPossible := FALSE;
ELSIF i_aifAxis[uiIndex - 1] = 0 THEN
	xMoveUpPossible := FALSE;
ELSE
	xMoveUpPossible := TRUE;
END_IF
IF uiIndex >= c_uiMaxNrOfAxis - 4 THEN
	xMoveDownPossible := FALSE;
ELSIF i_aifAxis[uiIndex + 5] = 0 THEN
	xMoveDownPossible := FALSE;
ELSE
	xMoveDownPossible := TRUE;
END_IF
