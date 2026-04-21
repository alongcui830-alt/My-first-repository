__METADATA__
{
  "v3Meta": {
    "objectGuid": "fb1dedb2-abc2-40b3-9d72-6c4b23dc4382",
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
METHOD Init
VAR_INPUT
	i_ifDiagHandler	: ApDiag.IF_DiagHandlerAccess;
END_VAR
__IMPLEMENTATION__
ifDiagHandler := i_ifDiagHandler;
Reset();
