USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WOEngAssetPPMCheckList_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_Save
Description			: If staff already exists then update else insert.
Authors				: Balaji M S
Date				: 07-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @WOEngAssetPPMCheckListQuantasksMstDetType					as	[dbo].[udt_WOEngAssetPPMCheckListQuantasksMstDet]
DECLARE @WOEngAssetPPMCheckListCategory								as	[dbo].[udt_WOEngAssetPPMCheckListCategory]
Insert into @WOEngAssetPPMCheckListQuantasksMstDetType([WOPPMCheckListQNId],[PPMCheckListQNId],[Value],[Status],[Remarks],[UserId])VALUES
(0,33,'AA',1,'AAA',1),
(0,34,'BB',2,'BBB',1)
INSERT INTO @WOEngAssetPPMCheckListCategory([WOCategoryId],[CategoryId],[Status],[Remarks],[UserId])VALUES
(0,43,1,'ddd',1),
(0,44,1,'ddd',1)

EXEC [uspFM_WOEngAssetPPMCheckList_Save] @PWOPPMCheckListId=0,@pPPMCheckListId=64,@pWorkOrderId=25,@pUserId=2,
@WOEngAssetPPMCheckListQuantasksMstDetType=@WOEngAssetPPMCheckListQuantasksMstDetType,@WOEngAssetPPMCheckListCategory=@WOEngAssetPPMCheckListCategory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/




CREATE PROCEDURE  [dbo].[uspFM_WOEngAssetPPMCheckList_Save]


  @PWOPPMCheckListId	INT		= NULL,
  @pPPMCheckListId		INT		= NULL,
  @pWorkOrderId			INT		= NULL,
  @pUserId				INT		= NULL,
  @WOEngAssetPPMCheckListQuantasksMstDetType		AS	[dbo].[udt_WOEngAssetPPMCheckListQuantasksMstDet] READONLY,
  @WOEngAssetPPMCheckListCategory					AS  [dbo].[udt_WOEngAssetPPMCheckListCategory] READONLY
    
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @mAssetTypeCode VARCHAR(100)
	DECLARE @PPMCheckListQuantasksCount int
	DECLARE @PPMCheckListCategoryCount int
	DECLARE @mWOPPMCheckListId int
-- Default Values
	

