USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstStaff_Company_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : uspFM_MstStaff_Company_Fetch      
Description   : StaffName Fetch control      
Authors    : Dhilip V      
Date    : 12-April-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC uspFM_MstStaff_Company_Fetch  @pStaffName='',@pPageIndex=1,@pPageSize=10000,@pFacilityId=      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
      
CREATE PROCEDURE  [dbo].[uspFM_MstStaff_Company_Fetch]                 -- To be reviewed and use common uspFM_MstStaff_Fetch  -- By passing AccessLevel as additional parameter              
  @pStaffName   NVARCHAR(100) = NULL,      
  @pPageIndex   INT,      
  @pPageSize   INT,      
  @pFacilityId   INT      
AS                                                    
      
BEGIN TRY      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;       
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
      
 DECLARE @TotalRecords INT      
-- Default Values      
      
      
-- Execution      
      
  SELECT  @TotalRecords = COUNT(*)      
  FROM  UMUserRegistration     AS UMUser WITH(NOLOCK)      
     INNER JOIN UMUserLocationMstDet AS UserLoc  WITH(NOLOCK) ON UMUser.UserRegistrationId = UserLoc.UserRegistrationId      
     LEFT JOIN MstLocationFacility  AS Facility WITH(NOLOCK) ON UserLoc.FacilityId   = Facility.FacilityId      
     LEFT JOIN UserDesignation   AS Designation WITH(NOLOCK) ON UMUser.UserDesignationId = Designation.UserDesignationId      
  WHERE  UMUser.Status =1      
     AND UMUser.UserTypeId IN (2,3)      
     AND ((ISNULL(@pStaffName,'') = '' ) OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' or Designation.Designation LIKE  + '%' + @pStaffName + '%'      
     ) ))      
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND UserLoc.FacilityId = @pFacilityId))      
      
  SELECT  UMUser.UserRegistrationId  AS StaffMasterId,      
     UMUser.StaffName,      
     --UMUser.StaffEmployeeId,      
     Facility.FacilityName,      
     UMUser.PhoneNumber    AS ContactNo,      
     Designation.Designation,      
     Designation.UserDesignationId AS DesignationId,      
     --CAST(CAST((DATEDIFF(m, UMUser.DateJoined, GETDATE())/12) AS VARCHAR) + '.' +       
     -- CASE WHEN DATEDIFF(m, UMUser.DateJoined, GETDATE())%12 = 0 THEN '1'       
     --   ELSE cast((abs(DATEDIFF(m, UMUser.DateJoined, GETDATE())%12))       
     -- AS VARCHAR) END AS FLOAT)    AS [Experience],       
     DATEDIFF(YEAR,UMUser.DateJoined,GETDATE()) AS [Experience],      
     UMUser.Email,      
     @TotalRecords AS TotalRecords,      
     isnull(LabourCostPerHour,0)      
  FROM  UMUserRegistration     AS UMUser WITH(NOLOCK)      
     INNER JOIN UMUserLocationMstDet AS UserLoc  WITH(NOLOCK) ON UMUser.UserRegistrationId = UserLoc.UserRegistrationId      
     LEFT JOIN MstLocationFacility  AS Facility WITH(NOLOCK) ON UserLoc.FacilityId   = Facility.FacilityId      
     LEFT JOIN UserDesignation   AS Designation WITH(NOLOCK) ON UMUser.UserDesignationId = Designation.UserDesignationId      
  WHERE  UMUser.Status =1      
     ---COMMENTED ON 23072020 ----NEW REQ  
  --AND UMUser.UserTypeId IN (2,3)      
  AND UMUser.UserTypeId IN (1,2)    ---MAKING IT SAME AS MASTER  
  
     AND ((ISNULL(@pStaffName,'') = '' ) OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' or Designation.Designation LIKE  + '%' + @pStaffName + '%'      
     ) ))      
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND UserLoc.FacilityId = @pFacilityId))      
  ORDER BY UMUser.ModifiedDateUTC DESC      
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY       
      
      
      
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
GO
