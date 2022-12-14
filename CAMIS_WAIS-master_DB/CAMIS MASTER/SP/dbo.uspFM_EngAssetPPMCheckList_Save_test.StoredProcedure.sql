USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_Save_test]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_Save
Description			: If staff already exists then update else insert.
Authors				: Balaji M S
Date				: 07-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @EngAssetPPMCheckListType									as	[dbo].[udt_EngAssetPPMCheckList]
DECLARE @EngAssetPPMCheckListMaintTasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet]
DECLARE @EngAssetPPMCheckListQualTasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListQualTasksMstDet]
DECLARE @EngAssetPPMCheckListQuantasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListQuantasksMstDet]
DECLARE @EngAssetPPMCheckListStatusHistoryMstType					as	[dbo].[udt_EngAssetPPMCheckListStatusHistoryMst]
INSERT INTO @EngAssetPPMCheckListType (PPMCheckListId,PPMRegisterId,ServiceId,AssetTypeCodeId,StandardTaskDetId,PPMChecklistNo,ManufacturerId,ModelId,PPMFrequency,PpmHours,SpecialPrecautions,DoneBy,Remarks,[Description],CreatedBy,ModifiedBy)VALUES 
(3,1,2,4,1,'45646565',2,1,52,45,'1324235346',25,'4654','jkhhfff',2,2) 
 EXECUTE [uspFM_EngAssetPPMCheckList_Save] @EngAssetPPMCheckListType,@EngAssetPPMCheckListMaintTasksMstDetType,@EngAssetPPMCheckListQualTasksMstDetType,@EngAssetPPMCheckListQuantasksMstDetType,
@EngAssetPPMCheckListStatusHistoryMstType 
INSERT INTO @EngAssetPPMCheckListType (PPMCheckListQTId,PPMCheckListId,QualitativeTasks,CreatedBy,ModifiedBy)VALUES  
(4,3,'BBBB',2,2)
INSERT INTO @EngAssetPPMCheckListQualTasksMstDetType (PPMCheckListQualTasksId,PPMCheckListId,QualTasks,CreatedBy,ModifiedBy)VALUES  
(4,3,'BBBB',2,2)
INSERT INTO @EngAssetPPMCheckListQuantasksMstDetType(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,CreatedBy,ModifiedBy)VALUES  
(4,3,'BBBB','465411','ihdiuf','uihiuhgf',2,2)
INSERT INTO @EngAssetPPMCheckListStatusHistoryMstType(PPMCheckListStatusHistoryId,PPMCheckListId,DoneBy,Date,Status,CreatedBy,ModifiedBy)VALUES  
(4,3,24,'2018-04-07 19:33:06.140',54,2,2)


DECLARE @EngAssetPPMCheckListType									as	[dbo].[udt_EngAssetPPMCheckList]
DECLARE @EngAssetPPMCheckListMaintTasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet]
DECLARE @EngAssetPPMCheckListQualTasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListQualTasksMstDet]
DECLARE @EngAssetPPMCheckListQuantasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListQuantasksMstDet]
DECLARE @EngAssetPPMCheckListStatusHistoryMstType					as	[dbo].[udt_EngAssetPPMCheckListStatusHistoryMst]
INSERT INTO @EngAssetPPMCheckListType (PPMRegisterId,ServiceId,AssetTypeCodeId,StandardTaskDetId,PPMChecklistNo,ManufacturerId,ModelId,PPMFrequency,PpmHours,SpecialPrecautions,DoneBy,Remarks,[Description],CreatedBy,ModifiedBy)VALUES 
(1,2,4,1,'45646565',2,1,52,45,'AAA',25,'4654','jkhhfff',2,2)
INSERT INTO @EngAssetPPMCheckListMaintTasksMstDetType (PPMCheckListId,QualitativeTasks,CreatedBy,ModifiedBy)VALUES  
(3,'BBBB',2,2)
INSERT INTO @EngAssetPPMCheckListQualTasksMstDetType (PPMCheckListId,QualTasks,CreatedBy,ModifiedBy)VALUES  
(3,'BBBB',2,2)
INSERT INTO @EngAssetPPMCheckListQuantasksMstDetType(PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,CreatedBy,ModifiedBy)VALUES  
(3,'BBBB','465411','ihdiuf','uihiuhgf',2,2)
INSERT INTO @EngAssetPPMCheckListStatusHistoryMstType(PPMCheckListId,DoneBy,Date,Status,CreatedBy,ModifiedBy)VALUES  
(3,24,'2018-04-07 19:33:06.140',54,2,2)
EXECUTE [uspFM_EngAssetPPMCheckList_Save] @EngAssetPPMCheckListType,@EngAssetPPMCheckListMaintTasksMstDetType,@EngAssetPPMCheckListQualTasksMstDetType,@EngAssetPPMCheckListQuantasksMstDetType,
@EngAssetPPMCheckListStatusHistoryMstType 
select * from EngAssetPPMCheckList


