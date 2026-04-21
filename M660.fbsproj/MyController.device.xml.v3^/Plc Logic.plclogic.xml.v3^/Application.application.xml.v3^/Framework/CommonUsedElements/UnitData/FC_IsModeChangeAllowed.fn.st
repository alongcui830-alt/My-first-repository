__METADATA__
{
  "v3Meta": {
    "objectGuid": "2522c9c8-67c7-4ba8-a906-c6b2f0bd14d8",
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
FUNCTION FC_IsModeChangeAllowed : BOOL
VAR_INPUT
	i_etCurrentState       : PackML.ET_States;
	i_diAllowedModeChanges : DINT;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
CASE i_etCurrentState OF
	PackML.ET_States.Aborting:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Aborting));
	PackML.ET_States.Aborted:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Aborted));
	PackML.ET_States.Clearing:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Clearing));
	PackML.ET_States.Stopping:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Stopping));
	PackML.ET_States.Stopped:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Stopped));
	PackML.ET_States.Resetting:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Resetting));
	PackML.ET_States.Idle:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Idle));
	PackML.ET_States.Starting:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Starting));
	PackML.ET_States.Execute:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Execute));
	PackML.ET_States.Suspending:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Suspending));
	PackML.ET_States.Suspended:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Suspended));
	PackML.ET_States.UnSuspending:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.UnSuspending));
	PackML.ET_States.Holding:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Holding));
	PackML.ET_States.Held:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Held));
	PackML.ET_States.UnHolding:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.UnHolding));
	PackML.ET_States.Completing:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Completing));
	PackML.ET_States.Complete:
		FC_IsModeChangeAllowed := TO_BOOL(TO_UDINT(i_diAllowedModeChanges) AND TO_UDINT(PackML.ET_StateModelDefinition.Complete));
	ELSE
		FC_IsModeChangeAllowed := FALSE;
END_CASE
