USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_Ds_GetTypeOfPlanner_New]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--drop procedure [Asis_Ds_GetTypeOfPlanner_New]
/*
EXEC Asis_Ds_GetTypeOfPlanner 35
*/
CREATE Procedure [dbo].[Asis_Ds_GetTypeOfPlanner_New]
As
BEGIN
SET NOCOUNT ON  

BEGIN   

 select 'RI' as Lov_Label,'35' as Lov_Value 

END 



SET NOCOUNT OFF                                           
END
GO
