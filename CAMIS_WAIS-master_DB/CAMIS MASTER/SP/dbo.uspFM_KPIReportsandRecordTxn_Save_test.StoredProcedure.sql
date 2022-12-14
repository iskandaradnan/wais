USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KPIReportsandRecordTxn_Save_test]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



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

DECLARE 		@pKPIReportsandRecordTxn			[dbo].[udt_KPIReportsandRecordTxnDet]
DECLARE 		@pErrorMessage						NVARCHAR(500)
 INSERT INTO @pKPIReportsandRecordTxn([ReportsandRecordTxnDetId],[CustomerReportId],[Submitted],[Verified],[ReportName],[Remarks],[UserId],[IsDeleted]) VALUES
 (0,38,0,0,null,'',1,0),
 (0,null,0,0,'AAA','',1,0),
 (0,null,0,0,'BBB','',1,0)
EXEC [uspFM_KPIReportsandRecordTxn_Save] @pKPIReportsandRecordTxn,@pReportsandRecordTxnId=0,@pFacilityId=1,@pCustomerId=1,@pMonth=2,@pYear=2018,@pUserId=1,
@pErrorMessage = @pErrorMessage output
SELECT @pErrorMessage
SELECT * FROM FMAddFieldConfig
ROLLBACK
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_KPIReportsandRecordTxn_Save_test]
		@pKPIReportsandRecordTxn			[dbo].[udt_KPIReportsandRecordTxnDet]	READONLY,
		@pReportsandRecordTxnId		INT,
		@pFacilityId				INT,
		@pCustomerId				INT,
		@pMonth						INT,
		@pYear						INT,
		@pUserId					INT,
		@pSubmitted					BIT,
		@PVerified					BIT,
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
	DECLARE @ReportTable TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT
	DECLARE @DuplicateCount  INT
	DECLARE @DuplicateTableCount  INT
	DECLARE @ReportsandRecordTxnId  INT
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

	



	DELETE FROM [KPIReportsandRecordTxnDet] WHERE ReportsandRecordTxnDetId IN (SELECT ReportsandRecordTxnDetId FROM @pKPIReportsandRecordTxn WHERE Isdeleted =1)

	SET @DuplicateCount = (SELECT TOP 1 COUNT(*) FROM @pKPIReportsandRecordTxn GROUP BY ReportName,Isdeleted HAVING COUNT(*)>1 AND Isdeleted =0)

	SET @DuplicateTableCount = (SELECT TOP 1  1 FROM @pKPIReportsandRecordTxn A INNER JOIN MstCustomerReport B ON A.ReportName = B.ReportName WHERE A.Isdeleted =0 AND A.CustomerReportId =0)

	SET @ReportsandRecordTxnId = (SELECT TOP  1 ReportsandRecordTxnId FROM [KPIReportsandRecordTxn] WHERE Month = @pMonth AND Year = @pYear AND FacilityId = @pFacilityId AND CustomerId = @pCustomerId)

	IF(@DuplicateCount>1)
	BEGIN

				SET @pErrorMessage =	'Report Name Should be Unique' 
	END

	ELSE IF(@DuplicateTableCount = 1)
	BEGIN

				SET @pErrorMessage =	'Report Name Should be Unique' 
	END

	--ELSE IF(@ReportsandRecordTxnId > 0 and @pReportsandRecordTxnId=0)
	--BEGIN

	--			SET @pErrorMessage =	'Month and Year Should be Unique' 
	--END

	ELSE
	BEGIN

	IF  (@pReportsandRecordTxnId = NULL OR @pReportsandRecordTxnId =0)

BEGIN
			INSERT INTO KPIReportsandRecordTxn
						(	
							FacilityId,
							CustomerId,
							Month,
							Year,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							Submitted,
							Verified

						)	OUTPUT INSERTED.ReportsandRecordTxnId INTO @Table							

						
				VALUES				
						
						(   @pFacilityId,
							@pCustomerId,
							@pMonth,
							@pYear,
							@pUserId,			
							GETDATE(), 
							GETUTCDATE(),
							@pUserId, 
							GETDATE(), 
							GETUTCDATE(),
							@pSubmitted,
							@pVerified
						)
	
	SET @PrimaryKeyId = (SELECT top 1 ID FROM @Table)


			

			INSERT INTO KPIReportsandRecordTxnDet
						(	
							ReportsandRecordTxnId,
							CustomerReportId,
							Submitted,
							Verified,
							ReportName,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)						

						
								
			SELECT			
							@PrimaryKeyId,
							nullif(CustomerReportId,0) as CustomerReportId,
							Submitted,
							Verified,
							ReportName,
							Remarks,
							UserId,			
							GETDATE(), 
							GETUTCDATE(),
							UserId, 
							GETDATE(), 
							GETUTCDATE()
			FROM 	@pKPIReportsandRecordTxn 
			where ISNULL(ReportsandRecordTxnDetId,0)=0 AND Isdeleted =0

		
			
				
			SELECT	ReportsandRecordDet.ReportsandRecordTxnDetId			AS ReportsandRecordTxnDetId,
			ReportsandRecordDet.ReportsandRecordTxnId				AS ReportsandRecordTxnId,
			nullif(ReportsandRecordDet.CustomerReportId,0)								AS CustomerReportId,
			ReportsandRecordDet.ReportName								AS ReportName,
			ReportsandRecordDet.Submitted							AS Submitted,
			ReportsandRecordDet.Verified							AS Verified,
			ReportsandRecordDet.Remarks								AS Remarks,
			ReportsandRecord.Submitted								AS RecordSubmitted,
			ReportsandRecord.Verified								AS RecordVerified,
			CASE WHEN ISNULL(ReportsandRecord.Submitted,0)=0 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ReportsandRecord.Verified =1 THEN 'Verified' ELSE '' END END END AS Status
	FROM	KPIReportsandRecordTxn									AS ReportsandRecord			WITH(NOLOCK)
			INNER JOIN  KPIReportsandRecordTxnDet					AS ReportsandRecordDet		WITH(NOLOCK)	ON ReportsandRecord.ReportsandRecordTxnId		= ReportsandRecordDet.ReportsandRecordTxnId
			LEFT JOIN  MstCustomerReport							AS CustomerReport			WITH(NOLOCK)	ON ReportsandRecordDet.CustomerReportId			= CustomerReport.CustomerReportId
	WHERE	ReportsandRecord.ReportsandRecordTxnId  IN (SELECT ID  FROM @Table)


		     

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.FMLovMst UPDATE

