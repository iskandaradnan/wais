USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_LicenseType_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_LicenseType_Get]  
(  
 @Id INT  
)  
   
AS   
BEGIN  
SET NOCOUNT ON  
BEGIN TRY  
   
      SELECT * FROM HWMS_LicenseType where  LicenseTypeId =@Id  
        
         SELECT * FROM HWMS_LicenseType_Details  where LicenseTypeId=@Id AND [isDeleted] = 0  

		 select * from HWMS_LicenseType_Attachment where LicenseTypeId=@Id AND [isDeleted] = 0  
  
  
END TRY  
  
BEGIN CATCH  
INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH  
  
END
GO
