USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetClassification_Get]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: UspFM_CustomerMst_Get
Author(s) Name(s)	: Praveen N
Date				: 27-02-2017
Purpose				: SP to Get Customer details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
  
EXEC Asis_EodParameterAnalysisRpt_L1 @MenuName = '' , @Level='national',@Option='85',@service=1, @Frequency='yearly',@Frequency_Key='',@Year='2017',@From_Date='',@To_Date='' 


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
Request Type: 973,974,975,976,977,978,979,980,983 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          
	          

CREATE PROCEDURE  [dbo].[UspBEMS_EngAssetClassification_Get]                           
( 
		@Id			        INT 
		  
)           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-------------------------------------------------------------------------------------
--Declare Variables  
-------------------------------------------------------------------------------------
--DECLARE @Error_Code             INT

---------------------------------------------------------------------------------------
----Initialize Variables  
---------------------------------------------------------------------------------------
--SET @Error_Code = 0
--SET @IsUpdatedSuccessfullyParameter = 1

BEGIN TRY      
    SELECT 
	   AssetClassificationId
      ,ServiceId
      ,AssetClassificationCode
      ,AssetClassificationDescription
      ,Remarks    
      ,[Timestamp]
      ,Active
   
   FROM EngAssetClassification A 
   WHERE A.AssetClassificationId=@Id
         
END TRY
BEGIN CATCH


 ----------------------------------
---- SET Output Status and Message
-----------------------------------
--SET @Error_Code = @@ERROR

--IF @Error_Code <> 0 
--		BEGIN
--			SET @DB_ERROR = 'Procedure:' + 'UspFM_CustomerMst_Ge' +'- Error Code: '+ @Error_Code+' - '+ ERROR_MESSAGE();
--			SET @IsUpdatedSuccessfullyParameter = 0
--		END


insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH
SET NOCOUNT OFF
END
GO