DECLARE @EngAssetPPMCheckListQuantasksMstDetType					as	[dbo].[udt_EngAssetPPMCheckListQuantasksMstDet]
DECLARE @EngAssetPPMCheckListCategory								as	[dbo].[udt_EngAssetPPMCheckListCategory]
Insert into @EngAssetPPMCheckListQuantasksMstDetType(PPMCheckListQNId,QuantitativeTasks,UOM,SetValues,LimitTolerance,Active)VALUES
(36,'AAAA','AAA','AAAA','AAA',1),
(0,'AAAAA','AAA','AAAA','AAA',1)
INSERT INTO @EngAssetPPMCheckListCategory(CategoryId,PPMCheckListCategoryId,Number,Description,IsWorkOrder,Active)VALUES
(46,1,12,'ddd',0,1),
(0,1,12,'ddds',0,1)

EXEC uspFM_EngAssetPPMCheckList_Save @PPMCheckListId=66,@AssetTypeCodeId=1,@ServiceId=2,@PPMChecklistNo='aaa',@ManufacturerId=1,@ModelId=1,@PPMFrequency=1,@PpmHours=20,
@SpecialPrecautions='aAA',@Remarks='AAAA',@UserId=2,@TaskCode='AAA',@TaskCodeDesc='AAAA',@EngAssetPPMCheckListQuantasksMstDetType=@EngAssetPPMCheckListQuantasksMstDetType,@EngAssetPPMCheckListCategory=@EngAssetPPMCheckListCategory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/




CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_Save_test]


  @PPMCheckListId		INT= NULL,  
  @AssetTypeCodeId		INT= NULL, 
  @ServiceId			INT= NULL, 
  @PPMChecklistNo		NVARCHAR(200)= NULL,
  @ManufacturerId		INT= NULL, 
  @ModelId				INT= NULL, 
  @PPMFrequency			INT= NULL,  
  @PpmHours				numeric(24, 2)= NULL,
  @SpecialPrecautions	NVARCHAR(1000)=NULL,
  @Remarks				NVARCHAR(500)=NULL,
  --@Description			NVARCHAR(500),

  @UserId				INT=NULL,
  @TaskCode             nvarchar(200)=null,
  @TaskCodeDesc         nvarchar(1000)= null, 
  @EngAssetPPMCheckListQuantasksMstDetType		AS	[dbo].[udt_EngAssetPPMCheckListQuantasksMstDet] READONLY,
  @EngAssetPPMCheckListCategory					AS  [dbo].[udt_EngAssetPPMCheckListCategory] READONLY



 
	-- @EngAssetPPMCheckListType						AS	[dbo].[udt_EngAssetPPMCheckList]   READONLY ,
	
	
	 
	
	-- @EngAssetPPMCheckListStatusHistoryMstType		AS	[dbo].[udt_EngAssetPPMCheckListStatusHistoryMst] READONLY             
    
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
	DECLARE @mPPMCheckListId int
-- Default Values
	
	SELECT @mAssetTypeCode = AssetTypeCode FROM EngAssetTypeCode WHERE AssetTypeCodeId	=	@AssetTypeCodeId
	DECLARE @mCodeGen int =(select MAX(Right(TaskCode,6)) from EngAssetPPMCheckList where AssetTypeCodeId	=	@AssetTypeCodeId)
	DECLARE @mFinalCodeGen nvarchar(100)
	
	IF (@mCodeGen IS NULL)
	BEGIN
	SET @mFinalCodeGen ='000001'
	END
	ELSE
	BEGIN
	SET @mFinalCodeGen =right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)
	END
	
	PRINT @mFinalCodeGen
