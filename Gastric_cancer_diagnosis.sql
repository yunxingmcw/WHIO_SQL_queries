USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_GASTRIC_CANCER_DIAGNOSIS]    Script Date: 2/10/2026 4:20:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_GASTRIC_CANCER_DIAGNOSIS] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Gastric_Cancer_Diagnosis]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Gastric_Cancer_Diagnosis]


SELECT
	FD.Whio_MemberId
   ,SP.[Date of Birth]
   ,SP.Sex
   ,FD.MemberZCTA 
   ,FD.ServiceDate
INTO MPri.xFact_Gastric_Cancer_Diagnosis
FROM MPri.xFact_Diag_Alt FD
	LEFT JOIN MPri.xDim_StaticPerson SP
		ON FD.Whio_MemberId=SP.whio_MemberId
	LEFT JOIN MPri.xDim_WIRuralUrbanGroupings2024 G
		ON FD.MemberZCTA=G.ZCTA
WHERE FD.DiagCode IN  ('C16','C160','C161','C162','C163','C164',
						'C165','C166','C167','C168','C169')
GROUP BY
	FD.Whio_MemberId
   ,SP.Sex
   ,SP.[Date of Birth]
   ,FD.MemberZCTA
   ,FD.ServiceDate
  
   
END