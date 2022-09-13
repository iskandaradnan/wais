use UetrackMasterdbPreProd

DROP PROCEDURE [dbo].usp_GMMaintenanceHistory
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].usp_GMMaintenanceHistory          
  @Year int
AS                     
      
BEGIN TRY      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;       
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      




	DECLARE @StartYearValue DATE;

	DECLARE @EndYearValue DATE;

	DECLARE @StartDate DATE;

	DECLARE @EndDate DATE;

	DECLARE @NoOfWeeks INT;



	SET @StartYearValue = CAST((cast((@year-1) as varchar)+'-12-01') as date);   --CONVERT(VARCHAR, ((@year)-1)+'-12-01');

	SET @EndYearValue = CAST(cast(@year as varchar)+'-12-01' as date); 				--CONVERT(VARCHAR, ((@year))+'-12-01');

	

	SELECT @StartDate =	(DATEADD(day,DATEDIFF(day,'19000107',DATEADD(month,DATEDIFF(MONTH,0, CONVERT(DATE, @StartYearValue)),30))/7*7,'19000107'))+8



	SELECT @EndDate =	(DATEADD(day,DATEDIFF(day,'19000107',DATEADD(month,DATEDIFF(MONTH,0, CONVERT(DATE, @EndYearValue)),30))/7*7,'19000107'))+7



	SELECT @NoOfWeeks = datediff(ww,@startdate,@enddate);



--SELECT @StartDate, @EndDate, datediff(ww,@startdate,@enddate) AS Weeks

	 


 	 INSERT [dbo].[GmMaintenanceYearDetailsMst] ([Year], [StartDate], [EndDate], [NoOfWeeks], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDeleted]) 

	 VALUES (@year, @StartDate, @EndDate, @NoOfWeeks, 1, GetDate(), 1, GetDate(), 0)





END TRY      
      
BEGIN CATCH      
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     )      
      
END CATCH
GO




