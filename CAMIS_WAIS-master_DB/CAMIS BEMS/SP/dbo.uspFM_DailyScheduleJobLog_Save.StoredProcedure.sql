USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DailyScheduleJobLog_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_PorteringTransaction_Save
Description			: Portering Transaction save
Authors				: senthilkumar E
Date				: 24-Jun-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
uspFM_DailyScheduleJobLog_Save

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_DailyScheduleJobLog_Save]
AS                                              
BEGIN TRY


INSERT INTO [dbo].[DailyScheduleJobLog]
           (
			[Status]
           ,[LastRunDate])
     VALUES
           (
           'Success'
           ,getdate())



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
GO
