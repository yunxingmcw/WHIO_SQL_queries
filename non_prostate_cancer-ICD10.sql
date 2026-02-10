USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_non_Prostate_Cancer_ICDDiagnosis]    Script Date: 2/10/2026 4:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_non_Prostate_Cancer_ICDDiagnosis] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_non_Prostate_Cancer_ICDDiagnosis]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_non_Prostate_Cancer_ICDDiagnosis];

WITH UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_non_Prostate_Cancer
)
SELECT u.Whio_MemberId, MC.IcdAdmissionDiagnosisCode, MC.ServiceDate,MC.IcdDiagnosisCode1,MC.IcdDiagnosisCode2,MC.IcdDiagnosisCode3,
		MC.IcdDiagnosisCode4,MC.IcdDiagnosisCode5,MC.IcdDiagnosisCode6,MC.IcdDiagnosisCode7,MC.IcdDiagnosisCode8,MC.IcdDiagnosisCode9,
		MC.IcdDiagnosisCode10, MC.ProcedureCode,MC.TypeOfBillCode,MC.PlaceOfServiceCode
INTO MPri.xFact_non_Prostate_Cancer_ICDDiagnosis
FROM UniqueIDs u
LEFT JOIN WHIO_SID.dbo.xFact_IntMedClaim MC
		ON u.Whio_MemberId=MC.whio_MemberId


END