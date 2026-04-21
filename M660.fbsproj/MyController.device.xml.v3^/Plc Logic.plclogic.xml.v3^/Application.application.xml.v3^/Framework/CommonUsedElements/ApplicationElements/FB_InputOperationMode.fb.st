__METADATA__
{
  "v3Meta": {
    "objectGuid": "fb291ca2-a079-4a79-919a-a88b0f0056e9",
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
FUNCTION_BLOCK FB_InputOperationMode
VAR_GENERIC CONSTANT
	c_udiNumberOfChannels : UDINT := 3;
END_VAR
VAR_INPUT
	i_xEnable    : BOOL;
	i_etDefault : ET_OperationMode;
	i_aetValues : ARRAY[1..c_udiNumberOfChannels] OF ET_OperationMode;
END_VAR
VAR_OUTPUT
	q_etValue            : ET_OperationMode;
	q_xValueChanged       : BOOL;
	q_udiChangedByChannel : UDINT;
END_VAR
VAR
	xEnableFlag       : BOOL;
	udiCounter        : UDINT;
	aetValuesLatched : ARRAY[1..c_udiNumberOfChannels] OF ET_OperationMode;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	aetValuesLatched := i_aetValues;
	q_etValue := i_etDefault;
	q_xValueChanged := FALSE;
	q_udiChangedByChannel := 0;
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	q_etValue := i_etDefault;
	q_xValueChanged := FALSE;
	q_udiChangedByChannel := 0;
ELSIF i_xEnable THEN
	q_xValueChanged := FALSE;
	q_udiChangedByChannel := 0;
	FOR udiCounter := 1 TO c_udiNumberOfChannels DO
		IF i_aetValues[udiCounter] <> aetValuesLatched[udiCounter] THEN
			q_etValue := i_aetValues[udiCounter];
			q_xValueChanged := TRUE;
			q_udiChangedByChannel := udiCounter;
			EXIT;
		END_IF
	END_FOR
	aetValuesLatched := i_aetValues;
END_IF
