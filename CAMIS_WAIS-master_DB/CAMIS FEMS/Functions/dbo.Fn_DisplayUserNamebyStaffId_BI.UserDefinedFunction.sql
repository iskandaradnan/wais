USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_DisplayUserNamebyStaffId_BI]    Script Date: 20-09-2021 17:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
CREATE FUNCTION [dbo].[Fn_DisplayUserNamebyStaffId_BI]  
(@id nvarchar(15))    
RETURNS varchar(200)    WITH SCHEMABINDING  
AS    
BEGIN    
declare @Return varchar(200)    
if exists(select COUNT(*) from DBO.UMUserRegistration where UserRegistrationId = @id)    
select @return =StaffName from DBO.UMUserRegistration where UserRegistrationId=@id    
ELSE    
select @return ='No Values Defined'    
RETURN @return    
END  

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
