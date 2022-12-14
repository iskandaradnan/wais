USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Test_INS_Master_Data_Test]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[Test_INS_Master_Data_Test]           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

INSERT INTO [dbo].[MstLocationBlock] ([CustomerId],[FacilityId],[BlockCode],[BlockName],[ShortName],[ActiveFromDate],[ActiveFromDateUTC],[ActiveToDate],[ActiveToDateUTC],[CreatedBy]
           ,[CreatedDate],[CreatedDateUTC],[ModifiedBy],[ModifiedDate],[ModifiedDateUTC],[Active],[BuiltIn],[GuId]) OUTPUT Inserted.BlockId
     VALUES
           (1,1,'BlockCode','BlockName','ShortName',GETDATE(),GETDATE(),GETDATE(),GETDATE(),1,GETDATE(),GETDATE(),1,GETDATE()
           ,GETDATE(),1,1,NEWID())
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                        
END
GO
