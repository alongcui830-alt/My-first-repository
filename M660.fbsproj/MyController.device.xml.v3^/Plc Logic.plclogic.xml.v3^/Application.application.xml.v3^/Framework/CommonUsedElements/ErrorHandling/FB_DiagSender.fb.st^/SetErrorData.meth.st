__METADATA__
{
  "v3Meta": {
    "objectGuid": "7e81545c-132b-4a0a-8842-9f069a78c589",
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
METHOD SetErrorData : BOOL
VAR_INPUT
	i_xActive     : BOOL;
	i_diDiagCode  : DINT;
	i_sMessage    : STRING;
	i_uiSeverity  : UINT;
	i_udiSourceId : UDINT;
	i_sSource     : STRING;
END_VAR
VAR_OUTPUT
	q_xError : BOOL;
END_VAR
VAR
	stError : ApDiag.ST_DiagMessageError;
END_VAR
__IMPLEMENTATION__
stError.diDiagCode  := i_diDiagCode;
stError.sMessage    := i_sMessage;
stError.uiSeverity  := i_uiSeverity;
stError.udiSourceId := i_udiSourceId;
stError.sSource     := i_sSource;
SetError(i_xActive := i_xActive, iq_stDiagMsg := stError, q_xError => q_xError);
