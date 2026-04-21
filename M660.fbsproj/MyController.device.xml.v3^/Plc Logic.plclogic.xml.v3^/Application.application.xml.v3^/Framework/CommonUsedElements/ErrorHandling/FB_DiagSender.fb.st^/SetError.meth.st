__METADATA__
{
  "v3Meta": {
    "objectGuid": "430e3660-55e5-4f33-a124-3e6dc7d7616e",
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
METHOD SetError
VAR_INPUT
	i_xActive	: BOOL;
END_VAR
VAR_IN_OUT
	iq_stDiagMsg : ApDiag.ST_DiagMessageError;
END_VAR
VAR_OUTPUT
	q_xError	: BOOL := FALSE;
END_VAR
VAR
	udiCounter	: UDINT;
	xIndexFound : BOOL;
END_VAR
__IMPLEMENTATION__
IF ifDiagHandler = 0 THEN
	q_xError := TRUE;
	RETURN;
END_IF
IF i_xActive THEN
	xIndexFound := FALSE;
	IF udiExceptionIndex > udiActiveExceptions THEN
		udiExceptionIndex := 1;
	END_IF
	FOR udiCounter := 1 TO udiActiveExceptions DO
		// If many exceptions are active/reported in one application cycle, 
		// it is expected that the exceptions are always reported in the same order 
		// therefore start searching at the place where we have left in last search 
		udiExceptionIndex := udiExceptionIndex + 1;
		IF udiExceptionIndex > udiActiveExceptions THEN
			udiExceptionIndex := 1;
		END_IF
		// check if exception was already reported before (exception is identical if diagCode ans diagSourceId are identical)
		IF (iq_stDiagMsg.diDiagCode = astExceptionBuffer[udiExceptionIndex].diDiagCode) AND (iq_stDiagMsg.udiSourceId = astExceptionBuffer[udiExceptionIndex].udiSourceId) THEN
			xIndexFound := TRUE;
			IF iq_stDiagMsg.uiSeverity > astExceptionBuffer[udiExceptionIndex].uiSeverity THEN
				// if exception is reported with higher severity, we update the send exception
				astExceptionBuffer[udiExceptionIndex] := iq_stDiagMsg;
				ifDiagHandler.SetDiagMsgError(i_stDiagMsg := astExceptionBuffer[1], q_xError => q_xError, q_etResult => , q_sResultMsg => );	
				diDebugCounter := diDebugCounter+1;	
				uiMaxSeverity := MAX(uiMaxSeverity, iq_stDiagMsg.uiSeverity);
				uiMinSeverity := MIN(uiMinSeverity, iq_stDiagMsg.uiSeverity);
			ELSE
				;// diag message was already send, we do not need to repeate ourself
			END_IF
			EXIT;
		END_IF
	END_FOR
	IF NOT xIndexFound THEN
		// new exception, not part of the current list
		IF udiActiveExceptions = c_udiBufferSize THEN
			;
		ELSE
			udiActiveExceptions := udiActiveExceptions +1;
			astExceptionBuffer[udiActiveExceptions] := iq_stDiagMsg;
			ifDiagHandler.SetDiagMsgError(i_stDiagMsg := astExceptionBuffer[udiActiveExceptions], q_xError => q_xError, q_etResult => etResultBuffer , q_sResultMsg => sString);
				diDebugCounter := diDebugCounter+1;	
				uiMaxSeverity := MAX(uiMaxSeverity, iq_stDiagMsg.uiSeverity);
				uiMinSeverity := MIN(uiMinSeverity, iq_stDiagMsg.uiSeverity);
		END_IF
	END_IF
ELSE
	;
END_IF
