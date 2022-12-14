USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Call_Indicators]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[Call_Indicators]  
(  
@PurchaseCostRM As int,  
 @kpi_ind_Id As int  
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
   IF OBJECT_ID('tempdb..#Call_IndicatorsT') IS NOT NULL              
DROP TABLE #Call_IndicatorsT 
 select KPI_PER_ID as KPI_ID,KPI_DEDUCTION_VALUE as cost  from Kpi_Per_Deduction_IND where @PurchaseCostRM between KPI_BEPC_COST_FROM and KPI_BEPC_COST_TO  and KPI_IND_ID=@kpi_ind_Id    
  
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END  
GO
