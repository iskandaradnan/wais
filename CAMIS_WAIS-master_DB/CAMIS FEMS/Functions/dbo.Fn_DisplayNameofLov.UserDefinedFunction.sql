USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_DisplayNameofLov]    Script Date: 20-09-2021 17:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fn_DisplayNameofLov]  
(@id nvarchar(15))  
RETURNS varchar(MAX)   WITH SCHEMABINDING 
AS  
BEGIN  
declare @Return varchar(MAX)  
IF(ISNUMERIC(@id) = 1)
BEGIN
   SELECT @id=@id
END
ELSE 
BEGIN
select @return ='No Values Defined'  
RETURN @return  
END

if exists(select COUNT(*) from DBO.FMLovMst  (nolock) where LovId =  @id)
select @return =FieldValue from DBO.FMLovMst (nolock) where LovId= @id  
ELSE  
select @return ='No Values Defined'  
RETURN @return  
end
GO
