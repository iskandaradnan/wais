USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationUserArea_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspFM_MstLocationUserArea_Fetch]   
  
   @pUserAreaCode    NVARCHAR(100) = NULL,  
   @pPageIndex     INT,  
   @pPageSize     INT,  
   @pFacilityId     INT  
  
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
  FROM  MstLocationUserArea    AS UserArea  WITH(NOLOCK)  
     INNER JOIN MstLocationBlock  AS Block  WITH(NOLOCK) ON UserArea.BlockId  = Block.BlockId  
     INNER JOIN MstLocationLevel  AS Level  WITH(NOLOCK) ON UserArea.LevelId  = Level.LevelId  
     LEFT JOIN UMUserRegistration AS UserRegComp WITH(NOLOCK) ON UserArea.CustomerUserId = UserRegComp.UserRegistrationId  
     LEFT JOIN UMUserRegistration AS UserRegFac WITH(NOLOCK) ON UserArea.FacilityUserId = UserRegFac.UserRegistrationId  
  WHERE  UserArea.Active =1  
     AND ((ISNULL(@pUserAreaCode,'') = '' ) OR (ISNULL(@pUserAreaCode,'') <> '' AND (UserArea.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%' or UserArea.UserAreaName LIKE  + '%' + @pUserAreaCode + '%') ))  
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND UserArea.FacilityId = @pFacilityId))  
  
  SELECT  UserArea.UserAreaId,  
     UserArea.UserAreaCode,  
     UserArea.UserAreaName,
	 UserArea.ActiveFromDate,
	 UserArea.ActiveToDate,    
     Block.BlockId,  
     Level.LevelId,  
     (SELECT COUNT(*) FROM EngAsset WHERE UserAreaId = UserArea.UserAreaId) AS AssetCount,  
     UserArea.CustomerUserId,  
     UserRegComp.StaffName  AS CompanyRepresentative,  
     UserRegComp.Email   AS CompanyRepresentativeEmail,  
     UserArea.FacilityUserId,  
     UserRegFac.StaffName  AS FacilityRepresentative,  
     UserRegFac.Email   AS FacilityRepresentativeEmail,  
     @TotalRecords    AS TotalRecords  
  FROM  MstLocationUserArea    AS UserArea  WITH(NOLOCK)  
     INNER JOIN MstLocationBlock  AS Block  WITH(NOLOCK) ON UserArea.BlockId  = Block.BlockId  
     INNER JOIN MstLocationLevel  AS Level  WITH(NOLOCK) ON UserArea.LevelId  = Level.LevelId  
     LEFT JOIN UMUserRegistration AS UserRegComp WITH(NOLOCK) ON UserArea.CustomerUserId = UserRegComp.UserRegistrationId  
     LEFT JOIN UMUserRegistration AS UserRegFac WITH(NOLOCK) ON UserArea.FacilityUserId = UserRegFac.UserRegistrationId  
  WHERE  UserArea.Active =1  
     AND ((ISNULL(@pUserAreaCode,'') = '' ) OR (ISNULL(@pUserAreaCode,'') <> '' AND (UserArea.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%' or UserArea.UserAreaName LIKE  + '%' + @pUserAreaCode + '%') ))  
     AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND UserArea.FacilityId = @pFacilityId))  
  ORDER BY UserArea.ModifiedDateUTC DESC  
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
