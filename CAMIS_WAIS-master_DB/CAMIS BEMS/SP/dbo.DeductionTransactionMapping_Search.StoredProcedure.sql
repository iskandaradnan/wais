USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionTransactionMapping_Search]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
--EXEC DeductionTransactionMapping_Search 1,2020,5                
          
CREATE PROCEDURE [dbo].[DeductionTransactionMapping_Search]                  
(                  
@Indicator INT                  
,@Year INT                  
,@Month INT           
,@Search NVARCHAR(50) = NULL        
        
)                  
AS                  
BEGIN                  
SELECT  CustomerId          
,FacilityId          
,DedTxnMappingId          
,DedTxnMappingDetId        
,Date          
,DocumentNo          
,Details          
,AssetNo          
,AssetDescription          
,ScreenName          
,DemeritPoint          
,FinalDemeritPoint          
,DisputedDemeritPoints          
,IsValid          
,Remarks    
,RemarksJOHN
,FileName  
,DeductionValue          
,FinalDeductionValue          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,Year          
,Month          
,IndicatorDetId          
,IndicatorName          
,Flag          
,UptimeAchieved          
,PurchaseCost          
,DeductionFigureperAsset          
,NameofReport          
,SubmissionDueDate          
,DateSubmitted          
,Frequency          
,ScheduledDate          
,ReScheduledDate          
,StartDate          
,TypeCode          
,TRPIUptime FROM  DedTransactionMappingTxnDet WHERE Year =@Year AND Month =@Month AND IndicatorDetId =@Indicator   AND DemeritPoint <> '0'          
        
AND (        
((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND (DocumentNo LIKE + '%' + @Search + '%'  OR DocumentNo LIKE + '%' + @Search + '%' )))        
        
----HERE @Search BEHAVES AS COMMON SEARCH PARAMETER FOR ALL THE FILEDS        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( Details LIKE + '%' + @Search + '%'  OR Details LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( AssetNo LIKE + '%' + @Search + '%'  OR AssetNo LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( AssetDescription LIKE + '%' + @Search + '%'  OR AssetDescription LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( TypeCode LIKE + '%' + @Search + '%'  OR TypeCode LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( NameofReport LIKE + '%' + @Search + '%'  OR NameofReport LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( Frequency LIKE + '%' + @Search + '%'  OR Frequency LIKE + '%' + @Search + '%' )))        
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( IsValid LIKE + '%' + @Search + '%'  OR IsValid LIKE + '%' + @Search + '%' )))      
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( Remarks LIKE + '%' + @Search + '%'  OR Remarks LIKE + '%' + @Search + '%' )))   
OR ((ISNULL(@Search,'') = '' ) OR (ISNULL(@Search,'') <> '' AND ( RemarksJOHN LIKE + '%' + @Search + '%'  OR RemarksJOHN LIKE + '%' + @Search + '%' )))   

)        
        
        
ORDER BY Date          
        
        
END                   
                  
        
        
        
GO
