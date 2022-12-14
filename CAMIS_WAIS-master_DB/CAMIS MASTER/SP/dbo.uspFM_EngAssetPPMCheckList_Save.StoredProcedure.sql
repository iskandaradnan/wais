USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_Save]                  
                  
                  
  @PPMCheckListId  INT= NULL,                    
  @AssetTypeCodeId  INT= NULL,                   
  @ServiceId   INT= NULL,                   
  @PPMChecklistNo  NVARCHAR(200)= NULL,                  
  @ManufacturerId  INT= NULL,                   
  @ModelId    INT= NULL,                   
  @PPMFrequency   INT= NULL,                    
  @PpmHours    numeric(24, 2)= NULL,                  
  @SpecialPrecautions NVARCHAR(1000)=NULL,                  
  @Remarks    NVARCHAR(500)=NULL,                  
  --@Description   NVARCHAR(500),                  
                  
  @UserId    INT=NULL,                  
  @TaskCode             nvarchar(200)=null,                  
  @TaskCodeDesc         nvarchar(1000)= null,                   
  @EngAssetPPMCheckListQuantasksMstDetType  AS [dbo].[udt_EngAssetPPMCheckListQuantasksMstDet] READONLY,                  
         
 @EngAssetPPMCheckListCategory     AS  [dbo].[udt_EngAssetPPMCheckListCategory] READONLY                  
                  
                  
                  
                   
 -- @EngAssetPPMCheckListType      AS [dbo].[udt_EngAssetPPMCheckList]   READONLY ,                  
            
                   
                    
                   
 -- @EngAssetPPMCheckListStatusHistoryMstType  AS [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst] READONLY                               
                      
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
                   
 SELECT @mAssetTypeCode = AssetTypeCode FROM EngAssetTypeCode WHERE AssetTypeCodeId = @AssetTypeCodeId                  
 DECLARE @mCodeGen VARCHAR(20) =(select MAX(Right(TaskCode,6)) from EngAssetPPMCheckList where AssetTypeCodeId = @AssetTypeCodeId and PPMFrequency= @PPMFrequency)                  
 DECLARE @mFinalCodeGen nvarchar(100)                  
 DECLARE @mcondition INT                 
                   
 --IF (@mCodeGen IS NULL)                  
 --BEGIN                  
 --SET @mFinalCodeGen ='000001'                  
 --END                  
 --ELSE                  
 --BEGIN                  
 --SET @mFinalCodeGen =right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)                  
 --END                  
                   
 --PRINT @mFinalCodeGen      -- Execution                
     
 IF (@mCodeGen != NULL)                  
 BEGIN                  
 SET @mFinalCodeGen ='000001'   
  PRINT @mFinalCodeGen
 END                  
 ELSE                  
 BEGIN      
 IF(@ServiceId=1)    
 BEGIN    
