USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_AutoGenaratedCAR]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:      <VENU GOPAL KADIYALA>  
-- ALTER Date: <ALTER Date, , >  
-- Description: <Description, , >  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_CLS_AutoGenaratedCAR]   
-- EXEC [dbo].[Sp_CLS_AutoGenaratedCAR]   
  
  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
 
 
 DECLARE @CurrentYearMonth VARCHAR(6)
 DECLARE @FirstDateOfLastMonth DATETIME  
 DECLARE @LastOfLastMonth DATETIME  
 DECLARE @IndicatorPersentage DECIMAL  
 DECLARE @RowCount INT, @RowNumber INT = 1  
 DECLARE @CustomerId INT, @FacilityId INT  
 DECLARE @NoOfExistsRecordsForCurrentMonth INT = 0
  
 SET @FirstDateOfLastMonth = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)  
 SET @LastOfLastMonth = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)  
 SET @CurrentYearMonth = CONVERT(VARCHAR(6), GETDATE(), 112)
 SELECT @FirstDateOfLastMonth, @LastOfLastMonth  
 
 SELECT @NoOfExistsRecordsForCurrentMonth = COUNT(1) FROM CLS_CorrectiveActionReport WHERE CARNo LIKE '%' + @CurrentYearMonth + '%'
   
 -- SELECT CONVERT(DATE, [DateTime])  FROM [CLS_JiDetails] WHERE CONVERT(DATE, [DateTime]) < @FirstDateOfLastMonth  
  
 IF OBJECT_ID(N'tempdb..#TEMPCustomerFacility') IS NOT NULL  
 BEGIN  
 DROP TABLE #TEMPCustomerFacility  
 END  
  
 SELECT ROW_NUMBER() OVER(ORDER BY [CustomerId]) AS RowNum, [CustomerId], [FacilityId] INTO #TEMPCustomerFacility FROM [CLS_JiDetails]   
 WHERE CONVERT(DATE, [DateTime]) >= @FirstDateOfLastMonth and  CONVERT(DATE, [DateTime]) <= @LastOfLastMonth  
 GROUP BY [CustomerId], [FacilityId]  
  
 SELECT @RowCount = COUNT(1) FROM #TEMPCustomerFacility  
  
 WHILE @RowNumber <= @RowCount  
 BEGIN  
  
  SELECT @CustomerId = [CustomerId], @FacilityId = [FacilityId] FROM #TEMPCustomerFacility WHERE RowNum = @RowNumber  
    
  SELECT @IndicatorPersentage = CONVERT(DECIMAL(18,2), SUM([Satisfactory]) * 100.00 / SUM([GrandTotalElementsInspected]) )  
  FROM [CLS_JiDetails] WHERE [CustomerId] = @CustomerId AND [FacilityId] = @FacilityId AND   
  [DateTime] >= @FirstDateOfLastMonth AND [DateTime] <= @LastOfLastMonth  
  
  SELECT @IndicatorPersentage  
  
  IF(@IndicatorPersentage < (SELECT IndicatorStandard FROM CLS_IndicatorMaster WHERE IndicatorNo = 'C1'))  
  BEGIN   
   INSERT INTO CLS_CorrectiveActionReport ( [CustomerId], [FacilityId], [CARGeneration], [CARNo], [Indicator], [CARDate], [CARPeriodFrom],  
   [CARPeriodTo], [FollowUpCAR], [Assignee],[ProblemStatement], [RootCause],[Solution],[Priority],[Status],[Issuer],[CARTargetDate],  
   [VerifiedDate],[VerifiedBy],[Remarks] )        
  
   VALUES(25, 25, 'Auto CAR', 'CAR/WAC/C' + CONVERT(VARCHAR(6), GETDATE(), 112) + '/' + RIGHT('0000000' + Convert(varchar, @NoOfExistsRecordsForCurrentMonth + @RowNumber), 6),   
   'C1', GETDATE(), @FirstDateOfLastMonth , @LastOfLastMonth , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)   
  END  
  
 SET @RowNumber = @RowNumber + 1   
  
 END  
        
 DROP TABLE #TEMPCustomerFacility  
     
    
  -- SELECT * FROM CLS_CorrectiveActionReport  
  
  
END
GO
