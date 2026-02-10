USE [WHIO_Metadata]
GO
/****** Object:  StoredProcedure [MPri].[PROC_CREATE_TABLE_FACT_DIAG_ALT]    Script Date: 2/10/2026 4:19:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [MPri].[PROC_CREATE_TABLE_FACT_DIAG_ALT] 
AS
BEGIN

--Create MPri.xFact_Diag_Alt
	--Approx 18 mins
	IF EXISTS (
		 SELECT * 
		 FROM SYS.OBJECTS 
		 WHERE 1=1
			 AND OBJECT_ID = OBJECT_ID(N'[MPri].[xFact_Diag_Alt_Test]')
			 AND TYPE IN (N'U'))
	DROP TABLE [MPri].[xFact_Diag_Alt_Test]

	SELECT *
	INTO #PersonTest
	FROM WHIO_SID.dbo.xDim_IntPerson


	ALTER TABLE #PersonTest
	ADD [effectiveStartDate] Date DEFAULT '1-01-1999' NOT NULL,
	[effectiveEndDate] Date DEFAULT '1-01-1999' NOT NULL

	UPDATE #PersonTest
	SET effectiveStartDate =
	CASE
		WHEN _version='20181200' THEN '10-1-2018'
		WHEN _version='20190600' THEN '4-1-2019'
		WHEN _version='20190900' THEN '7-1-2019'
		WHEN _version='20191200' THEN '10-1-2019'
		WHEN _version='20200300' THEN '1-1-2020'
		WHEN _version='20200600' THEN '4-1-2020'
		WHEN _version='20200900' THEN '7-1-2020'
		WHEN _version='20201200' THEN '10-1-2020'
		WHEN _version='20210300' THEN '1-1-2021'
		WHEN _version='20210600' THEN '4-1-2021'
		WHEN _version='20210900' THEN '7-1-2021'
		WHEN _version='20211200' THEN '10-1-2021'
		WHEN _version='20220300' THEN '1-1-2022'
		WHEN _version='20220600' THEN '4-1-2022'
		WHEN _version='20220900' THEN '7-1-2022'
		WHEN _version='20221200' THEN '10-1-2022'
		WHEN _version='20230300' THEN '1-1-2023'
		WHEN _version='20230600' THEN '4-1-2023'
		WHEN _version='20230900' THEN '7-1-2023'
		WHEN _version='20231200' THEN '10-1-2023'
		WHEN _version='20240300' THEN '1-1-2024'
		WHEN _version='20240600' THEN '4-1-2024'
		WHEN _version='20240900' THEN '7-1-2024'
		WHEN _version='20241200' THEN '10-1-2024'
		WHEN _version='20250300' THEN '1-1-2025'
		WHEN _version='20250600' THEN '4-1-2025'
		ELSE effectiveStartDate
	END


	UPDATE #PersonTest
	SET effectiveEndDate =
	CASE
		WHEN _version='20181200' THEN '12-31-2018'
		WHEN _version='20190600' THEN '6-30-2019'
		WHEN _version='20190900' THEN '9-30-2019'
		WHEN _version='20191200' THEN '12-31-2019'
		WHEN _version='20200300' THEN '3-31-2020'
		WHEN _version='20200600' THEN '6-30-2020'
		WHEN _version='20200900' THEN '9-30-2020'
		WHEN _version='20201200' THEN '12-31-2020'
		WHEN _version='20210300' THEN '3-31-2021'
		WHEN _version='20210600' THEN '6-30-2021'
		WHEN _version='20210900' THEN '9-30-2021'
		WHEN _version='20211200' THEN '12-31-2021'
		WHEN _version='20220300' THEN '3-31-2022'
		WHEN _version='20220600' THEN '6-30-2022'
		WHEN _version='20220900' THEN '9-30-2022'
		WHEN _version='20221200' THEN '12-31-2022'
		WHEN _version='20230300' THEN '3-31-2023'
		WHEN _version='20230600' THEN '6-30-2023'
		WHEN _version='20230900' THEN '9-30-2023'
		WHEN _version='20231200' THEN '12-31-2023'
		WHEN _version='20240300' THEN '3-31-2024'
		WHEN _version='20240600' THEN '6-30-2024'
		WHEN _version='20240900' THEN '9-30-2024'
		WHEN _version='20241200' THEN '12-31-2024'
		WHEN _version='20250300' THEN '3-31-2025'
		WHEN _version='20250600' THEN '6-30-2025'
		ELSE effectiveEndDate
	END

	SELECT
		 Whio_MemberId
		,DiagCode
		,ServiceDate
		,MemberCounty
		,MemberZipCode
		,MemberZCTA
		--,ISNULL(DiagFact.MemberZCTA,ZIP.ZCTA) 'MemberZCTA'
--		,ProductSectorMod AS 'InsuranceType'
		,SUM(Cnt) AS 'Count'
	INTO [WHIO_Metadata].[MPri].[xFact_Diag_Alt_Test] ---- ~ 8.5 min  + Ndx time...
	FROM (
			SELECT
				 IMC.Whio_MemberId
				,IMC.ServiceDate
				,COALESCE(UPPER(ZCTA.MemberCounty),UPPER(P.MemberCountyMod)) 'MemberCounty'
				,COALESCE(UPPER(ZCTA.MemberZipCode),UPPER(P.MemberZipCodeMod)) 'MemberZipCode'
				,ZCTA.MemberZCTA
		--		,E.ProductSectorMod
				,IMC.IcdDiagnosisCode1
				,IMC.IcdDiagnosisCode2
				,IMC.IcdDiagnosisCode3
				,IMC.IcdDiagnosisCode4
				,IMC.IcdDiagnosisCode5
				,IMC.IcdDiagnosisCode6
				,IMC.IcdDiagnosisCode7
				,IMC.IcdDiagnosisCode8
				,IMC.IcdDiagnosisCode9
				,IMC.IcdDiagnosisCode10
				,COUNT(*) Cnt
			FROM WHIO_SID.dbo.xFact_IntMedClaim IMC
				LEFT JOIN #PersonTest P
					ON P.whio_MemberId=IMC.Whio_MemberId
						AND IMC.ServiceDate >= P.effectiveStartDate
						AND IMC.ServiceDate <=P.effectiveEndDate
				LEFT JOIN WHIO_Metadata.MPri.xDim_ZCTA ZCTA
							ON ZCTA.whio_MemberId=IMC.Whio_MemberId

--Added 6/5/2025 as an experiment
			--	LEFT JOIN WHIO_SID.dbo.xDim_IntEligibility E
			--		ON IMC.Eligibility_xKey=E.Eligibility_xKey

			WHERE IMC.Whio_MemberId IS NOT NULL
			GROUP BY
				 IMC.Whio_MemberId
				,IMC.ServiceDate
				,COALESCE(UPPER(ZCTA.MemberCounty),UPPER(P.MemberCountyMod))
				,COALESCE(UPPER(ZCTA.MemberZipCode),UPPER(P.MemberZipCodeMod))
				,ZCTA.MemberZCTA
			--	,E.ProductSectorMod
				,IMC.IcdDiagnosisCode1
				,IMC.IcdDiagnosisCode2
				,IMC.IcdDiagnosisCode3
				,IMC.IcdDiagnosisCode4
				,IMC.IcdDiagnosisCode5
				,IMC.IcdDiagnosisCode6
				,IMC.IcdDiagnosisCode7
				,IMC.IcdDiagnosisCode8
				,IMC.IcdDiagnosisCode9
				,IMC.IcdDiagnosisCode10	
			) MC
	UNPIVOT
		(	DiagCode FOR DiagSlot IN
				(MC.IcdDiagnosisCode1
				,MC.IcdDiagnosisCode2
				,MC.IcdDiagnosisCode3
				,MC.IcdDiagnosisCode4
				,MC.IcdDiagnosisCode5
				,MC.IcdDiagnosisCode6
				,MC.IcdDiagnosisCode7
				,MC.IcdDiagnosisCode8
				,MC.IcdDiagnosisCode9
				,MC.IcdDiagnosisCode10 )

		) As DiagFact
		--	LEFT JOIN MPri.xDim_Zip_ZCTA ZIP
			--	ON DiagFact.MemberZipCode=ZIP.ZIPCODE
GROUP BY
		 Whio_MemberId
		,DiagCode
		,ServiceDate
		,MemberCounty
		,MemberZipCode
		,MemberZCTA
		--,ISNULL(DiagFact.MemberZCTA,ZIP.ZCTA)
		--,ProductSectorMod

--


SELECT *
FROM #PersonTest
WHERE whio_MemberId='WHIO2242558'

	--CREATE NONCLUSTERED INDEX [factDiag_PersonCountyDiagAlt] ON [MPri].[xFact_Diag_Alt]
	--(
	--	Whio_MemberId ASC,
	--	[DiagCode] ASC
	--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

END
