USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetPriority]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspFM_GetPriority]  
AS    
BEGIN    
    -- SET NOCOUNT ON added to prevent extra result sets from    
    -- interfering with SELECT statements.    
    SET NOCOUNT ON    
    
    -- Insert statements for procedure here    
 SELECT CRMRequest_PriorityId as LovId,Priority_Type_Description as FieldValue,'PriorityList' as LovKey,0 as IsDefault FROM CRMRequest_Priority    
     
END
GO
