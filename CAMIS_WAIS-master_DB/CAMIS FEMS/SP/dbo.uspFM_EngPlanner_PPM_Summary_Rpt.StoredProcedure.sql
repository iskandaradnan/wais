USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlanner_PPM_Summary_Rpt]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select 1 as AssetNo,'test' as AssetDescription,


--exec [uspFM_EngPlanner_PPM_Summary_Rpt_New] @pServiceId=2,@pFacilityId=2,@pWorkGroupid=1,@pYear=2018,@pPageIndex=1,@pPageSize=20


CREATE PROCEDURE [dbo].[uspFM_EngPlanner_PPM_Summary_Rpt]
(
	@pServiceId			INT,
	@pFacilityId		INT,
	@pWorkGroupid		INT,
	@pYear				INT,
	@pPageIndex			INT   Null,
	@pPageSize			INT   Null
)
as begin
BEGIN TRY
	select 'PAN101' as AssetNo,'ewrwerw' as	AssetDescription,1 as	CustomerId,
	0001 as	TaskCode,'Pantai Hospital Ipoh' as	FacilityName,'UA01' as	UserAreaCode,
	'UserArea' as	UserAreaName,'M154' as	Model,
	1 as	Week1,	2 as	Week2,	3 as	Week3,	4 as	Week4,	5 as	Week5,	6 as	Week6,	7 as	Week7,	8 as	Week8,	9 as	Week9,	
	10 as	Week10,	11 as	Week11,	12 as	Week12,	13 as	Week13,	14 as	Week14,	15 as	Week15,	1 as	Week16,	1 as	Week17,	1 as	Week18,	
	1 as	Week19,	1 as	Week20,	1 as	Week21,	1 as	Week22,	1 as	Week23,	1 as	Week24,	1 as	Week25,	1 as	Week26,	1 as	Week27,	
	1 as	Week28,	1 as	Week29,	1 as	Week30,	1 as	Week31,	1 as	Week32,	1 as	Week33,	1 as	Week34,	1 as	Week35,	1 as	Week36,	
	1 as	Week37,	1 as	Week38,	1 as	Week39,	1 as	Week40,	1 as	Week41,	1 as	Week42,	1 as	Week43,	1 as	Week44,	1 as	Week45,	
	1 as	Week46,	1 as	Week47,	1 as	Week48,	1 as	Week49,	1 as	Week50,	1 as	Week51,	1 as	Week52,	1 as	Week53,	

	'January' as	WeekNo1,'January' as	WeekNo2,	'January' as	WeekNo3,	'January' as	WeekNo4,	'January' as	WeekNo5,	'January' as	WeekNo6,	'January' as	WeekNo7,	
	'January' as	WeekNo8,	'January' as	WeekNo9,	'January' as	WeekNo10,	'January' as	WeekNo11,	'January' as	WeekNo12,	'January' as	WeekNo13,	'January' as	WeekNo14,	'January' as	WeekNo15,	
	'January' as	WeekNo16,	'January' as	WeekNo17,	'January' as	WeekNo18,	'January' as	WeekNo19,	'January' as	WeekNo20,	
	'January' as	WeekNo21,'January' as	WeekNo22,	'January' as	WeekNo23,	'January' as	WeekNo24,	'January' as	WeekNo25,	'January' as	WeekNo26,	
	'January' as	WeekNo27,	'January' as	WeekNo28,	'January' as	WeekNo29,	'January' as	WeekNo30,	'January' as	WeekNo31,	'January' as	WeekNo32,	
	'January' as	WeekNo33,	'January' as	WeekNo34,	'January' as	WeekNo35,	'January' as	WeekNo36,	'January' as	WeekNo37,	'January' as	WeekNo38,	
	'January' as	WeekNo39,	'January' as	WeekNo40,	'January' as	WeekNo41,	'January' as	WeekNo42,	'January' as	WeekNo43,	'January' as	WeekNo44,	
	'January' as	WeekNo45,	'January' as	WeekNo46,	'January' as	WeekNo47,	'January' as	WeekNo48,	'January' as	WeekNo49,	
	'January' as	WeekNo50,	'January' as	WeekNo51,	'January' as	WeekNo52,	'January' as	WeekNo53,	
	1 as TotalRecords	,
	1.00 asTotalPageCalc


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
end
GO