SET @mCodeGen='000000'
 IF (@PPMFrequency=44)                  
 BEGIN   
 SET @mFinalCodeGen ='AN/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)  
 END   
 ELSE IF (@PPMFrequency=45)                  
 BEGIN        
 SET @mFinalCodeGen ='HY/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)     
 END 
 ELSE IF (@PPMFrequency=46)                  
 BEGIN   
 SET @mFinalCodeGen ='QU/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6) 
 END 
 ELSE IF @PPMFrequency=48                  
 BEGIN      
 SET @mFinalCodeGen ='MO/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)  
 END 
 ELSE IF (@PPMFrequency=47)     
 BEGIN  
 SET @mFinalCodeGen ='BM/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)
 END   
 ELSE IF (@PPMFrequency=50)                  
 BEGIN  
 SET @mFinalCodeGen ='WE/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)    
 END   
 ELSE IF (@PPMFrequency=49)                  
 BEGIN    
 SET @mFinalCodeGen ='BW/'+right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6) 
 END                 
 END 
 ELSE    
 BEGIN  
 SET @mCodeGen='000000'
 SET @mFinalCodeGen =right('000000'+cast(@mCodeGen+1 as nvarchar(100)),6)  
 END    
 END    
 PRINT @mFinalCodeGen      -- Execution                
                   
 --------------------------------------------UPDATE STATEMENT-------------------------------------                  
 --//1.EngAssetPPMCheckList                  
                  
                  
                  
      if(isnull(@PPMCheckListId,0) = 0)                  
   begin                  
   if(@ServiceId=1)                
    BEGIN                  
    set @mcondition = (SELECT count(*) FROM EngAssetPPMCheckList WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId and PPMFrequency=@PPMFrequency )                
    END                   
   else                
   BEGIN                 
    set @mcondition = (SELECT count(*) FROM EngAssetPPMCheckList WHERE AssetTypeCodeId = @AssetTypeCodeId AND ModelId = @ModelId )                
    END                
                 
                
   IF (@mcondition=0 )                  
                  
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
       ModifiedDateUTC ,                  
       TaskCode,                  
       TaskDescription                   
      ) OUTPUT INSERTED.PPMCheckListId INTO @Table                    
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
   set @mPPMCheckListId  = (SELECT PPMCheckListId FROM EngAssetPPMCheckList WHERE PPMCheckListId IN (SELECT ID FROM @Table))                  
                  
                  
 ------ NOW COMMENTED        
         
   INSERT INTO EngAssetPPMCheckListQuantasksMstDet                  
      (                   
                          
       PPMCheckListId,                    
       QuantitativeTasks,                   
       UOM,                       
       SetValues,                     
       LimitTolerance,                    
       CreatedBy,                    
       CreatedDate ,                   
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
       @UserId       ,                     
       GETDATE(),                    
      GETUTCDATE()                    
   FROM @EngAssetPPMCheckListQuantasksMstDetType                  
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
       @UserId       ,                     
       GETDATE(),                    
       GETUTCDATE(),                  
       1,                  
       1,                  
       IsWorkOrder                    
   FROM @EngAssetPPMCheckListCategory                  
   WHERE   ISNULL(CategoryId,0)=0 and Active=1                  
                  
                  
                  
      SELECT    PPMCheckListId,                         
          '' ErrorMessage,@PPMChecklistNo as [OUTPPMChecklistNo] ,@mAssetTypeCode+'-'+@mFinalCodeGen as[Taskcodes]                
   FROM     EngAssetPPMCheckList                  
   WHERE    PPMCheckListId IN (SELECT ID FROM @Table)                  
  END                  
                  
  ELSE                  
   BEGIN                  
    SELECT     0 AS  PPMCheckListId,                         
         'Asset Type Code, Model combination already exists' ErrorMessage                  
   END                  
                  
   END                   
                  
   ELSE                   
  BEGIN                  
                  
    --COMMENTED NOW        
        
   IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListQuantasksMstDetType WHERE Active =0)                  
   BEGIN                  
   --DELETE FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListQNId IN (SELECT distinct PPMCheckListQNId FROM @EngAssetPPMCheckListQuantasksMstDetType )                   
   --and PPMCheckListId  =@PPMCheckListId AND PPMCheckListQNId>0                  
   DELETE FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListQNId IN (SELECT distinct PPMCheckListQNId FROM @EngAssetPPMCheckListQuantasksMstDetType                   
   WHERE Active =0 AND PPMCheckListQNId>0)                  
   END                  
                  
   IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListCategory WHERE Active =0)                  
   BEGIN                  
   --DELETE FROM EngAssetPPMCheckListCategoryHistory WHERE CategoryId IN (SELECT distinct CategoryId FROM @EngAssetPPMCheckListCategory )                   
   --and PPMCheckListId  =@PPMCheckListId AND CategoryId>0                  
   DELETE FROM EngAssetPPMCheckListCategory WHERE CategoryId IN (SELECT distinct CategoryId FROM @EngAssetPPMCheckListCategory                   
   WHERE Active =0 AND CategoryId>0)                  
   END                  
                  
                     
                  
   UPDATE  PPMCheckList SET                   
         PPMCheckList.SpecialPrecautions     = @SpecialPrecautions ,                  
         PPMCheckList.PpmHours       = @PpmHours,                  
                            
         PPMCheckList.Remarks       = @Remarks,                      
         PPMCheckList.ModifiedBy       = @UserId,                     
         PPMCheckList.ModifiedDate      = GETDATE(),                    
         PPMCheckList.ModifiedDateUTC     = GETUTCDATE()                  
                  
    OUTPUT INSERTED.PPMCheckListId INTO @Table                  
    FROM EngAssetPPMCheckList       AS PPMCheckList                   
           WHERE  PPMCheckList.PPMCheckListId  =@PPMCheckListId                  
                    
                  
  --select PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from EngAssetPPMCheckListQuantasksMstDet where PPMCheckListId = @PPMCheckListId                  
  --                  except select @PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from @EngAssetPPMCheckListQuantasksMstDetType                  
                  
                  
    -----COMMENTED NOW        
        
      set @PPMCheckListQuantasksCount = (select count(*) from(select PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from EngAssetPPMCheckListQuantasksMstDet where PPMCheckListId = @PPMCheckListId                  
                    except select @PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance from @EngAssetPPMCheckListQuantasksMstDetType) a)                  
                  
        -----COMMENTED NOW         
           
        
     Declare @VersionCount  int                  
     select @VersionCount=ISNULL(max(VersionNo+1),1) from                   
     (SELECT VersionNo FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListId = @PPMCheckListId                  
     union all                  
     select VersionNo from EngAssetPPMCheckListCategoryHistory WHERE PPMCheckListId = @PPMCheckListId) a                  
     select @VersionCount =isnull(@VersionCount,1)                  
     --DECLARE @VersionCountQuantasks int =(SELECT ISNULL(max(VersionNo+1),1) FROM EngAssetPPMCheckListQuantasksMstDetHistory WHERE PPMCheckListId = @PPMCheckListId)                  
                  
     --IF(@PPMCheckListQuantasksCount>0)                  
     --BEGIN                  
     --INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)           
  
     
      
     --SELECT PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCountQuantasks,                  
     --@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1 FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListId = @PPMCheckListId                  
     --END                  
     --IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListQuantasksMstDetType WHERE PPMCheckListQNId=0 OR Active=0 OR @PPMCheckListQuantasksCount>0)                  
     --BEGIN                  
                  
     -- INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)           
  
    
      
       
     -- SELECT PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCountQuantasks,                  
     -- @UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1 FROM EngAssetPPMCheckListQuantasksMstDet WHERE PPMCheckListId = @PPMCheckListId                  
     --END                  
                  
