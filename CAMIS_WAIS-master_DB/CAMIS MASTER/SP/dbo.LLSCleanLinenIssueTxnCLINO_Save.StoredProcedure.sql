USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxnCLINO_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxnCLINO_Save]    
@ID AS INT  
AS    
BEGIN    
    
DECLARE @VAR1 INT    
SET @VAR1=(SELECT MAX(CleanLinenIssueId) FROM LLSCleanLinenIssueTxn A INNER JOIN LLSCleanLinenRequestTxn B ON A.CleanLinenRequestId=B.CleanLinenRequestId WHERE B.CleanLinenRequestId=@ID)    
    
    
SELECT CLINO FROM LLSCleanLinenIssueTxn    
WHERE CleanLinenIssueId=@VAR1    
    
END
GO
