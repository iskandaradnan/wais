USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetGrouping]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- =============================================

-- Author		: Aravinda Raja 

-- Create date	: 31-05-2018

-- Description	: EngAsset History

-- =============================================



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






CREATE  Procedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetGrouping]

(

@Group_By varchar(50),

@Age_Range varchar(50)

)

As

BEGIN

SET NOCOUNT ON  

Declare @tep_table table

(

	Lov_Label Varchar(50),

	Lov_Value Varchar(50)

)



Insert into @tep_table(Lov_Label,Lov_Value) 

	Values ('All','All'), ('0-5 Years','0-5'),('5-10 Years','5-10'),('10-15 Years','10-15'),('Greater than 15 Years','>15') 



create table  #AssetCategory

(    

Lov_Label Varchar(50),

Lov_Value Varchar(50)

)

BEGIN

	Insert into #AssetCategory(Lov_Label,Lov_Value) 

	Values ('Asset Type','Type'),('Asset Age Range','Age'),('Department','Department'),('Process Status','Condition'),('Variation Status','Variation')                                        

END 

SELECT * FROM #AssetCategory where Lov_Value =@Group_By

SET NOCOUNT OFF                                           

END
GO
