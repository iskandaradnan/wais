USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetMalaysiaDateTime]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetMalaysiaDateTime]  
(
	@pDateTime DATETIME
)  
RETURNS DATETIME
AS  
	BEGIN  
		DECLARE @Return DATETIME
		SET @Return= (SELECT CONVERT(datetimeoffset, @pDateTime) AT TIME ZONE 'Singapore Standard Time' )
		RETURN @Return  
	END
GO
