__METADATA__
{
  "v3Meta": {
    "objectGuid": "8f05506f-ea14-4c77-8e8d-e59dd485e43c",
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
SR_410SubUnitA.i_stInputData := stSubUnitAInputData;
SR_410SubUnitA();
stSubUnitAOutputData := SR_410SubUnitA.q_stOutputData;

stSubUnitBInputData.lrJogVel := i_stInputData.lrJogVelocity;
SR_420SubUnitB.i_stInputData := stSubUnitBInputData;
SR_420SubUnitB();
stSubUnitBOutputData := SR_420SubUnitB.q_stOutputData;
