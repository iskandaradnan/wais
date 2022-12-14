USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionKPIReportsandRecordMst_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ---EXEC DedNCRValidationTxnDet_Save 2020,5     
 CREATE PROCEDURE [dbo].[DeductionKPIReportsandRecordMst_Save]     
 (     
 @ReportType VARCHAR(MAX) NULL    
 ,@Frequency INT     
 ,@Remarks VARCHAR(MAX) NULL    
 ,@PIC VARCHAR(MAX) NULL    
 )      
 AS     
 BEGIN       
     
 INSERT INTO KPIReportsandRecordMst     
 (  CustomerId,     
 FacilityId,     
 ServiceId,     
 ReportType,     
 Frequency,     
 Remarks,     
 PIC,     
 CreatedBy,     
 CreatedDate,     
 CreatedDateUTC)      
    
 VALUES    
 (    
 '157', '144', '1', @ReportType, @Frequency, @Remarks, @PIC, '19' ,GETDATE() ,GETUTCDATE()    
 )    
     
 END
GO
