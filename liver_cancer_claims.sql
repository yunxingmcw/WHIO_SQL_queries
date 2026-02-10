USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_LIVER_CANCER_other_ICD]    Script Date: 2/10/2026 4:18:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_LIVER_CANCER_other_ICD] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Liver_Cancer_other_ICD]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Liver_Cancer_other_ICD];

WITH UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Liver_Cancer_Diagnosis
)
SELECT u.Whio_MemberId, MC.ServiceDate,MC.ProcedureCode, MC.IcdAdmissionDiagnosisCode, MC.IcdDiagnosisCode1, MC.IcdDiagnosisCode2,MC.IcdDiagnosisCode3,MC.IcdDiagnosisCode4,MC.IcdDiagnosisCode5,
		MC.IcdDiagnosisCode6,MC.IcdDiagnosisCode7,MC.IcdDiagnosisCode8,MC.IcdDiagnosisCode9, MC.IcdDiagnosisCode10, 
		MC.IcdProcedureCode1,MC.IcdProcedureCode2,MC.IcdProcedureCode3,MC.IcdProcedureCode4,MC.IcdProcedureCode5,MC.IcdProcedureCode6,
		MC.BillingProviderNpi,MC.ServicingProviderNpi, MC.PlaceOfServiceCode
INTO MPri.xFact_Liver_Cancer_other_ICD
FROM UniqueIDs u
LEFT JOIN WHIO_SID.dbo.xFact_IntMedClaim MC
		ON u.Whio_MemberId=MC.Whio_MemberId


END