--------------COMMENTED NOW        
        
      INSERT INTO EngAssetPPMCheckListQuantasksMstDetHistory(PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)             
  
    
     
      select PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,@VersionCount,@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1                  
      from                  
      (select PPMCheckListQNId,PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,Active from EngAssetPPMCheckListQuantasksMstDet                   
      where PPMCheckListId = @PPMCheckListId  and PPMCheckListQNId in (  select PPMCheckListQNId from @EngAssetPPMCheckListQuantasksMstDetType PPMCheckListQuanTaskudt                  
      where  PPMCheckListQuanTaskudt.Active = 1)                  
      except                  
      select PPMCheckListQNId,@PPMCheckListId,QuantitativeTasks,UOM,SetValues,LimitTolerance,Active from @EngAssetPPMCheckListQuantasksMstDetType PPMCheckListQuanTaskudt                  
      where  PPMCheckListQuanTaskudt.Active = 1) a                  
                  
        
                  
      UPDATE  PPMCheckListQuanTask SET                     
     -- PPMCheckListQuanTask.PPMCheckListId    = PPMCheckListQuanTaskudt.PPMCheckListId,                    
         PPMCheckListQuanTask.QuantitativeTasks   = PPMCheckListQuanTaskudt.QuantitativeTasks,                   
     PPMCheckListQuanTask.UOM      = PPMCheckListQuanTaskudt.UOM ,                     
         PPMCheckListQuanTask.SetValues     = PPMCheckListQuanTaskudt.SetValues,                     
         PPMCheckListQuanTask.LimitTolerance    = PPMCheckListQuanTaskudt.LimitTolerance,                    
         PPMCheckListQuanTask.ModifiedBy     = @UserId,                      
         PPMCheckListQuanTask.ModifiedDate    = GETDATE(),                    
         PPMCheckListQuanTask.ModifiedDateUTC   = GETUTCDATE(),                  
            PPMCheckListQuanTask.Active   = PPMCheckListQuanTaskudt.Active                  
                  
                   
            FROM EngAssetPPMCheckListQuantasksMstDet      AS PPMCheckListQuanTask                   
    INNER JOIN @EngAssetPPMCheckListQuantasksMstDetType  AS PPMCheckListQuanTaskudt on PPMCheckListQuanTask.PPMCheckListQNId=PPMCheckListQuanTaskudt.PPMCheckListQNId                  
           WHERE ISNULL(PPMCheckListQuanTaskudt.PPMCheckListQNId,0)>0 AND PPMCheckListQuanTaskudt.Active = 1                  
                  
