USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_Non_PANCREATIC_CANCER_demographics]    Script Date: 2/10/2026 3:53:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_Non_PANCREATIC_CANCER_demographics] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_non_Pancreatic_Cancer_cohort]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_non_Pancreatic_Cancer_cohort];

WITH UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_non_Pancreatic_Cancer
)
SELECT
    u.Whio_MemberId,
    SP.[Date of Birth],
    SP.Sex,
    FD.MemberZCTA 
INTO MPri.xFact_non_Pancreatic_Cancer_cohort
FROM UniqueIDs u
    LEFT JOIN MPri.xDim_StaticPerson SP
        ON u.Whio_MemberId = SP.whio_MemberId
    LEFT JOIN MPri.xFact_Diag_Alt FD
        ON u.Whio_MemberId = FD.Whio_MemberId
    LEFT JOIN MPri.xDim_WIRuralUrbanGroupings2024 G
        ON FD.MemberZCTA = G.ZCTA
GROUP BY
    u.Whio_MemberId,
    SP.Sex,
    SP.[Date of Birth],
    FD.MemberZCTA;
   

END