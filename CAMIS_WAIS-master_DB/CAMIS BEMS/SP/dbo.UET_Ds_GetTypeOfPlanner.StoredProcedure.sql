USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UET_Ds_GetTypeOfPlanner]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

EXEC UET_Ds_GetTypeOfPlanner 30

*/

CREATE Procedure [dbo].[UET_Ds_GetTypeOfPlanner](@Planner_Classification Varchar(50))

As

BEGIN

SET NOCOUNT ON  

create table  #planner_type  

(    

Lov_Label Varchar(50),

	Lov_Value int

	

)

BEGIN   

	Insert into #planner_type(Lov_Label,Lov_Value) 

 select fieldvalue,case when lovid=35 then 30 else lovid end lovid from FMLovMst

where LovKey='PlannerClassificationValue' 



END 

SELECT * FROM #planner_type  where Lov_Value=@Planner_Classification



DROP TABLE #planner_type

SET NOCOUNT OFF                                           

END
GO
