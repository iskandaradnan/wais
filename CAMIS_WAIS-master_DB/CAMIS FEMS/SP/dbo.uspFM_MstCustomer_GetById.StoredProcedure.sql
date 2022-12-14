USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstCustomer_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstCustomer_GetById
Description			: To Get the data from table MstCustomer using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_MstCustomer_GetById]  @pUserId='',@pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstCustomer_GetById]                           
  @pUserId		 INT,
  @pCustomerId   INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pCustomerId,0) = 0) RETURN

    SELECT	Customer.CustomerId											AS CustomerId,			
			Customer.CustomerName										AS CustomerName,		
			Customer.CustomerCode										AS CustomerCode,		
			Customer.[Address]											AS [Address],				
			--Customer.ContactNo											AS ContactNo,			
			Customer.Latitude											AS Latitude,			
			Customer.Longitude											AS Longitude,			
			Customer.ActiveFromDate										AS ActiveFromDate,		
			Customer.ActiveFromDateUTC									AS ActiveFromDateUTC,	
			Customer.ActiveToDate										AS ActiveToDate,		
			Customer.ActiveToDateUTC									AS ActiveToDateUTC,		
			Customer.Logo												AS Logo				

	FROM	MstCustomer								AS Customer WITH(NOLOCK)
	WHERE	Customer.CustomerId = @pCustomerId 
	ORDER BY Customer.ModifiedDate ASC
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
