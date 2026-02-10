USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_LIVER_CANCER_DIAGNOSIS]    Script Date: 2/10/2026 4:16:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_LIVER_CANCER_DIAGNOSIS] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Liver_Cancer_Diagnosis]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Liver_Cancer_Diagnosis]


SELECT
	FD.Whio_MemberId
   ,SP.[Date of Birth]
   ,SP.Sex
   ,FD.MemberZCTA 
   ,MC.ServiceDate
INTO MPri.xFact_Liver_Cancer_Diagnosis
FROM MPri.xFact_Diag_Alt FD
	LEFT JOIN MPri.xDim_StaticPerson SP
		ON FD.Whio_MemberId=SP.whio_MemberId
	LEFT JOIN MPri.xDim_WIRuralUrbanGroupings2024 G
		ON FD.MemberZCTA=G.ZCTA
	LEFT JOIN WHIO_SID.dbo.xFact_IntMedClaim MC
		ON FD.Whio_MemberId=MC.Whio_MemberId
WHERE FD.DiagCode IN  ('C220','C221','C222','C223','C224','C225',
						'C226','C227','C228','C229')
GROUP BY
	FD.Whio_MemberId
   ,SP.Sex
   ,SP.[Date of Birth]
   ,FD.MemberZCTA
   ,MC.ServiceDate
  
   
END