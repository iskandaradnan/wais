USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_JiDetails_LocationCode_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[sp_CLS_JiDetails_LocationCode_Fetch] 'WAC/L1CA2/JI/2020/2/6'
CREATE procedure [dbo].[sp_CLS_JiDetails_LocationCode_Fetch]
@pDocumentNo nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY



 IF(EXISTS(select 1 from CLS_JiDetails  WHERE  DocumentNo = @pDocumentNo ))
	 BEGIN
		 SELECT B.LocationCode,B.LocationName, [FLOOR], Walls, [Ceiling], WindowsDoors, ReceptaclesContainers, FFEquipment, B.Remarks FROM CLS_JiDetails A
			JOIN CLS_JiDetails_LocationCode B
		 ON A.DetailsId = B.DetailsId
		 WHERE  A.DocumentNo =  @pDocumentNo
	 END
 ELSE
	 BEGIN
	 DECLARE @pUserAreaCode VARCHAR(100)

	 select TOP 1 @pUserAreaCode =  UserAreaCode from CLS_JIScheduleDocument WHERE DocumentNo = @pDocumentNo 

	 DECLARE @DefaultValue VARCHAR(10)
	 SET @DefaultValue = '0'

	 select TOP 1 @DefaultValue = LovId from FMLovMst where ScreenName = 'JIDetails' AND LovKey = 'JIDetailsValues' AND FieldValue = 'Y'

		SELECT  B.LocationCode as LocationCode, C.UserLocationName AS LocationName, @DefaultValue AS [FLOOR], @DefaultValue AS Walls, @DefaultValue AS [Ceiling], @DefaultValue AS WindowsDoors, @DefaultValue AS ReceptaclesContainers, @DefaultValue AS FFEquipment, '' AS Remarks
		FROM CLS_DeptAreaDetails A
		JOIN CLS_DeptAreaDetailsLocation B ON A.UserAreaId = B.UserAreaId
		JOIN MstLocationUserLocation C ON B.UserAreaId = C.UserAreaId
		WHERE A.UserAreaCode = @pUserAreaCode AND  B.LocationId = C.UserLocationId and  B.[Status] = 1 


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
	Error_Procedure() as 'sp_CLS_JIDetails_Fetch',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
