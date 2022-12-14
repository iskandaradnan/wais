USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DeptAreaDetailsFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_DeptAreaDetailsFetch]
-- EXEC [dbo].[sp_CLS_DeptAreaDetailsFetch] 265
(@pUserAreaId INT)
as
begin
SET NOCOUNT ON;

BEGIN TRY

 IF(EXISTS(SELECT 1 FROM CLS_DeptAreaDetailsLocation WHERE UserAreaId  = @pUserAreaId))
 BEGIN
	SELECT UserAreaId, LocationId, LocationCode, [Status], [Floor], [Walls],  [Celling], WindowsDoors, ReceptaclesContainers, FurnitureFixtureEquipments
  FROM CLS_DeptAreaDetailsLocation WHERE UserAreaId  = @pUserAreaId
 END
 ELSE
 BEGIN
	SELECT UserAreaId, UserLocationId AS LocationId, UserLocationCode AS LocationCode, 1 as [Status], CAST(0 as bit) AS [Floor], 
	 CAST(0 as bit) AS [Celling], CAST(0 as bit) as [Walls], CAST(0 as bit) AS WindowsDoors, CAST(0 as bit) AS  ReceptaclesContainers, 
	 CAST(0 as bit) AS FurnitureFixtureEquipments from MstLocationUserLocation where UserAreaId  = @pUserAreaId
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
	Error_Procedure() as 'sp_CLS_DeptAreaDetailsFetch',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
