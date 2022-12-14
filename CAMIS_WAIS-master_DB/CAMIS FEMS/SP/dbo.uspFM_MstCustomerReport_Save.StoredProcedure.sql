USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstCustomerReport_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMAddFieldConfig_Save
Description			: Insert/update the Attachment
Authors				: Dhilip V
Date				: 10-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE 		@pMstCustomerReport			[dbo].[udt_MstCustomerReport]
 INSERT INTO @pMstCustomerReport(CustomerReportId,	CustomerId,ReportName,UserId,IsDeleted) VALUES
 (0,1,'aaa',1,0),
 (0,1,'bbb',1,0),
 (0,1,'ccc',1,1)
EXEC [uspFM_MstCustomerReport_Save] @pMstCustomerReport

SELECT * FROM FMAddFieldConfig
ROLLBACK
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_MstCustomerReport_Save]
		@pMstCustomerReport			[dbo].[udt_MstCustomerReport]	READONLY,
		@pErrorMessage nvarchar(500) OUTPUT
AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT
	DECLARE @DuplicateCount  INT
	DECLARE @DuplicateTableCount  INT
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------
	DELETE FROM MstCustomerReport WHERE CustomerReportId IN (SELECT CustomerReportId FROM @pMstCustomerReport WHERE Isdeleted =1)
	SET @DuplicateCount = (SELECT TOP 1 COUNT(*) FROM @pMstCustomerReport GROUP BY ReportName,CustomerId,Isdeleted HAVING COUNT(*)>1 AND Isdeleted =0)
	SET @DuplicateTableCount = (SELECT 1 FROM @pMstCustomerReport A INNER JOIN MstCustomerReport B ON A.CustomerReportId = B.CustomerReportId WHERE A.Isdeleted =0 AND A.CustomerReportId =0)

	IF(@DuplicateCount>1)
	BEGIN

				SET @pErrorMessage =	'Report Name Should be Unique' 
	END

	ELSE IF(@DuplicateTableCount = 1)
	BEGIN

				SET @pErrorMessage =	'Report Name Should be Unique' 
	END

	ELSE
	BEGIN

	IF EXISTS (SELECT 1 FROM @pMstCustomerReport WHERE CustomerReportId = NULL OR CustomerReportId =0)

BEGIN
			INSERT INTO MstCustomerReport
						(	
							CustomerId,
							ReportName,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.CustomerReportId INTO @Table							

						
								
			SELECT			CustomerId,
							ReportName,
							UserId,			
							GETDATE(), 
							GETUTCDATE(),
							UserId, 
							GETDATE(), 
							GETUTCDATE()
			FROM 	@pMstCustomerReport 
			where ISNULL(CustomerReportId,0)=0 AND Isdeleted =0
					
			SELECT	CustomerReportId,ReportName,
					[Timestamp],
					'' AS ErrorMessage
			FROM	MstCustomerReport
			WHERE	CustomerId IN (SELECT top 1 CustomerId  FROM @pMstCustomerReport)


		     

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.FMLovMst UPDATE

			

BEGIN

		DELETE FROM MstCustomerReport WHERE CustomerReportId IN (SELECT CustomerReportId FROM @pMstCustomerReport WHERE Isdeleted =1)


	    UPDATE  Report	SET		Report.ReportName							= udtReport.ReportName,
								Report.ModifiedBy							= udtReport.UserId,
								Report.ModifiedDate							= GETDATE(),
								Report.ModifiedDateUTC						= GETUTCDATE()
									OUTPUT INSERTED.CustomerReportId INTO @Table
				FROM	   MstCustomerReport							AS Report
				INNER JOIN @pMstCustomerReport							AS udtReport on Report.CustomerReportId		= udtReport.CustomerReportId
				WHERE ISNULL(udtReport.CustomerReportId,0)>0 AND udtReport.ISDELETED=0
		  
			SELECT	CustomerReportId,ReportName,
					[Timestamp],
					'' AS ErrorMessage
			FROM	MstCustomerReport
			WHERE	CustomerId IN (SELECT top 1 CustomerId  FROM @pMstCustomerReport)


END

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT
 --       END
		END
END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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



-----------------------------------------------------------------------------UDT Creation --------------------------------------------------------------

--drop proc [uspFM_MstCustomerReport_Save]
--drop type udt_MstCustomerReport

--CREATE TYPE [dbo].[udt_MstCustomerReport] AS TABLE(
--	[CustomerReportId] [int] NOT NULL,
--	[CustomerId] [int]  NULL,
--	[ReportName] [nvarchar](500)  NULL,
--	[UserId] [int] NOT NULL,
--	[IsDeleted] [bit] NULL
--)
GO
