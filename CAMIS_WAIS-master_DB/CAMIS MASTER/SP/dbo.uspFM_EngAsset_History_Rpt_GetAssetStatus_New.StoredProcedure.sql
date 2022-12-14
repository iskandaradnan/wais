USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetStatus_New]    Script Date: 20-09-2021 16:43:00 ******/
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



CREATE  Procedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetStatus_New](@Asset_Status varchar(20))
As
BEGIN
SET NOCOUNT ON  
create table  #AssetStatus  
(    
	Lov_Label Varchar(50),
	Lov_Value Varchar(50)
	
)
BEGIN   
	Insert into #AssetStatus(Lov_Label,Lov_Value) 
	Values ('Active','127'),('Inactive','128'),('All','All')                                      
END 
SELECT Lov_Label,Lov_Value FROM #AssetStatus where  Lov_Value=@Asset_Status
                                    
END
GO
