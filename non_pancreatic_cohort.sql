USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_non_Pancreatic_Cancer]    Script Date: 2/10/2026 4:05:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_non_Pancreatic_Cancer] 
AS
BEGIN

	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_non_Pancreatic_Cancer]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_non_Pancreatic_Cancer];



WITH icd_codes AS (
    SELECT code FROM (VALUES
        ('E11'), ('K86'), ('E87'), ('K76'), ('I50'), ('M79'), ('G47'), ('K21'), ('N18'), ('E66'), ('I25'),
   ('I48'), ('K83'), ('D64'), ('N39'), ('N28'), ('F10'), ('K80'), ('K85'), ('J90'), ('C80'),
    ('M54'), ('M25'), ('G89'), ('F41'), ('M19'), ('M47'), ('F17'), ('K59'), ('M17'), ('J98'),
    ('J44'), ('I51'), ('J45'), ('I49'), ('M48'), ('N28'), ('K29'), ('L03'), ('K31'), ('N17'), ('I12'),
	('L97'), ('D72'), ('I35'), ('K22'), ('N13'), ('K92'), ('N30'), ('I11'), ('N20'), ('K82'), ('G93'),
	('N32'), ('C34'), ('G40'), ('F03'), ('T85'), ('D51'), ('F32'), ('M99'), ('M51'), ('M62'),
	('N40'), ('K63'), ('F33'), ('B35'), ('I70'), ('J01'), ('D50'), ('I82'), ('L98'), ('J96'), ('E86'),
	('E83'), ('J18'), ('F43'), ('J30'), ('I95'), ('I45'), ('I44'), ('L60'), ('I73'), ('K44'), ('M50'),
	('M20'), ('J20'), ('J43'), ('I87'), ('M43'), ('G56'), ('I34'), ('J32'), ('K56'), ('M70'),
	('B96'), ('M53'), ('I08'), ('M46'), ('H10'), ('I69'), ('L89'), ('I26'), ('G31'), ('T82'), ('F31'),
	('I67'), ('T45'), ('M06'), ('K70'), ('T83'), ('C67'), ('I85'), ('M11'), ('F02')
    
    ) AS t(code)
),
UniqueIDs AS (
    SELECT DISTINCT Whio_MemberId FROM MPri.xFact_Pancreatic_Cancer_Diagnosis
)

SELECT TOP 15000 MC.*
INTO MPri.xFact_non_Pancreatic_Cancer
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