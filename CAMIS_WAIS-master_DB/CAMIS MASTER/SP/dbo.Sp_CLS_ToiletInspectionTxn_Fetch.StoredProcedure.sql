USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ToiletInspectionTxn_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_CLS_ToiletInspectionTxn_Fetch] 23
CREATE PROC [dbo].[Sp_CLS_ToiletInspectionTxn_Fetch]
@pToiletInspectionId INT
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

IF(@pToiletInspectionId = 0)
BEGIN
		SELECT  T.LocationCode, 0 AS Status, 
		CASE WHEN T.Mirror = 0 THEN 2 ELSE 1  END AS MIRROR ,
		CASE WHEN T.Floor = 0 THEN 2 ELSE 1 END AS Floor, 
		CASE WHEN T.Wall = 0 THEN 2 ELSE 1 END AS Wall,  
		CASE WHEN T.Urinal = 0 THEN 2 ELSE 1 END AS Urinal, 
		CASE WHEN T.Bowl = 0 THEN 2 ELSE 1 END AS Bowl,
		CASE WHEN T.Basin = 0 THEN 2 ELSE 1 END AS Basin,
		CASE WHEN T.ToiletRoll = 0 THEN 2 ELSE 1 END AS ToiletRoll,
		CASE WHEN T.SoapDispenser = 0 THEN 2 ELSE 1 END AS SoapDispenser,	
		CASE WHEN T.AutoAirFreshner = 0 THEN 2 ELSE 1 END AS AutoAirFreshner,
		CASE WHEN T.Waste = 0 THEN 2 ELSE 1 END AS Waste
		FROM CLS_DeptAreaDetails D
		INNER JOIN CLS_DeptAreaToilet T ON D.UserAreaId = T.UserAreaId
		JOIN FMLovMst F ON D.Status = F.LovId 
		 WHERE F.FieldValue = 'Active'
END
ELSE
BEGIN


SELECT LocationCode, convert(int, Status) AS [Status], Mirror, Floor, Wall, Urinal, Bowl, Basin, ToiletRoll, SoapDispenser,  AutoAirFreshner, Waste 
  from CLS_ToiletInspectionTxn_Loc WHERE ToiletInspectionId = @pToiletInspectionId
		
END
select * from CLS_ToiletInspectionTxn_Loc
		
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
Error_Procedure() as 'Sp_CLS_ToiletInspectionFetch',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
