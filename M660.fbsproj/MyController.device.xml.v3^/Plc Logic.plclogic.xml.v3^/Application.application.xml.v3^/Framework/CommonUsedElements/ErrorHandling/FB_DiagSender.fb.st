__METADATA__
{
  "v3Meta": {
    "objectGuid": "92fad9cd-c0e2-4d5d-a74f-27e4f8e14ad2",
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
FUNCTION_BLOCK FB_DiagSender
VAR_GENERIC CONSTANT
	c_udiBufferSize : UDINT := 20;
END_VAR
VAR
	ifDiagHandler       : ApDiag.IF_DiagHandlerAccess;
	astExceptionBuffer  : ARRAY[1..c_udiBufferSize] OF ApDiag.ST_DiagMessageError;
	udiActiveExceptions : UDINT;
	udiExceptionIndex   : UDINT;
	
	diDebugCounter : DINT;
	uiMaxSeverity : UINT;
	uiMinSeverity : UINT;
	etResultBuffer : ApDiag.ET_Result;
	sString : STRING;
END_VAR
__IMPLEMENTATION__

