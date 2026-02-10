USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_non_Gastric_Cancer_cohort_bldg]    Script Date: 2/10/2026 4:15:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_non_Gastric_Cancer_cohort_bldg] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_non_Gastric_Cancer]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_non_Gastric_Cancer];



WITH icd_codes AS (
    SELECT code FROM (VALUES
        ('E87'), ('K59'), ('K76'), ('J98'), ('K29'), ('E11'), ('K22'), ('N18'), ('F17'), ('D64'), ('I48'),
		('I50'), ('K31'), ('D50'), ('K92'), ('J18'), ('D72'), ('K80'), ('C80'), ('C18'), ('K25'),
		('K83'), ('I26'), ('K21'), ('I25'), ('E66'), ('J44'), ('I51'), ('I49'), ('K63'), ('L97'), ('N17'),
		('K44'), ('E86'), ('I82'), ('J96'), ('J90'), ('I95'), ('G62'), ('N13'), ('I73'), ('I35'), ('K56'),
		('J43'), ('A41'), ('K20'), ('T45'), ('D63'), ('M89'), ('C34'), ('K82'), ('M54'), ('J45'),
		('N28'), ('M48'), ('F10'), ('N39'), ('L03'), ('B35'), ('I12'), ('E83'), ('I45'), ('I44'), ('I63'),
		('I34'), ('C44'), ('I87'), ('I42'), ('G93'), ('K86'), ('I27'), ('L02'), ('C50'), ('I21'), ('T82'),
		('M43'), ('I47'), ('K66')
    ) AS t(code)
),
UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Gastric_Cancer_Diagnosis
)

SELECT TOP 5000 MC.*
INTO MPri.xFact_non_Gastric_Cancer
FROM WHIO_SID.dbo.xFact_IntMedClaim MC 
WHERE
    (
        MC.IcdAdmissionDiagnosisCode IN (SELECT code FROM icd_codes) OR
        MC.IcdDiagnosisCode1 IN (SELECT code FROM icd_codes) OR
        MC.IcdDiagnosisCode2 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode3 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode4 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode5 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode6 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode7 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode9 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode10 IN (SELECT code FROM icd_codes) OR
		MC.IcdDiagnosisCode8 IN (SELECT code FROM icd_codes)
    )
   AND NOT EXISTS (SELECT 1 FROM UniqueIDs u WHERE u.Whio_MemberId = MC.Whio_MemberId)
ORDER BY NEWID();  -- random sample

END