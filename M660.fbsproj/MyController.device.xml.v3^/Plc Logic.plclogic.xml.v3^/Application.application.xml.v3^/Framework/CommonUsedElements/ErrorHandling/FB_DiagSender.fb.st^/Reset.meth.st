__METADATA__
{
  "v3Meta": {
    "objectGuid": "d47d7675-9ab5-4a05-8d22-6127e6c5e43f",
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
METHOD Reset
VAR
	stDiagEmpty : ApDiag.ST_DiagMessageError;
	udiCounter : UDINT;
END_VAR
__IMPLEMENTATION__
FOR udiCounter := 1 TO udiActiveExceptions DO
	astExceptionBuffer[udiCounter] := stDiagEmpty;
END_FOR
udiActiveExceptions := 0;
