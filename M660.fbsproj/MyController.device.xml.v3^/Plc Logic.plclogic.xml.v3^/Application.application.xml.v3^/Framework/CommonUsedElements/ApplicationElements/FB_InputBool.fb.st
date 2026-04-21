__METADATA__
{
  "v3Meta": {
    "objectGuid": "440fb422-019b-42f3-b1fa-9b44591789f7",
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
FUNCTION_BLOCK FB_InputBool
VAR_GENERIC CONSTANT
	c_udiNumberOfChannels : UDINT := 3;
END_VAR
VAR_INPUT
	i_xEnable  : BOOL;
	i_xDefault : BOOL;
	i_axValues : ARRAY[1..c_udiNumberOfChannels] OF BOOL;
END_VAR
VAR_OUTPUT
	q_xValue              : BOOL;
	q_xPositiveFlank      : BOOL;
	q_xNegativeFlank      : BOOL;
	q_udiChangedByChannel : UDINT;
END_VAR
VAR
	xEnableFlag     : BOOL;
	udiCounter      : UDINT;
	axValuesLatched : ARRAY[1..c_udiNumberOfChannels] OF BOOL;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	axValuesLatched := i_axValues;
	q_xValue := i_xDefault;
	q_xPositiveFlank := FALSE;
	q_xNegativeFlank := FALSE;
	q_udiChangedByChannel := 0;
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	q_xValue := FALSE;
	q_xPositiveFlank := FALSE;
	q_xNegativeFlank := FALSE;
	q_udiChangedByChannel := 0;
ELSIF i_xEnable THEN
	q_xPositiveFlank := FALSE;
	q_xNegativeFlank := FALSE;
	q_udiChangedByChannel := 0;
	FOR udiCounter := 1 TO c_udiNumberOfChannels DO
		IF i_axValues[udiCounter] AND NOT axValuesLatched[udiCounter] THEN
			q_xValue := i_axValues[udiCounter];
			q_xPositiveFlank := TRUE;
			q_xNegativeFlank := FALSE;
			q_udiChangedByChannel := udiCounter;
			EXIT;
		ELSIF NOT i_axValues[udiCounter] AND axValuesLatched[udiCounter] THEN
			q_xValue := i_axValues[udiCounter];
			q_xPositiveFlank := FALSE;
			q_xNegativeFlank := TRUE;
			q_udiChangedByChannel := udiCounter;
			EXIT;
		END_IF
	END_FOR
	axValuesLatched := i_axValues;
END_IF
