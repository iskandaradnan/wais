USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ScheduledWorkOrderRpt]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <12/06/2018>
-- Description:	Screen fetch
-- =============================================   
EXEC [uspFM_ScheduledWorkOrderRpt] @Hospital_Id=2,@WO_Type='ppm',@From_Date='2017-04-05',@To_Date='2018-06-05'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     

  
CREATE PROCEDURE [dbo].[uspFM_ScheduledWorkOrderRpt]                                      
(                                             
  @Hospital_Id  VARCHAR(20) =null,	-- like Facility_Id
  @WO_Type		varchar(20),  
  @From_Date    VARCHAR(200),
  @To_Date      VARCHAR(200)  
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN TRY
 
        
SELECT		'Pantai Holdings Sdn Bhd' AS Company_Name,'' AS	State_Name,'Pantai Hospital Ipoh'	AS Hospital_Name, 2 AS	Hospital_Id,27 AS	Work_Order_Id,'WO/BEMS/000003' AS	Work_Order_No,
'01-Jan-2018 17:53' AS	Scheduled_Date, 'UL01' AS	User_Location_Code,'UserLocation 1' AS	User_Location_Name,'Assest36' AS	Asset_Number,'cccc' AS	Asset_Description,
'Block1' AS	Department,'Contract' AS	Maintenance_Type,'' AS	Agreed_Date,'' AS	Completed_Date,'' AS	Total_Down_Time_Hrs,'WO/BEMS/000003' AS	Details,
'Completed' AS	Status, 0.6 AS	AssetAge,'TypeCode1' AS	TypeCode,'W2'	WorkGroup



END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                               
END       
     


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
