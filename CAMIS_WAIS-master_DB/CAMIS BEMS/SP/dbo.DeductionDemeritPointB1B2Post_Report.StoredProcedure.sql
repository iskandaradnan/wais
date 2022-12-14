USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB1B2Post_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
--EXEC [DeductionDemeritPointB1B2Post_Report] 2020,8            
            
CREATE PROCEDURE [dbo].[DeductionDemeritPointB1B2Post_Report]            
(            
 @YEAR INT            
,@MONTH INT            
            
)            
AS            
            
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                   
            
SELECT 
 AssetNo
,AssetDescription
,AssetPurchasePrice
,WONo
,UserDept
,RequestDetails
,ResponseCategory
,WorkRequestDate
,StartDateTime
,EndDateTime
,ResponseDateTime
,ResponseDuration
,WorkCompletedDate
,LastDateOf7thDay
,WOStatus
,B1_DeductionFigurePerAsset
,B2_DeductionFigurePerAsset
,ResponseDurationHHMM
,RepairTimeDays
,RepairTimeHours
,DemeritPoint_B1Post
,Validate_Estatus_B1Post
,DemeritPoint_B2Post
,Validate_Estatus_B2Post
,Flag
,DeductionProHawkRM_B1Post
,DeductionEdgentaRM_B1Post
,DeductionProHawkRM_B2Post
,DeductionEdgentaRM_B2Post 
,RemarksB1
,RemarksB2
FROM DeductionDemeritPointB1B2_Base
WHERE YEAR=@YEAR
AND MONTH=@MONTH
            
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END 
GO
