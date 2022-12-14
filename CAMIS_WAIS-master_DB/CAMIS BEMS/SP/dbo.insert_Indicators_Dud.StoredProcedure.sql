USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[insert_Indicators_Dud]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  --exec Call_Indicators_Demerit
CREATE PROCEDURE [dbo].[insert_Indicators_Dud]  
(  
@ptime As int,  
 @pWorkOrderPriority As int  ,
  @pMaintenanceWorkType As int  ,
   @pAssetId As int  ,
    @pWorkOrderId AS int,
	@pWorkOrderHistoryId AS int

)  
AS   
  
-- Exec [DeleteUserRole]   
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : Indicators  
--DESCRIPTION  : calculate  
--AUTHORS   : vijay  
--DATE    : 31-JAN-2020  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--VIJAY IND           : 31-JAN-2020 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
   DECLARE @T1 int = 0
DECLARE @T2 int = 0
DECLARE @IND int = 0
DECLARE @COST int = 0
DECLARE @COND_IND int = 0
IF OBJECT_ID('tempdb..#EngMaintenanceWorkOrdering') IS NOT NULL              
DROP TABLE #EngMaintenanceWorkOrdering   
IF OBJECT_ID('tempdb..#Call_Indicators') IS NOT NULL              
DROP TABLE #Call_Indicators 
  create Table #Call_Indicators  (   
 [KPI_ID] [int] NOT NULL,    
 [cost] [int] NOT NULL)   
   
 
 select * into #EngMaintenanceWorkOrdering from CALL_CONDITIONS where CALL_CONDITIONS_TYPEOFREQUEST=@pMaintenanceWorkType AND CALL_CONDITIONS_SCREEN_ID=1 AND CALL_CONDITIONS_INDICATOR_Active=1 AND CALL_CONDITIONS_INDICATOR_condition=@pWorkOrderPriority
  select * from #EngMaintenanceWorkOrdering
 select @T1=CALL_CONDITIONS_INDICATOR_min_time,@T2=CALL_CONDITIONS_INDICATOR_Max_Time,@IND=IND_ID from #EngMaintenanceWorkOrdering
 if @ptime>@T1
 BEGIN
  select @COST= CAST(PurchaseCostRM AS int) from EngAsset where AssetId=@pAssetId
 --DECLARE @COST int = 0
 --select @COST= CAST(PurchaseCostRM AS int) from EngAsset where AssetId=159
 --print @COST
 --insert into #Call_Indicators exec Call_Indicators @PurchaseCostRM=1212212,@kpi_ind_Id=8

 insert into #Call_Indicators exec Call_Indicators @PurchaseCostRM=@COST, @kpi_ind_Id=@IND


select * from #Call_Indicators
--DECLARE @COST int = 0
--DECLARE @COND_IND int = 0
  select @COND_IND=KPI_ID,@COST=cost from #Call_Indicators
 -- insert into  KPI_GENERATOR values(12,12,@COST, 8,@COND_IND)
 IF NOT EXISTS (SELECT 1 FROM KPI_GENERATOR WHERE Unique_val =@pWorkOrderHistoryId+@pWorkOrderId+@COST+@IND+@COND_IND)
	BEGIN
  insert into  KPI_GENERATOR values(@pWorkOrderHistoryId,@pWorkOrderId,@COST, @IND,@COND_IND,@pWorkOrderHistoryId+@pWorkOrderId+@COST+@IND+@COND_IND)
  end

 END
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END  
GO
