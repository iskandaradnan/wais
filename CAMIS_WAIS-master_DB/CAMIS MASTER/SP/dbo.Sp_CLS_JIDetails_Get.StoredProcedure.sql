USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JIDetails_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CLS_JIDetails_Get]  
(  
 @Id INT  
)  
   
AS   
  
  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
   
  
SELECT [DetailsId], [CustomerId], [FacilityId], [DocumentNo], [DateTime], [UserAreaCode], [UserAreaName], [HospitalRepresentative], [HospitalRepresentativeDesignation], [CompanyRepresentative], [CompanyRepresentativeDesignation], [Remarks], [ReferenceNo], [Satisfactory], [NoofUserLocation], [UnSatisfactory], [GrandTotalElementsInspected], [NotApplicable], ISNULL([IsSubmitted],0) AS [IsSubmitted]
 FROM CLS_JiDetails where  DetailsId =  @Id  
select * from CLS_JiDetails_LocationCode where  DetailsId = @Id   
select * from CLS_JIDetails_Attachment where  DetailsId = @Id AND [isDeleted]=0  
   
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
