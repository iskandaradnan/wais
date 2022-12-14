USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDetailsTableSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_CLS_DeptAreaDetailsTableSave](
		   @pDeptAreaId int,
		   @pUserAreaId int,
           @pLocationCode nvarchar(50),
		   @pStatus nvarchar(30),
		   @pFloor bit,
		   @pWalls bit,
		   @pCeiling bit,
		   @pWindowsDoors bit,
		   @pReceptaclesContainers bit,
		   @pFurnitureFixtureEquipment bit
		   )
as
begin

SET NOCOUNT ON;

BEGIN TRY
insert into CLS_DeptAreaDetailsTable values(
		   @pDeptAreaId, 
		   @pUserAreaId,
           @pLocationCode,
		   @pStatus,
		   @pFloor,
		   @pWalls,
		   @pCeiling,
		   @pWindowsDoors,
		   @pReceptaclesContainers,
		   @pFurnitureFixtureEquipment
		   )
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
	Error_Procedure() as 'Sp_CLS_DeptAreaDetailsTableSave',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
