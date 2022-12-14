USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_DailyCleaningActivityFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_CLS_DailyCleaningActivityFetch]
-- exec [dbo].[SP_CLS_DailyCleaningActivityFetch]
 --SELECT * FROM CLS_DailyCleaningActivity
 --SELECT * FROM CLS_DailyCleaningActivityGridviewfields
@DocumentNo [NVARCHAR] (100) 

as
begin
SET NOCOUNT ON;

BEGIN TRY 


IF(EXISTS(SELECT 1 FROM CLS_DailyCleaningActivity WHERE DocumentNo = @DocumentNo))
BEGIN
		SELECT  Userareacode, [Status], A1 AS DustMop, A2 AS DampMop,A3 AS Vacuum, A4 AS Washing,
		A5 AS Sweeping ,B1 AS Wiping,C1 AS Washing,D1 AS PaperHandTowel,D2 AS Toilet,D3 AS HandSoap,
		D4 AS Deodorisers,E1 AS DomesticWasteCollection FROM CLS_DailyCleaningActivityGridviewfields A
		JOIN CLS_DailyCleaningActivity B ON A.DailyActivityId = B.DailyActivityId 
		where B.DocumentNo = @DocumentNo
END
ELSE
	BEGIN
		select 
	    CLS_DeptAreaDetails.Userareacode,
		CLS_DeptAreaDetails.[Status],
		CLS_DeptAreaDailyCleaning.DustMop,
		CLS_DeptAreaDailyCleaning.DampMop,
		CLS_DeptAreaDailyCleaning.Vacuum,
		CLS_DeptAreaDailyCleaning.Washing,
		CLS_DeptAreaDailyCleaning.Sweeping,
		CLS_DeptAreaDailyCleaning.Wiping,
		CLS_DeptAreaDailyCleaning.Washing,
		CLS_DeptAreaDailyCleaning.PaperHandTowel,
		CLS_DeptAreaDailyCleaning.Toilet,
		CLS_DeptAreaDailyCleaning.HandSoap,		
		CLS_DeptAreaDailyCleaning.Deodorisers,
		CLS_DeptAreaDailyCleaning.DomesticWasteCollection
		
	FROM CLS_DeptAreaDetails 
	INNER JOIN CLS_DeptAreaDailyCleaning ON CLS_DeptAreaDetails.UserAreaId = CLS_DeptAreaDailyCleaning.UserAreaId 
	JOIN FMLovMst ON CLS_DeptAreaDetails.Status = FMLovMst.LovId
	WHERE FMLovMst.FieldValue = 'Active'
	ORDER BY CLS_DeptAreaDetails.UserAreaCode 

	END


END TRY
BEGIN CATCH
	INSERT INTO ExceptionLog (
	ErrorLine, ErrorMessage, ErrorNumber,
	ErrorProcedure, ErrorSeverity, ErrorState,
	DateErrorRaised
	)
	SELECT
	ERROR_LINE () as ErrorLine,
	Error_Message() as ErrorMessage,
	Error_Number() as ErrorNumber,
	Error_Procedure() as 'SP_CLS_DailyCleaningActivityFetch',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END

GO
