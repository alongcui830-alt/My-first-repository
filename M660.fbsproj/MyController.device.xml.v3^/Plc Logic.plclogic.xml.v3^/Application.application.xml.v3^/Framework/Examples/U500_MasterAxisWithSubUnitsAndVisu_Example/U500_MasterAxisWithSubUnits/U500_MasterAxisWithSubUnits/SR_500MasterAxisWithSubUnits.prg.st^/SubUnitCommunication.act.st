__METADATA__
{
  "v3Meta": {
    "objectGuid": "48a8d848-1648-4499-b0cc-be6a9359c86b",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
stSubUnitAInputData.lrJogVel := i_stInputData.lrJogVelocity;
SR_510SubUnitA.i_stInputData := stSubUnitAInputData;
SR_510SubUnitA();
stSubUnitAOutputData := SR_510SubUnitA.q_stOutputData;

stSubUnitBInputData.lrJogVel := i_stInputData.lrJogVelocity;
SR_520SubUnitB.i_stInputData := stSubUnitBInputData;
SR_520SubUnitB();
stSubUnitBOutputData := SR_520SubUnitB.q_stOutputData;