------------COMMENTED NOW                  
        
     INSERT INTO EngAssetPPMCheckListQuantasksMstDet                  
      (                   
                          
       PPMCheckListId,                    
       QuantitativeTasks,                   
       UOM,                       
       SetValues,                     
       LimitTolerance,                    
       CreatedBy,                    
       CreatedDate ,                   
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
       @UserId       ,                     
       GETDATE(),                    
       GETUTCDATE()                    
   FROM @EngAssetPPMCheckListQuantasksMstDetType as ppmquantity                  
   WHERE   ISNULL(ppmquantity.PPMCheckListQNId,0)=0 and ppmquantity.Active=1                  
            
---COMMENTED NOW         
        
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
     -- INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)                 
 
     -- SELECT CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCountCategory,                  
     -- @UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder FROM EngAssetPPMCheckListCategory WHERE PPMCheckListId = @PPMCheckListId                  
     --END                  
                  
                  
     --IF EXISTS(SELECT 1 FROM @EngAssetPPMCheckListCategory WHERE CategoryId=0 OR Active=0 OR @PPMCheckListCategoryCount>0)                  
     --BEGIN                  
     -- INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)                 
 
     -- SELECT CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCountCategory,                  
     -- @UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder FROM EngAssetPPMCheckListCategory WHERE PPMCheckListId = @PPMCheckListId                  
     --END                  
                  
      INSERT INTO EngAssetPPMCheckListCategoryHistory(CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,VersionNo,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn,IsWorkOrder)                  
      select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,@VersionCount,@UserId,GETDATE(),GETUTCDATE(),@UserId,GETDATE(),GETUTCDATE(),1,1,IsWorkOrder                  
      from                  
      (select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from EngAssetPPMCheckListCategory                   
      where PPMCheckListId = @PPMCheckListId  and CategoryId in (  select CategoryId from @EngAssetPPMCheckListCategory PPMCheckListCategoryudt                  
      where  PPMCheckListCategoryudt.Active = 1)                  
      except                  
      select CategoryId,PPMCheckListId,PPMCheckListCategoryId,Number,Description,IsWorkOrder from @EngAssetPPMCheckListCategory PPMCheckListCategoryudt                  
      where  PPMCheckListCategoryudt.Active = 1) a                  
                  
     UPDATE  PPMCheckListCategory SET                    
     --PPMCheckListCategory.PPMCheckListId    = PPMCheckListCategoryudt.PPMCheckListId,                  
     PPMCheckListCategory.PPMCheckListCategoryId  = PPMCheckListCategoryudt.PPMCheckListCategoryId,                  
     PPMCheckListCategory.Number      = PPMCheckListCategoryudt.Number,                  
     PPMCheckListCategory.Description    = PPMCheckListCategoryudt.Description,                  
     PPMCheckListCategory.IsWorkOrder    = PPMCheckListCategoryudt.IsWorkOrder,                  
     PPMCheckListCategory.ModifiedBy     = @UserId,                      
     PPMCheckListCategory.ModifiedDate    = GETDATE(),                    
     PPMCheckListCategory.ModifiedDateUTC   = GETUTCDATE()                  
                  
            FROM EngAssetPPMCheckListCategory   AS PPMCheckListCategory                   
    INNER JOIN @EngAssetPPMCheckListCategory  AS PPMCheckListCategoryudt on PPMCheckListCategory.CategoryId=PPMCheckListCategoryudt.CategoryId                  
           WHERE ISNULL(PPMCheckListCategoryudt.CategoryId,0)>0 AND PPMCheckListCategoryudt.Active=1                  
                  
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
       @UserId       ,                     
       GETDATE(),                    
       GETUTCDATE(),                  
       1,                  
       1,                  
       IsWorkOrder                    
   FROM @EngAssetPPMCheckListCategory ppmCategory                  
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
 VALUES(  OBJECT_NAME(@@PROCID),                  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),                  
    getdate()                  
     );                  
