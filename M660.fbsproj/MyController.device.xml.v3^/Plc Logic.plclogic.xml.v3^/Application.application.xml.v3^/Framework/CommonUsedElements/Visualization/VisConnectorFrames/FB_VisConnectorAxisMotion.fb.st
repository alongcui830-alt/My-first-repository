__METADATA__
{
  "v3Meta": {
    "objectGuid": "0d3f5cbc-8ffe-4504-9d58-0e6dc3948b57",
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
FUNCTION_BLOCK FB_VisConnectorAxisMotion
VAR_INPUT 
	i_apfbAxisMotion : ARRAY[1..c_uiMaxIndex] OF POINTER TO MFB.FB_AxisMotion;
END_VAR
VAR
	// Data exchanged with vis
	pfbSelectedAxisMotion  : POINTER TO MFB.FB_AxisMotion;
	xEnableVisCommanding   : BOOL;
	xSelectValid		   : BOOL;
	xDecreaseIndex         : BOOL;
	xDecreaseIndexPossible : BOOL;
	xIncreaseIndex         : BOOL;
	xIncreaseIndexPossible : BOOL;
	// vis logic
	uiSelectedIndex : UINT := 1;
	uiCounter		: UINT;
END_VAR
VAR CONSTANT
	c_uiMaxIndex : UINT := 5;
END_VAR
__IMPLEMENTATION__
IF xDecreaseIndex THEN
	xDecreaseIndex := FALSE;
	IF uiSelectedIndex > 1 THEN
		uiSelectedIndex := uiSelectedIndex - 1;
	END_IF
END_IF
IF xIncreaseIndex THEN
	xIncreaseIndex := FALSE;
	IF uiSelectedIndex < c_uiMaxIndex THEN
		uiSelectedIndex := uiSelectedIndex + 1;
	END_IF
END_IF
IF uiSelectedIndex = 1 THEN
	pfbSelectedAxisMotion  := i_apfbAxisMotion[1];
	xSelectValid           := i_apfbAxisMotion[1] <> 0;
	xIncreaseIndexPossible := i_apfbAxisMotion[2] <> 0;
	xDecreaseIndexPossible := FALSE;
ELSIF uiSelectedIndex = c_uiMaxIndex THEN
	pfbSelectedAxisMotion  := i_apfbAxisMotion[c_uiMaxIndex];
	xSelectValid           := i_apfbAxisMotion[c_uiMaxIndex] <> 0;
	xIncreaseIndexPossible := FALSE;
	xDecreaseIndexPossible := i_apfbAxisMotion[c_uiMaxIndex-1] <> 0;
ELSE
	pfbSelectedAxisMotion  := i_apfbAxisMotion[uiSelectedIndex];
	xSelectValid           := i_apfbAxisMotion[uiSelectedIndex] <> 0;
	xIncreaseIndexPossible := i_apfbAxisMotion[uiSelectedIndex+1] <> 0;
	xDecreaseIndexPossible := i_apfbAxisMotion[uiSelectedIndex-1] <> 0;
END_IF

