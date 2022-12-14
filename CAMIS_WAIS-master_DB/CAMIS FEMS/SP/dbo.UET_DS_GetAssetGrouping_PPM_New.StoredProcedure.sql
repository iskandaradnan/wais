USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UET_DS_GetAssetGrouping_PPM_New]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec GetAssetGrouping_PPM
create  Procedure [dbo].[UET_DS_GetAssetGrouping_PPM_New]
@Group_By varchar(MAX)
As
BEGIN
SET NOCOUNT ON  
create table  #AssetCategory  
(    
Lov_Label Varchar(50),
	Lov_Value Varchar(50)
	
)
BEGIN   
	Insert into #AssetCategory(Lov_Label,Lov_Value) 
	Values --('Department','Department'),('Work Group','Workgroup'),
	('Task Code','Taskcode')                                       
END 
SELECT Lov_Label FROM #AssetCategory where Lov_Value = @Group_By
SET NOCOUNT OFF                                           
END
GO
