USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetAssetLocationInchageMail_Get]    Script Date: 20-09-2021 16:56:53 ******/
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
  
EXEC UspFM_CustomerMst_Get @CustomerId=1


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
Request Type: 973,974,975,976,977,978,979,980,983 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
Modified from Asis_EodParameterRpt_L1 to Asis_EodParameterExceptionRpt_L1  By Gosalai
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          
	          

CREATE PROCEDURE  [dbo].[uspFM_GetAssetLocationInchageMail_Get]                           
( 
		@pPorteringId			        INT ,
		@pStatus                        INT
		--@IsUpdatedSuccessfullyParameter bit OUTPUT, 
  --      @DB_ERROR varchar(MAX) OUTPUT
		  
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
    -- REQUEST
	IF(@pStatus = 1)
	BEGIN
	 select c.Email, a.PorteringNo, requestir.Email RequestorEmail, PorteringId,a.PorteringDate, d.AssetNo from 
	  PorteringTransaction A 
	  inner join MstLocationUserLocation b on a.FromUserLocationId = b.UserLocationId
	  inner join EngAsset           d on a.AssetId = d.AssetId
	  inner join UMUserRegistration c on b.AuthorizedUserId= c.UserRegistrationId 
	  inner join UMUserRegistration requestir on requestir.UserRegistrationId= A.RequestorId 
	  where a.PorteringId=@pPorteringId






	 END

	-- APPROVAL

	IF(@pStatus = 2 )
	BEGIN

	        
	         SELECT A.PorteringId, PorteringDate,b.Email RequestorEmail, A.RequestorId, B.StaffName as StaffName, C.AssetNo, WFStatusApprovedDate, f.Email FROM 
			 PorteringTransaction A 
			 INNER JOIN UMUserRegistration B ON A.RequestorId = B.UserRegistrationId
			 INNER JOIN EngAsset C ON A.AssetId=C.AssetId
			 inner join MstLocationUserLocation e on a.FromUserLocationId = e.UserLocationId
			 inner join UMUserRegistration f on e.AuthorizedUserId= f.UserRegistrationId 
			 WHERE A.PorteringId= @pPorteringId
	END
         
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
