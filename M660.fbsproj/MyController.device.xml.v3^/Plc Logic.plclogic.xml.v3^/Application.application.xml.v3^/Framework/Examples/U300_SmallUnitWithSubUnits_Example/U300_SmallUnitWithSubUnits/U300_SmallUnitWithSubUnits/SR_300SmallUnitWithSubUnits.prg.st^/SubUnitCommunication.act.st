__METADATA__
{
  "v3Meta": {
    "objectGuid": "e2b28486-3504-4358-aa79-eb2b33221690",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
SR_310SubUnitA.i_stInputData := stSubUnitAInputData;
SR_310SubUnitA();
stSubUnitAOutputData := SR_310SubUnitA.q_stOutputData;

SR_320SubUnitB.i_stInputData := stSubUnitBInputData;
SR_320SubUnitB();
stSubUnitBOutputData := SR_320SubUnitB.q_stOutputData;
