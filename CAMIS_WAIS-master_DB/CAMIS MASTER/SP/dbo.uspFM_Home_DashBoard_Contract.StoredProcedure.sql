USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Home_DashBoard_Contract]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Home_DashBoard_Contract
Description			: Get the Home DashBoard Contract
Authors				: Balaji M S
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_Home_DashBoard_Contract  @pFacilityId=1,@pStartDateMonth=5,@pEndDateMonth=5,@pStartDateYear=2018,@pEndDateYear=2018
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Home_DashBoard_Contract]    
		@pFacilityId			INT,
		@pStartDateMonth		INT   =	NULL,
		@pEndDateMonth			INT	  =	NULL,
		@pStartDateYear			INT	  =	NULL,
		@pEndDateYear			INT	  =	NULL

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

		--SET @pStartDateMonth = MONTH(GETDATE())
		--SET @pEndDateMonth	 = MONTH(GETDATE())
		--SET @pStartDateYear	 = YEAR(GETDATE())
		--SET @pEndDateYear	 = YEAR(GETDATE())

-- Execution
	

	IF OBJECT_ID('#TempTableContractCount') IS NOT NULL
	DROP TABLE #TempTableContractCount


	CREATE TABLE #TempTableContractCount (ID INT , CONTRACTSTATUS NVARCHAR(100) ,COUNTVALUE INT DEFAULT 0)

	INSERT INTO #TempTableContractCount(ID,CONTRACTSTATUS,COUNTVALUE) VALUES

	(1,'Renewed',0),
	(2,'Awaiting Renewal',0)
	

--Awaiting Renewal
	UPDATE #TempTableContractCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngContractOutRegister A 
	 	WHERE DATEDIFF(DAY,ContractStartDate,ContractEndDate) <30  AND A.FacilityId = @pFacilityId),0) WHERE ID=2 

--Renewed
		UPDATE #TempTableContractCount SET COUNTVALUE= ISNULL((SELECT COUNT(*) FROM EngContractOutRegister A 
	 	WHERE DATEDIFF(DAY,ContractStartDate,ContractEndDate) >30  AND A.FacilityId = @pFacilityId),0) WHERE ID=1

	SELECT * FROM #TempTableContractCount 


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
