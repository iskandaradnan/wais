USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetStatus]    Script Date: 20-09-2021 16:43:00 ******/
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








CREATE  Procedure [dbo].[uspFM_EngAsset_History_Rpt_GetAssetStatus](@Asset_Status varchar(20))

As

BEGIN

SET NOCOUNT ON  

select 

	'' as Lov_Label ,

	'' as Lov_Value 

	



                                    

END
GO
