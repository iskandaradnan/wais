USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_DeptAreaDetails_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[sp_HWMS_DeptAreaDetails_Get] 19
CREATE procedure [dbo].[sp_HWMS_DeptAreaDetails_Get]

      @pId INT

AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	select * from HWMS_DeptAreaDetails where DeptAreaId=@pId
	select * from HWMS_DeptAreaConsumablesReceptacles where DeptAreaId=@pId and [isDeleted]=0
	select * from HWMS_DeptAreaCollectionFrequency where DeptAreaId=@pId and [isDelete]=0

	
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
		Error_Procedure() as 'sp_HWMS_DeptAreaDetails_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END


--select * from  HWMS_Dept_Area_Details A
-- join HWMS_DeptAreaDetails_Consumables_Receptacles B
 
-- on A.DeptAreaId = B.DeptAreaId 
-- join  HWMS_DeptAreaDetails_Collection_Frequency C ON  A.DeptAreaId = C.DeptAreaId where  b.DeptAreaId =  C.DeptAreaId AND  a.DeptAreaId = 8
GO