BEGIN


		DELETE FROM [KPIReportsandRecordTxnDet] WHERE ReportsandRecordTxnDetId IN (SELECT ReportsandRecordTxnDetId FROM @pKPIReportsandRecordTxn WHERE Isdeleted =1)

				UPDATE [KPIReportsandRecordTxn] SET
				
				Month								= @pMonth,
				Year								= @pYear,
				Submitted							=@pSubmitted,
				Verified							=@PVerified
				WHERE 	ReportsandRecordTxnId = @pReportsandRecordTxnId



	    UPDATE  Report	SET		--Report.CustomerReportId						= udtReport.CustomerReportId,
								Report.Submitted							= udtReport.Submitted,
								Report.Verified								= udtReport.Verified,
								Report.ReportName							= udtReport.ReportName,
								Report.Remarks								= udtReport.Remarks,
								Report.ModifiedBy							= udtReport.UserId,
								Report.ModifiedDate							= GETDATE(),
								Report.ModifiedDateUTC						= GETUTCDATE()
									OUTPUT INSERTED.ReportsandRecordTxnId INTO @Table
				FROM	   [KPIReportsandRecordTxnDet]					AS Report
				INNER JOIN @pKPIReportsandRecordTxn						AS udtReport on Report.ReportsandRecordTxnDetId		= udtReport.ReportsandRecordTxnDetId
				WHERE ISNULL(udtReport.ReportsandRecordTxnDetId,0)>0 AND udtReport.ISDELETED=0


				INSERT INTO KPIReportsandRecordTxnDet
						(	
							ReportsandRecordTxnId,
							CustomerReportId,
							Submitted,
							Verified,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)						

						
								
			SELECT			
							@pReportsandRecordTxnId,
							nullif(CustomerReportId,0)  as CustomerReportId,
							Submitted,
							Verified,
							Remarks,
							UserId,			
							GETDATE(), 
							GETUTCDATE(),
							UserId, 
							GETDATE(), 
							GETUTCDATE()
			FROM 	@pKPIReportsandRecordTxn 
			where ISNULL(ReportsandRecordTxnDetId,0)=0 AND Isdeleted =0
		  
			SELECT	ReportsandRecordDet.ReportsandRecordTxnDetId			AS ReportsandRecordTxnDetId,
			ReportsandRecordDet.ReportsandRecordTxnId				AS ReportsandRecordTxnId,
			nullif(ReportsandRecordDet.CustomerReportId,0) 	AS CustomerReportId,
			ReportsandRecordDet.ReportName								AS ReportName,
			ReportsandRecordDet.Submitted							AS Submitted,
			ReportsandRecordDet.Verified							AS Verified,
			ReportsandRecordDet.Remarks								AS Remarks,
			ReportsandRecord.Submitted								AS RecordSubmitted,
			ReportsandRecord.Verified								AS RecordVerified,
			CASE WHEN ISNULL(ReportsandRecord.Submitted,0)=0 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN '' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ISNULL(ReportsandRecord.Verified,0)=0 THEN 'Submitted' ELSE
			CASE WHEN ReportsandRecord.Submitted =1 AND ReportsandRecord.Verified =1 THEN 'Verified' ELSE '' END END END AS Status
	FROM	KPIReportsandRecordTxn									AS ReportsandRecord			WITH(NOLOCK)
			INNER JOIN  KPIReportsandRecordTxnDet					AS ReportsandRecordDet		WITH(NOLOCK)	ON ReportsandRecord.ReportsandRecordTxnId		= ReportsandRecordDet.ReportsandRecordTxnId
			LEFT JOIN  MstCustomerReport							AS CustomerReport			WITH(NOLOCK)	ON ReportsandRecordDet.CustomerReportId			= CustomerReport.CustomerReportId
	WHERE	ReportsandRecord.ReportsandRecordTxnId  IN (SELECT ID  FROM @Table)


END

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT
 --       END
		END
END TRY

BEGIN CATCH
THROW;
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

--drop proc [uspFM_KPIReportsandRecordTxn_Save]
--drop type [udt_KPIReportsandRecordTxnDet]

--CREATE TYPE [dbo].[udt_KPIReportsandRecordTxnDet] AS TABLE(
--	[ReportsandRecordTxnDetId]		[int]  NULL,
--	[CustomerReportId]				[INT] NULL,
--	[Submitted]						[bit] NULL,
--	[Verified]						[bit] NULL,
--	[ReportName]					[NVARCHAR](200) NULL,
--	[Remarks]						[NVARCHAR](500) NULL,
--	[UserId]						[int] NOT NULL,
--	[IsDeleted]						[bit] NULL
--)
GO
