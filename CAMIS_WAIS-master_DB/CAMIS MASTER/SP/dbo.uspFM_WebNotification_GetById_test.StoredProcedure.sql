USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_WebNotification_GetById_test]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec uspFM_WebNotification_GetById_test 10, 40, 5, 1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE  [dbo].[uspFM_WebNotification_GetById_test]

 
 @pFacilityId INT=null,
 @pUserId  INT=null,
 @pPageSize  INT=null,
 @pPageIndex  INT=null

AS                                              

BEGIN TRY


-- Paramter Validation 

 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
 
 --select @pPageIndex=@pPageIndex+1
-- Default Values

declare @TotalRecords int, @pTotalPage int

 SELECT @TotalRecords = count(1)
 FROM WebNotification
 WHERE FacilityId = @pFacilityId
   AND UserId = @pUserId
   AND IsNavigate = 0
   --AND IsNew = 1
 	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

-- Execution


 SELECT NotificationId,
   CustomerId,
   FacilityId,
   UserId,
   NotificationAlerts,
   Remarks,
   HyperLink,
   IsNew,
   NotificationDateTime AS NotificationDateTime,
   --CONVERT(datetime, NotificationDateTime) AS NotificationDateTime,
   UPPER(substring(HyperLink,2,CHARINDEX('/',SUBSTRING(HyperLink,2,LEN(HyperLink)))-1)) AS Module,
   @TotalRecords as TotalRecords,
   @pTotalPage  as TotalPageCalc
 FROM WebNotification
 WHERE FacilityId = @pFacilityId
   AND UserId = @pUserId
   AND IsNavigate = 0
   --AND IsNew = 1
 ORDER BY NotificationId DESC
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
     );
     THROW;

END CATCH
GO
