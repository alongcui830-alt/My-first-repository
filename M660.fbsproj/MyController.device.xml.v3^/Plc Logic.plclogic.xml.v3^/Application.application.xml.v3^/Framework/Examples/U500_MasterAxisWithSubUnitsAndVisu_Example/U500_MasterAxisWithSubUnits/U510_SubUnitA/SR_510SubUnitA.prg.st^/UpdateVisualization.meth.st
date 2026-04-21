__METADATA__
{
  "v3Meta": {
    "objectGuid": "d1d56df3-1e73-4928-a7a2-dfe8017dd8d8",
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
IF fbVisManager.xVisDataUpdateRequested THEN
	// FR_UnitData
	fbVisConnectorUnitData(
		i_uiUnitId              := i_stConfiguration.uiUnitId,
		i_sUnitName             := i_stConfiguration.sUnitName,
		i_xActive               := q_stOutputData.xActive,
		i_xReady                := q_stOutputData.xReady,
		i_etPackMlState         := q_stOutputData.etPackMlState,
		i_etActiveOperationMode := q_stOutputData.etActiveOperationMode
	);
	fbVisManager.UpdateVisConnectorReference(
		i_uiVisConnectorIndex := ET_VisConnectors.UnitData, i_pbyVisConnectorAddress := ADR(fbVisConnectorUnitData)
	);
	// FR_DiagHandler
	fbVisManager.UpdateVisConnectorReference(
		i_uiVisConnectorIndex := ET_VisConnectors.DiagHandler, i_pbyVisConnectorAddress := ADR(fbDiagHandler)
	);
	// FR_PackML
	fbVisConnectorPackML(i_pfbPackMlStateMachine := ADR(fbPackMlState), q_etPackMlCmd => etPackMlVisCommand);
	fbVisManager.UpdateVisConnectorReference(i_uiVisConnectorIndex := ET_VisConnectors.PackML, i_pbyVisConnectorAddress := ADR(fbVisConnectorPackML));
	// FR_AxisMotion
	fbVisConnectorAxisMotion.i_apfbAxisMotion[1] := ADR(fbAxisMotion);
	fbVisConnectorAxisMotion();
	fbVisManager.UpdateVisConnectorReference(
		i_uiVisConnectorIndex := ET_VisConnectors.AxisMotion, i_pbyVisConnectorAddress := ADR(fbVisConnectorAxisMotion)
	);
	// FR_AxisOverview
	fbVisConnectorAxisOverview.i_aifAxis[1]    := i_stConfiguration.ifAxis;
	fbVisConnectorAxisOverview.i_asAxisName[1] := 'Axis';
	fbVisConnectorAxisOverview();
	fbVisManager.UpdateVisConnectorReference(
		i_uiVisConnectorIndex := ET_VisConnectors.AxisOverview, i_pbyVisConnectorAddress := ADR(fbVisConnectorAxisOverview)
	);
END_IF
