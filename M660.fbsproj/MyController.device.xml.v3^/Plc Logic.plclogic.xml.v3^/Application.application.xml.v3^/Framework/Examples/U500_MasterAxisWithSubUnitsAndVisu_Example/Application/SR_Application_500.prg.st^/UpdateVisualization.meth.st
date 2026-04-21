__METADATA__
{
  "v3Meta": {
    "objectGuid": "9ba3252d-9908-44fa-9180-d8b7c1c715e5",
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
METHOD UpdateVisualization
VAR_INPUT
END_VAR
__IMPLEMENTATION__
fbVisManager.xEnableVis  := xEnableVis;
fbVisManager.xVisCmdLock := xVisCmdLock;

fbVisManager.UpdateVisualizaiton();
IF fbVisManager.xVisDataUpdateRequested THEN
	// Update Visualization-Connectors
	fbVisControlPanel(
		i_etActiveOperationMode    := stSubUnitOutputData.etActiveOperationMode,
		i_pfbStackLightsAndButtons := ADR(fbStackLightsAndButtons),
		q_xEStopButtonPressed      => stVisuInputs.xEStopButtonPressed,
		q_xStopButtonPressed       => stVisuInputs.xStopButtonPressed,
		q_xResetButtonPressed      => stVisuInputs.xResetButtonPressed,
		q_xStartButtonPressed      => stVisuInputs.xStartButtonPressed,
		q_etOperationModeSelected  => stVisuInputs.etOperationModeSelected
	);
	fbVisManager.UpdateVisConnectorReference(
		i_uiVisConnectorIndex := ET_VisConnectors.ControlPanel, i_pbyVisConnectorAddress := ADR(fbVisControlPanel)
	);
	// Update general visualization data
	fbVisManager.GetVisConnectorReferences(
		iq_apbyVisConnectorReferences := stVisExchangeData.stVisConnectors.apbyGeneral,
		iq_axVisConnectorValid        := stVisExchangeData.axVisConnectorsValid
	);
END_IF
