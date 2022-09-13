USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_FETC_AutoGenerateCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_FETC_AutoGenerateCode]    
-- exec [dbo].[Sp_CLS_FETC_AutoGenerateCode] 25,25    
@CustomerId int = null,    
@FacilityId int = null    
    
as    
begin    
  -- select * from CLS_FETC  
 IF(EXISTS(SELECT TOP 1 ItemCode FROM CLS_FETC  
   --WHERE CustomerId = @CustomerId and FacilityId = @FacilityId  
    order by FETCId desc))    
 BEGIN    
 SELECT TOP 1 ItemCode FROM CLS_FETC    
 -- WHERE CustomerId = @CustomerId and FacilityId = @FacilityId    
 order by FETCId desc    
 END    
 ELSE    
 BEGIN    
 SELECT 'C001' AS ItemCode    
 END    
    
    
end
GO
