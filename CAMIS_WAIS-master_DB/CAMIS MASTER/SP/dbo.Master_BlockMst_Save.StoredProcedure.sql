USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_BlockMst_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[Master_BlockMst_Save]                           

(
	@CustomerId  int,
	@FacilityId int,
	@UserId int,
	@Active bit,
	@BlockCode nvarchar(25),
	@BlockName nvarchar(25),
	@ShortName nvarchar(25),
	@BEMS int,
	@FEMS int,
	@CLS int,
	@LLS int,
	@HWMS int
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)
	DECLARE @Tables TABLE (ID INT)
	DECLARE @ids  int
	
	 

INSERT INTO MstLocationBlock (
				CustomerId, FacilityId,BlockCode,BlockName, ShortName, CreatedBy, CreatedDate, ActiveFromDate, ActiveFromDateUTC, ActiveToDate, ActiveToDateUTC,
				CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active, BuiltIn) OUTPUT INSERTED.BlockId INTO @Table

    

	  Values (@CustomerId, @FacilityId, @BlockCode, @BlockName, @ShortName, 1, GETDATE(),GETDATE(),GETUTCDATE(), GETDATE(), GETUTCDATE(),
				GETUTCDATE(), @UserId, GETDATE(), GETUTCDATE(), @Active, 1)


				
INSERT INTO MstServices_Mapping_block (Master_Block_ID,BEMS,FEMS,CLS,LLS,HWMS) Values ((SELECT ID FROM @Table),@BEMS,@FEMS,@CLS,@LLS,@HWMS)  
	

	SELECT BlockId, [Timestamp], '' ErrorMsg,GuId FROM MstLocationBlock WHERE BlockId IN (SELECT ID FROM @Table)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
