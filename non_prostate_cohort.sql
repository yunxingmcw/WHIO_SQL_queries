USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_non_Prostate_Cancer]    Script Date: 2/10/2026 4:07:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_non_Prostate_Cancer] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_non_Prostate_Cancer]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_non_Prostate_Cancer];



WITH icd_codes AS (
    SELECT code FROM (VALUES
       ('E11'), ('N40'), ('I50'), ('N13'), ('N39'), ('G47'), ('I25'), ('I48'), ('E66'), ('N18'),
	   ('I49'), ('E87'), ('B35'), ('K59'), ('N32'), ('L97'), ('I63'), ('N30'), ('T83'), ('E78'),
	   ('I10'), ('M79'), ('G89'), ('M47'), ('M17'), ('F17'), ('M48'), ('I51'), ('D64'), ('F10'),
	   ('I12'), ('L03'), ('I45'), ('I35'), ('I95'), ('I87'), ('E86'), ('A41'), ('I69'), ('I83'),
	   ('I67'), ('L08'), ('M25'), ('M54'), ('H25'), ('M19'), ('H40'), ('M51'), ('F41'), ('J44'),
	   ('M62'), ('F32'), ('I70'), ('K76'), ('I77'), ('M16'), ('I73'), ('L60'), ('J18'), ('F33'),
	   ('M50'), ('I34'), ('I82'), ('D50'), ('K29'), ('M70'), ('I47'), ('G25'), ('J90'), ('I13'),
	   ('D63'), ('K86'), ('B95'), ('N25')

    ) AS t(code)
),
UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Prostate_Cancer_Diagnosis
)

SELECT TOP 100000 MC.*
INTO MPri.xFact_non_Prostate_Cancer
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