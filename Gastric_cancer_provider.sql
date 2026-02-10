USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_Gastric_Cancer_Provider]    Script Date: 2/10/2026 4:22:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_Gastric_Cancer_Provider] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Gastric_Cancer_Provider]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Gastric_Cancer_Provider];

WITH UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Gastric_Cancer_Diagnosis
)
SELECT u.Whio_MemberId,MC.ServiceDate,MC.BillingProviderNpi,MC.ServicingProviderNpi,MC.PlaceOfServiceCode,MC.BillingProvider_xKey,
	MC.ServicingProvider_xKey, MC.BillingProviderTaxId, MC.TypeOfBillCode, MC.RevenueCode
INTO MPri.xFact_Gastric_Cancer_Provider
FROM UniqueIDs u
LEFT JOIN WHIO_SID.dbo.xFact_IntMedClaim MC
		ON u.Whio_MemberId=MC.whio_MemberId


END