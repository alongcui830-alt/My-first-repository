__METADATA__
{
  "v3Meta": {
    "objectGuid": "53f91cc3-12b8-4e28-a5bc-df9f8f328bcd",
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
FUNCTION_BLOCK FB_VisConnectorControlPanel
VAR_INPUT
	i_pfbStackLightsAndButtons : POINTER TO SE_AFU.FB_StacklightsAndButtons;
	i_etActiveOperationMode	: ET_OperationMode;
END_VAR
VAR_OUTPUT
	q_xEStopButtonPressed     : BOOL;
	q_xStopButtonPressed      : BOOL;
	q_xResetButtonPressed     : BOOL;
	q_xStartButtonPressed     : BOOL;
	q_etOperationModeSelected : ET_OperationMode;
END_VAR
VAR
	iVisX : INT;
	iVisY : INT;
END_VAR
__IMPLEMENTATION__

