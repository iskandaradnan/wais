USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DisplayHospitalName]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[udf_DisplayHospitalName]
(
	@Id NVARCHAR(15)
)
	RETURNS VARCHAR(MAX)   --WITH SCHEMABINDING 
	AS	
	BEGIN  
	DECLARE @Return VARCHAR(MAX)  
	IF EXISTS	(	SELECT COUNT(*) 
					FROM MstLocationFacility 
					WHERE FacilityId = @Id
				)  
		SELECT @Return =FacilityName 
		FROM MstLocationFacility 
		WHERE FacilityId=@Id  
	ELSE  

		SELECT @Return ='No Values Defined'  
		RETURN @Return  
	END
GO
