USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_TransportationCodeFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_TransportationCodeFetch]  
 -- EXEC [dbo].[sp_HWMS_TransportationCodeFetch]  'P',1,5, 25
   @HospitalCode    nvarchar(100) = NULL,  
   @pPageIndex     INT,  
   @pPageSize     INT,  
   @pFacilityId     INT  
  
AS                                                
  
BEGIN TRY  
 SET NOCOUNT ON;   
  
 DECLARE @TotalRecords INT  
  
   
  SELECT  @TotalRecords = COUNT(*)  
  FROM  [dbo].[MstLocationFacility] A WITH(NOLOCK)  
  where  ((ISNULL(@HospitalCode ,'') = '' ) OR (ISNULL(@HospitalCode ,'') <> '' AND A.[FacilityCode]  LIKE + '%' + @HospitalCode + '%' ))  
    
  select A.[FacilityId], A.[FacilityCode] AS HospitalCode , A.[FacilityName] AS HospitalName , @TotalRecords AS TotalRecords  
  FROM  [dbo].[MstLocationFacility] A WITH(NOLOCK)  
  where  ((ISNULL(@HospitalCode,'') = '' ) OR (ISNULL(@HospitalCode,'') <> '' AND A.[FacilityCode] LIKE + '%' + @HospitalCode + '%' ))  
  ORDER BY A.[FacilityId] DESC  
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  
  END TRY  
BEGIN CATCH  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), ERROR_LINE())+' - '+ERROR_MESSAGE(),  
    GETDATE()  
     )  
END CATCH
GO