-- Execution
 
 --------------------------------------------UPDATE STATEMENT-------------------------------------
 --//1.EngAssetPPMCheckList



      if(isnull(@PWOPPMCheckListId,0) = 0)
	  begin

						INSERT INTO [EngAssetPPMCheckListWorkOrder]
						(	
							PPMCheckListId,
							WorkOrderId,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC			
						)	OUTPUT INSERTED.WOPPMCheckListId INTO @Table		
		   VALUES      (
						 @pPPMCheckListId,
						 @pWorkOrderId,
						 @pUserId,
						 GETDATE(),
						 GETDATE(),
						 @pUserId,
						 GETDATE(),
						 GETDATE()
								
						)
		 set @mWOPPMCheckListId  = (SELECT	WOPPMCheckListId	FROM	[EngAssetPPMCheckListWorkOrder] WHERE	WOPPMCheckListId IN (SELECT ID FROM @Table))



		 INSERT INTO [EngAssetPPMCheckListQuantasksWorkOrderMstDet]
						(	
							WOPPMCheckListId,
							PPMCheckListQNId,
							Value,
							Status,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC	
						)							
			SELECT  
								
							@mWOPPMCheckListId,
							PPMCheckListQNId,	
							Value,	
							Status,
							Remarks,			
							UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							UserId,								
							GETDATE(),		
							GETUTCDATE()		
			FROM	@WOEngAssetPPMCheckListQuantasksMstDetType
			WHERE   ISNULL(WOPPMCheckListQNId,0)=0 

			
			INSERT INTO [EngAssetPPMCheckListCategoryWorkOrder]
						(	

							WOPPMCheckListId,
							CategoryId,
							Status,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC

						)							
			SELECT  
								
							@mWOPPMCheckListId,
							CategoryId,
							Status,
							Remarks,		
							UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							UserId,								
							GETDATE(),		
							GETUTCDATE()
			FROM	@WOEngAssetPPMCheckListCategory
			WHERE   ISNULL(WOCategoryId,0)=0 



		    SELECT				  WOPPMCheckListId,	PPMCheckListId,
									WorkOrderId,
									TimeStamp,						
									'' ErrorMessage
			FROM					[EngAssetPPMCheckListWorkOrder]
			WHERE				WOPPMCheckListId IN (SELECT ID FROM @Table)
		END


	  ELSE 
		BEGIN


			




				  UPDATE  WOPPMCheckListQuanTask	SET			
									WOPPMCheckListQuanTask.Value					=   WOPPMCheckListQuanTaskudt.Value,
									WOPPMCheckListQuanTask.Status					=   WOPPMCheckListQuanTaskudt.Status,
									WOPPMCheckListQuanTask.Remarks					=   WOPPMCheckListQuanTaskudt.Remarks,
									WOPPMCheckListQuanTask.ModifiedBy				=	WOPPMCheckListQuanTaskudt.UserId,				
									WOPPMCheckListQuanTask.ModifiedDate				=	GETDATE(),		
									WOPPMCheckListQuanTask.ModifiedDateUTC			=	GETUTCDATE()
						OUTPUT INSERTED.WOPPMCheckListId INTO @Table
	          	FROM	[EngAssetPPMCheckListQuantasksWorkOrderMstDet]					AS WOPPMCheckListQuanTask 
				INNER JOIN @WOEngAssetPPMCheckListQuantasksMstDetType					AS WOPPMCheckListQuanTaskudt on WOPPMCheckListQuanTask.WOPPMCheckListQNId=WOPPMCheckListQuanTaskudt.WOPPMCheckListQNId
	         	WHERE	ISNULL(WOPPMCheckListQuanTaskudt.WOPPMCheckListQNId,0)>0

			

				  UPDATE  WOPPMCheckListCategory	SET		
					
					WOPPMCheckListCategory.Status					=   WOPPMCheckListCategoryudt.Status,
					WOPPMCheckListCategory.Remarks					=   WOPPMCheckListCategoryudt.Remarks,
					WOPPMCheckListCategory.ModifiedBy				=	WOPPMCheckListCategoryudt.UserId,				
					WOPPMCheckListCategory.ModifiedDate				=	GETDATE(),		
					WOPPMCheckListCategory.ModifiedDateUTC			=	GETUTCDATE()
					OUTPUT INSERTED.WOPPMCheckListId INTO @Table
	          	FROM	[EngAssetPPMCheckListCategoryWorkOrder]			AS WOPPMCheckListCategory 
				INNER JOIN @WOEngAssetPPMCheckListCategory				AS WOPPMCheckListCategoryudt on WOPPMCheckListCategory.WOCategoryId=WOPPMCheckListCategoryudt.WOCategoryId
	         	WHERE	ISNULL(WOPPMCheckListCategoryudt.WOCategoryId,0)>0 

		    SELECT				  WOPPMCheckListId,	PPMCheckListId,
									WorkOrderId,
									TimeStamp,						
									'' ErrorMessage
			FROM					[EngAssetPPMCheckListWorkOrder]
			WHERE				WOPPMCheckListId IN (SELECT ID FROM @Table)
			
			
			INSERT INTO [EngAssetPPMCheckListQuantasksWorkOrderMstDet]
						(	
							WOPPMCheckListId,
							PPMCheckListQNId,
							Value,
							Status,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC	
						)							
			SELECT  
								
							@mWOPPMCheckListId,
							PPMCheckListQNId,
							Value,		
							Status,
							Remarks,			
							UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							UserId							,			
							GETDATE(),		
							GETUTCDATE()		
			FROM	@WOEngAssetPPMCheckListQuantasksMstDetType
			WHERE   ISNULL(WOPPMCheckListQNId,0)=0 

			
			INSERT INTO [EngAssetPPMCheckListCategoryWorkOrder]
						(	

							WOPPMCheckListId,
							CategoryId,
							Status,
							Remarks,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC

						)							
			SELECT  
								
							@mWOPPMCheckListId,
							CategoryId,
							Status,
							Remarks,		
							UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							UserId,									
							GETDATE(),		
							GETUTCDATE()
			FROM	@WOEngAssetPPMCheckListCategory
			WHERE   ISNULL(WOCategoryId,0)=0 

	  end 

---------------------------------------------------------------------END OF INSERT --------------------------------------------------------------------------------------
	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

throw;
	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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




------------------------------------------------------------------------------------------------------------------------------------------------


--DROP TYPE [udt_WOEngAssetPPMCheckListCategory]
--DROP TYPE [udt_WOEngAssetPPMCheckListQuantasksMstDet]
--DROP PROC [uspFM_WOEngAssetPPMCheckList_Save]

--CREATE TYPE [dbo].[udt_WOEngAssetPPMCheckListCategory] AS TABLE(
--	[WOCategoryId] [int] NULL,
--	[CategoryId] [int] NULL,
--	[Status] [int] NULL,
--	[Remarks] [nvarchar](1000) NULL,
--	[UserId] [int] NULL
--)
--GO

--CREATE TYPE [dbo].[udt_WOEngAssetPPMCheckListQuantasksMstDet] AS TABLE(
--	[WOPPMCheckListQNId] [int] NULL,
--	[PPMCheckListQNId] [int] NULL,
--	[Value] [nvarchar](1000) NULL,
--	[Status] [int] NULL,
--	[Remarks] [nvarchar](1000) NULL,
--	[UserId] [int] NULL
--)
--GO
GO
