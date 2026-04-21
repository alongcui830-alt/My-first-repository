__METADATA__
{
  "v3Meta": {
    "objectGuid": "3b98d4a2-a684-4faf-ad7f-2732940bb974",
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
FUNCTION_BLOCK FB_VisConnectorUnitData
VAR_INPUT
	i_uiUnitId                 : UINT;
	i_sUnitName                : STRING[80];
	i_xActive                  : BOOL;
	i_xReady                   : BOOL;
	i_etPackMlState            : PackML.ET_States;
	i_etActiveOperationMode    : ET_OperationMode;
END_VAR
VAR_OUTPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__