-- Execution
 
 --------------------------------------------UPDATE STATEMENT-------------------------------------
 --//1.EngAssetPPMCheckList



      if(isnull(@PPMCheckListId,0) = 0)
	  begin

	  IF NOT EXISTS (SELECT * FROM EngAssetPPMCheckList WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId	)

		BEGIN

		DECLARE @pOutParam NVARCHAR(100)
		EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngAssetPPMCheckList',@pCustomerId=NULL,@pFacilityId=NULL,@Defaultkey='UEMEd/BEMS',@pService=NULL,@pMonth=NULL,@pYear=NULL,@pOutParam=@pOutParam OUTPUT
		SELECT @PPMChecklistNo= @pOutParam 


						INSERT INTO EngAssetPPMCheckList
						(	
										
							ServiceId,			
							AssetTypeCodeId,	
							PPMChecklistNo,		
							ManufacturerId,		
							ModelId,			
							PPMFrequency,		
							PpmHours,			
							SpecialPrecautions,	
									
							Remarks,				
								
							CreatedBy,			
							CreatedDate,			
							CreatedDateUTC,		
							ModifiedBy,			
							ModifiedDate,		
							ModifiedDateUTC	,
							TaskCode,
							TaskDescription	
						)	OUTPUT INSERTED.PPMCheckListId INTO @Table		
		   VALUES      (
						 @ServiceId,
						 @AssetTypeCodeId,
						 --(SELECT 'UEMEd/BEMS/' +  ISNULL(CAST(MAX(RIGHT(PPMChecklistNo,4)) + 1 AS NVARCHAR(50)),1000) FROM EngAssetPPMCheckList where PPMChecklistNo like 'KKM/BEMS/%') ,
						 @PPMChecklistNo,
						 @ManufacturerId,
						 @ModelId,
						 @PPMFrequency,
						 @PpmHours,
						 @SpecialPrecautions,
						 @Remarks,
						 @UserId,
						 GETDATE(),
						 GETDATE(),
						 @UserId,
						 GETDATE(),
						 GETDATE(),
						 @mAssetTypeCode+'-'+@mFinalCodeGen,
						 --isnull ( substring ( @mAssetTypeCode,1,len(@mAssetTypeCode)-6) + right('000000'+ cast((select max(RIGHT(@mAssetTypeCode,6))+1 from EngAssetPPMCheckList  where AssetTypeCodeId= @AssetTypeCodeId) as nvarchar(20) ),6 ) ,
					  --        (select top 1 AssetTypeCode+'-'+'000001' FROM EngAssetTypeCode  TypeCode WHERE AssetTypeCodeId=TypeCode.AssetTypeCodeId ) )
						 @TaskCodeDesc
		)
		 set @mPPMCheckListId  = (SELECT	PPMCheckListId	FROM	EngAssetPPMCheckList WHERE	PPMCheckListId IN (SELECT ID FROM @Table))



		 INSERT INTO EngAssetPPMCheckListQuantasksMstDet
						(	
								
							PPMCheckListId,		
							QuantitativeTasks,	
							UOM,					
							SetValues,			
							LimitTolerance,		
							CreatedBy,		
							CreatedDate	,	
							CreatedDateUTC,	
							ModifiedBy,		
							ModifiedDate,	
							ModifiedDateUTC	
						)							
			SELECT  
								
							@mPPMCheckListId,		
							QuantitativeTasks,	
							UOM,				
							SetValues,			
							LimitTolerance,			
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE()		
			FROM	@EngAssetPPMCheckListQuantasksMstDetType
			WHERE   ISNULL(PPMCheckListQNId,0)=0 and Active=1

			
			INSERT INTO EngAssetPPMCheckListCategory
						(	
							PPMCheckListId,
							PPMCheckListCategoryId,
							Number,
							Description,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							Active,
							BuiltIn,
							IsWorkOrder	
						)							
			SELECT  
								
							@mPPMCheckListId,
							PPMCheckListCategoryId,
							Number,
							Description,		
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE(),
							1,
							1,
							IsWorkOrder		
			FROM	@EngAssetPPMCheckListCategory
			WHERE   ISNULL(CategoryId,0)=0 and Active=1



		    SELECT				  PPMCheckListId,							
										'' ErrorMessage
			FROM					EngAssetPPMCheckList
			WHERE				PPMCheckListId IN (SELECT ID FROM @Table)
		END

		ELSE
			BEGIN
				SELECT				 0 AS  PPMCheckListId,							
									'Asset Type Code, Model combination already exists' ErrorMessage
			END

	  END 

	  ELSE 
		BEGIN

			--IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListQuantasksMstDetType WHERE Active =0)
			--BEGIN
			--DELETE FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListQNId IN (SELECT distinct PPMCheckListQNId FROM @EngAssetPPMCheckListQuantasksMstDetType ) 
			--and PPMCheckListId  =@PPMCheckListId AND PPMCheckListQNId>0
			--DELETE FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListQNId IN (SELECT distinct PPMCheckListQNId FROM @EngAssetPPMCheckListQuantasksMstDetType 
			--WHERE Active =0 AND PPMCheckListQNId>0)
			--END

			--IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListCategory WHERE Active =0)
			--BEGIN
			--DELETE FROM EngAssetPPMCheckListCategoryHistory WHERE CategoryId IN (SELECT distinct CategoryId FROM @EngAssetPPMCheckListCategory ) 
			--and PPMCheckListId  =@PPMCheckListId AND CategoryId>0
			--DELETE FROM EngAssetPPMCheckListCategory WHERE CategoryId IN (SELECT distinct CategoryId FROM @EngAssetPPMCheckListCategory 
			--WHERE Active =0 AND CategoryId>0)
			--END

			

			UPDATE  PPMCheckList	SET	
									PPMCheckList.SpecialPrecautions					=	@SpecialPrecautions	,
									PPMCheckList.PpmHours							=	@PpmHours,
										
									PPMCheckList.Remarks							=	@Remarks,				
									PPMCheckList.ModifiedBy							=	@UserId,			
									PPMCheckList.ModifiedDate						=	GETDATE(),		
									PPMCheckList.ModifiedDateUTC					=	GETUTCDATE()

				OUTPUT INSERTED.PPMCheckListId INTO @Table
				FROM	EngAssetPPMCheckList							AS PPMCheckList 
		         WHERE	 PPMCheckList.PPMCheckListId  =@PPMCheckListId
		

		--select PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from EngAssetPPMCheckListQuantasksMstDet where PPMCheckListId = @PPMCheckListId
		--																  except select @PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from @EngAssetPPMCheckListQuantasksMstDetType


				  set @PPMCheckListQuantasksCount = (select count(*) from(select PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from EngAssetPPMCheckListQuantasksMstDet where PPMCheckListId = @PPMCheckListId
																		  except select @PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from @EngAssetPPMCheckListQuantasksMstDetType) a)


					Declare @VersionCount  int
					select @VersionCount=max(VersionNo) from 
					(SELECT VersionNo FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListId = @PPMCheckListId
					union all
					select VersionNo from EngAssetPPMCheckListCategoryHistory WHERE PPMCheckListId = @PPMCheckListId) a

					--DECLARE @VersionCountQuantasks int =(SELECT ISNULL(max(VersionNo+1),1) FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListId = @PPMCheckListId)

					--IF(@PPMCheckListQuantasksCount>0)
					--BEGIN
					--INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)
					--SELECT PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCountQuantasks,
					--@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1 FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListId = @PPMCheckListId
					--END
					--IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListQuantasksMstDetType WHERE PPMCheckListQNId=0 OR Active=0 OR @PPMCheckListQuantasksCount>0)
					--BEGIN

					--	INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)
					--	SELECT PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCountQuantasks,
					--	@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1 FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListId = @PPMCheckListId
					--END

					 INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)
					 select PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCount,@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1
					 from
					 (select PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,Active from EngAssetPPMCheckListQuantasksMstDet 
					 where PPMCheckListId = @PPMCheckListId  and PPMCheckListQNId in (	 select PPMCheckListQNId from @EngAssetPPMCheckListQuantasksMstDetType PPMCheckListQuanTaskudt
					 where  PPMCheckListQuanTaskudt.Active = 1)
					 except
					 select PPMCheckListQNId,@PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,Active from @EngAssetPPMCheckListQuantasksMstDetType PPMCheckListQuanTaskudt
					 where  PPMCheckListQuanTaskudt.Active = 1) a



				  UPDATE  PPMCheckListQuanTask	SET			
								--	PPMCheckListQuanTask.PPMCheckListId				=	PPMCheckListQuanTaskudt.PPMCheckListId,		
									PPMCheckListQuanTask.QuantitativeTasks			=	PPMCheckListQuanTaskudt.QuantitativeTasks,	
									PPMCheckListQuanTask.UOM						=	PPMCheckListQuanTaskudt.UOM	,			
									PPMCheckListQuanTask.SetValues					=	PPMCheckListQuanTaskudt.SetValues,			
									PPMCheckListQuanTask.LimitTolerance				=	PPMCheckListQuanTaskudt.LimitTolerance,		
									PPMCheckListQuanTask.ModifiedBy					=	@UserId,				
									PPMCheckListQuanTask.ModifiedDate				=	GETDATE(),		
									PPMCheckListQuanTask.ModifiedDateUTC			=	GETUTCDATE(),
								    PPMCheckListQuanTask.Active			=	PPMCheckListQuanTaskudt.Active

	
	          	FROM	EngAssetPPMCheckListQuantasksMstDet						AS PPMCheckListQuanTask 
				INNER JOIN @EngAssetPPMCheckListQuantasksMstDetType		AS PPMCheckListQuanTaskudt on PPMCheckListQuanTask.PPMCheckListQNId=PPMCheckListQuanTaskudt.PPMCheckListQNId
	         	WHERE	ISNULL(PPMCheckListQuanTaskudt.PPMCheckListQNId,0)>0 AND PPMCheckListQuanTaskudt.Active = 1

				 INSERT INTO EngAssetPPMCheckListQuantasksMstDet
						(	
								
							PPMCheckListId,		
							QuantitativeTasks,	
							UOM,					
							SetValues,			
							LimitTolerance,		
							CreatedBy,		
							CreatedDate	,	
							CreatedDateUTC,	
							ModifiedBy,		
							ModifiedDate,	
							ModifiedDateUTC	
						)							
			SELECT  
								
							@PPMCheckListId,		
							QuantitativeTasks,	
							UOM,				
							SetValues,			
							LimitTolerance,			
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE()		
			FROM	@EngAssetPPMCheckListQuantasksMstDetType as ppmquantity
			WHERE   ISNULL(ppmquantity.PPMCheckListQNId,0)=0 and ppmquantity.Active=1

					set @PPMCheckListCategoryCount = (select count(*) from(select PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from EngAssetPPMCheckListCategory where PPMCheckListId = @PPMCheckListId
																		  except select @PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from @EngAssetPPMCheckListCategory) a)
					--DECLARE @VersionCountCategory int =(SELECT ISNULL(max(VersionNo+1),1) FROM EngAssetPPMCheckListCategoryHistory WHERE PPMCheckListId = @PPMCheckListId)
					--IF(@PPMCheckListCategoryCount>0)
					--BEGIN
					--INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)
					--SELECT CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCountCategory,
					--@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder FROM EngAssetPPMCheckListCategory WHERE PPMCheckListId = @PPMCheckListId
					--END

					--IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListCategory WHERE CategoryId=0 OR Active=0 OR @PPMCheckListCategoryCount>0)
					--BEGIN
					--	INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)
					--	SELECT CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCountCategory,
					--	@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder FROM EngAssetPPMCheckListCategory WHERE PPMCheckListId = @PPMCheckListId
					--END


					--IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListCategory WHERE CategoryId=0 OR Active=0 OR @PPMCheckListCategoryCount>0)
					--BEGIN
					--	INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)
					--	SELECT CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCountCategory,
					--	@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder FROM EngAssetPPMCheckListCategory WHERE PPMCheckListId = @PPMCheckListId
					--END

					 INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)
					 select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCount,@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder
					 from
					 (select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from EngAssetPPMCheckListCategory 
					 where PPMCheckListId = @PPMCheckListId  and CategoryId in (	 select CategoryId from @EngAssetPPMCheckListCategory PPMCheckListCategoryudt
					 where  PPMCheckListCategoryudt.Active = 1)
					 except
					 select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from @EngAssetPPMCheckListCategory PPMCheckListCategoryudt
					 where  PPMCheckListCategoryudt.Active = 1) a

				  UPDATE  PPMCheckListCategory	SET		
					--PPMCheckListCategory.PPMCheckListId				=	PPMCheckListCategoryudt.PPMCheckListId,
					PPMCheckListCategory.PPMCheckListCategoryId		=	PPMCheckListCategoryudt.PPMCheckListCategoryId,
					PPMCheckListCategory.Number						=	PPMCheckListCategoryudt.Number,
					PPMCheckListCategory.Description				=	PPMCheckListCategoryudt.Description,
					PPMCheckListCategory.IsWorkOrder				=	PPMCheckListCategoryudt.IsWorkOrder,
					PPMCheckListCategory.ModifiedBy					=	@UserId,				
					PPMCheckListCategory.ModifiedDate				=	GETDATE(),		
					PPMCheckListCategory.ModifiedDateUTC			=	GETUTCDATE()

	          	FROM	EngAssetPPMCheckListCategory			AS PPMCheckListCategory 
				INNER JOIN @EngAssetPPMCheckListCategory		AS PPMCheckListCategoryudt on PPMCheckListCategory.CategoryId=PPMCheckListCategoryudt.CategoryId
	         	WHERE	ISNULL(PPMCheckListCategoryudt.CategoryId,0)>0 AND PPMCheckListCategoryudt.Active=1

				INSERT INTO EngAssetPPMCheckListCategory
						(	
							PPMCheckListId,
							PPMCheckListCategoryId,
							Number,
							Description,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							Active,
							BuiltIn,
							IsWorkOrder	
						)							
			SELECT  
								
							@PPMCheckListId,
							PPMCheckListCategoryId,
							Number,
							Description,		
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE(),
							1,
							1,
							IsWorkOrder		
			FROM	@EngAssetPPMCheckListCategory ppmCategory
				WHERE   ISNULL(ppmCategory.CategoryId,0)=0 and ppmCategory.Active=1
	       
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


