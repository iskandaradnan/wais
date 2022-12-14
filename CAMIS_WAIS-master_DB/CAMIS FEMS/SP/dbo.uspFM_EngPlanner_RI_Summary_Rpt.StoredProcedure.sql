USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlanner_RI_Summary_Rpt]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlanner_RI_Summary
Description			: Get the RI summary Printout 
Authors				: Dhilip V
Date				: 07-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
exec uspFM_EngPlanner_RI_Summary_Rpt @pServiceId=2,@pFacilityId=2,@pWorkGroupid=1,@pYear=2018,=1,=20
SELECT * FROM EngPlannerTxn WHERE TypeofPlanner=35
SELECT * FROM FMlOVMST WHERE LOVID=35
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngPlanner_RI_Summary_Rpt]
(
	@pServiceId			INT,
	@pFacilityId		INT,
	@pWorkGroupid		INT,
	@pYear				INT
				
)

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @pTypeofPlanner		INT	=	35
	DECLARE	@TotalRecords		INT
	DECLARE	@pTotalPage			NUMERIC(24,2)

-- Execution

	SET DATEFIRST 1
	--declare @pYear int



	SELECT	'' AS UserAreaCode,
			'' AS UserAreaName,
			'' AS FacilityName,
			0  AS CustomerId,
			0 AS Week1,
			0 AS Week2,
			0 AS Week3,
			0 AS Week4,
			0 AS Week5,
			0 AS Week6,
			0 AS Week7,
			0 AS Week8,
			0 AS Week9,
			0 AS Week10,
			0 AS Week11,
			0 AS Week12,
			0 AS Week13,
			0 AS Week14,
			0 AS Week15,
			0 AS Week16,
			0 AS Week17,
			0 AS Week18,
			0 AS Week19,
			0 AS Week20,
			0 AS Week21,
			0 AS Week22,
			0 AS Week23,
			0 AS Week24,
			0 AS Week25,
			0 AS Week26,
			0 AS Week27,
			0 AS Week28,
			0 AS Week29,
			0 AS Week30,
			0 AS Week31,
			0 AS Week32,
			0 AS Week33,
			0 AS Week34,
			0 AS Week35,
			0 AS Week36,
			0 AS Week37,
			0 AS Week38,
			0 AS Week39,
			0 AS Week40,
			0 AS Week41,
			0 AS Week42,
			0 AS Week43,
			0 AS Week44,
			0 AS Week45,
			0 AS Week46,
			0 AS Week47,
			0 AS Week48,
			0 AS Week49,
			0 AS Week50,
			0 AS Week51,
			0 AS Week52,
			0 AS Week53
	

		--cross apply (select * from ( select * from #WeekNo_Name ) x pivot
		--(
		--	MAX(MonthName)
		--	for WeekNo in (WeekNo1,WeekNo2,WeekNo3,WeekNo4,WeekNo5,WeekNo6,WeekNo7,WeekNo8,WeekNo9,WeekNo10,WeekNo11,WeekNo12,WeekNo13,WeekNo14,WeekNo15,WeekNo16,WeekNo17,WeekNo18,WeekNo19,WeekNo20,WeekNo21,WeekNo22,WeekNo23,WeekNo24,WeekNo25,
		--	WeekNo26,WeekNo27,WeekNo28,WeekNo29,WeekNo30,WeekNo31,WeekNo32,WeekNo33,WeekNo34,WeekNo35,WeekNo36,WeekNo37,WeekNo38,WeekNo39,WeekNo40,WeekNo41,WeekNo42,WeekNo43,WeekNo44,WeekNo45,WeekNo46,WeekNo47,WeekNo48,WeekNo49,WeekNo50,WeekNo51,WeekNo52,WeekNo5
--3)
		--) p 
		--) a



	


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