THROW;                  
END CATCH                  
                  
                  
----------------------------------------------------------------------UDT SCRIPT----------------------------------------------------------                  
/*                  
CREATE TYPE [dbo].[udt_EngAssetPPMCheckList] AS TABLE                  
(                  
PPMCheckListId      INT,                  
PPMRegisterId      INT,                  
ServiceId       INT,                  
AssetTypeCodeId      INT,                  
StandardTaskDetId     INT,                  
PPMChecklistNo      NVARCHAR(120),                  
ManufacturerId      INT,                  
ModelId        INT,                  
PPMFrequency      INT,                  
PpmHours       NUMERIC(24,2),                  
SpecialPrecautions     NVARCHAR(2000),                  
DoneBy        INT,                  
Remarks        NVARCHAR(1000),                  
[Description]      NVARCHAR(510),                  
CreatedBy       INT,                  
ModifiedBy       INT,                  
Active        BIT    DEFAULT 1,                  
BuiltIn        BIT    DEFAULT 1                  
)                  
                  
                  
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet] AS TABLE                  
(                  
PPMCheckListQTId     INT,                  
PPMCheckListId      INT,                  
QualitativeTasks     NVARCHAR(2000),                  
CreatedBy       INT,                  
ModifiedBy       INT,                  
Active        BIT   DEFAULT 1,                  
BuiltIn        BIT   DEFAULT 1                  
)                  
                  
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet] AS TABLE                  
(                  
PPMCheckListQualTasksId    INT,                  
PPMCheckListId      INT,                  
QualTasks       NVARCHAR(2000),               
CreatedBy       INT,                  
ModifiedBy       INT,                  
Active        BIT   DEFAULT 1,                  
BuiltIn        BIT   DEFAULT 1                  
)                  
                
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQuantasksMstDet] AS TABLE                  
(                  
PPMCheckListQNId     INT,                  
PPMCheckListId      INT,               
QuantitativeTasks     NVARCHAR(2000),                  
UOM         NVARCHAR(20),                  
SetValues       NVARCHAR(20),                  
LimitTolerance      NVARCHAR(20),                  
CreatedBy       INT,                  
ModifiedBy       INT,                  
Active        BIT   DEFAULT 1,                  
BuiltIn        BIT   DEFAULT 1                  
)                  
                  
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst] AS TABLE                  
(                  
PPMCheckListStatusHistoryId   INT,                  
PPMCheckListId      INT,                  
DoneBy        INT,                  
Date        DATETIME,                  
Status        INT,                  
CreatedBy       INT,                  
ModifiedBy       INT,                  
Active        BIT   DEFAULT 1,                  
BuiltIn        BIT   DEFAULT 1                  
                  
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListCategory] AS TABLE                  
(                  
CategoryId       INT,                  
PPMCheckListId      INT,                  
PPMCheckListCategoryId    INT,            
Number        INT,                  
Description       NVARCHAR(1000),                  
IsWorkOrder       BIT,                  
Active        BIT   DEFAULT 1,                  
BuiltIn        BIT   DEFAULT 1                  
)                  
*/
GO