----------------------------------------------------------------------UDT SCRIPT----------------------------------------------------------
/*
CREATE TYPE [dbo].[udt_EngAssetPPMCheckList] AS TABLE
(
PPMCheckListId						INT,
PPMRegisterId						INT,
ServiceId							INT,
AssetTypeCodeId						INT,
StandardTaskDetId					INT,
PPMChecklistNo						NVARCHAR(120),
ManufacturerId						INT,
ModelId								INT,
PPMFrequency						INT,
PpmHours							NUMERIC(24,2),
SpecialPrecautions					NVARCHAR(2000),
DoneBy								INT,
Remarks								NVARCHAR(1000),
[Description]						NVARCHAR(510),
CreatedBy							INT,
ModifiedBy							INT,
Active								BIT			 DEFAULT 1,
BuiltIn								BIT			 DEFAULT 1
)


CREATE TYPE [dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet] AS TABLE
(
PPMCheckListQTId					INT,
PPMCheckListId						INT,
QualitativeTasks					NVARCHAR(2000),
CreatedBy							INT,
ModifiedBy							INT,
Active								BIT			DEFAULT 1,
BuiltIn								BIT			DEFAULT 1
)

CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet] AS TABLE
(
PPMCheckListQualTasksId				INT,
PPMCheckListId						INT,
QualTasks							NVARCHAR(2000),
CreatedBy							INT,
ModifiedBy							INT,
Active								BIT			DEFAULT 1,
BuiltIn								BIT			DEFAULT 1
)

CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQuantasksMstDet] AS TABLE
(
PPMCheckListQNId					INT,
PPMCheckListId						INT,
QuantitativeTasks					NVARCHAR(2000),
UOM									NVARCHAR(20),
SetValues							NVARCHAR(20),
LimitTolerance						NVARCHAR(20),
CreatedBy							INT,
ModifiedBy							INT,
Active								BIT			DEFAULT 1,
BuiltIn								BIT			DEFAULT 1
)

CREATE TYPE [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst] AS TABLE
(
PPMCheckListStatusHistoryId			INT,
PPMCheckListId						INT,
DoneBy								INT,
Date								DATETIME,
Status								INT,
CreatedBy							INT,
ModifiedBy							INT,
Active								BIT			DEFAULT 1,
BuiltIn								BIT			DEFAULT 1

CREATE TYPE [dbo].[udt_EngAssetPPMCheckListCategory] AS TABLE
(
CategoryId							INT,
PPMCheckListId						INT,
PPMCheckListCategoryId				INT,
Number								INT,
Description							NVARCHAR(1000),
IsWorkOrder							BIT,
Active								BIT			DEFAULT 1,
BuiltIn								BIT			DEFAULT 1
)
*/
GO
