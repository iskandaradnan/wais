USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[EngNextScheduleDateCalc]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Function Name		: [EngNextScheduleDateCalc]
Description			: To Get the data from table EngAssetTypeCodeStandardTasks using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
select dbo.[EngNextScheduleDateCalc](3,'2018-04-04 20:07:14.030')

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE FUNCTION [dbo].[EngNextScheduleDateCalc]
(
@IntervalinWeeks INT =1,
@NextScheduleDate DATETIME)
RETURNS DATETIME
AS 
BEGIN
		
		SET @NextScheduleDate=DATEADD(DAY,(@IntervalinWeeks*7),@NextScheduleDate)

		RETURN @NextScheduleDate
END
GO
