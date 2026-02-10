USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_Liver_Cancer_insurance]    Script Date: 2/10/2026 4:17:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_Liver_Cancer_insurance] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Liver_Cancer_insurance]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Liver_Cancer_insurance];

WITH UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Liver_Cancer_Diagnosis
)
SELECT u.Whio_MemberId, IE.EffectiveDateMod,IE.EndDateMod,IE.ProductSectorMod
INTO MPri.xFact_Liver_Cancer_insurance
FROM UniqueIDs u
LEFT JOIN WHIO_SID.dbo.xDim_IntEligibility IE
		ON u.Whio_MemberId=IE.whio_MemberId


END