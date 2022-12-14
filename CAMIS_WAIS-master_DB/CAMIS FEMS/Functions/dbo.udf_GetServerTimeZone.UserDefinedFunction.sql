USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetServerTimeZone]    Script Date: 20-09-2021 17:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[udf_GetServerTimeZone]  
(
	@pDateTime DATETIME
)  
RETURNS DATETIME
AS  
BEGIN  

DECLARE @Return DATETIME,@UTCoffset varchar(50)
select top 1  @UTCoffset= UTCOffset from FMConfigTimeZone  where isenable=1

set @Return = DATEADD(mi,DATEDIFF(mi,TODATETIMEOFFSET(@pDateTime,@UTCoffset),@pDateTime),@pDateTime)

	
	--SET @Return= (SELECT CONVERT(datetimeoffset, @pDateTime) AT TIME ZONE 'Singapore Standard Time' )
	RETURN @Return  
END
GO
