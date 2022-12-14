USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_Typeid]    Script Date: 20-09-2021 17:05:51 ******/
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

CREATE  Procedure [dbo].[uspFM_EngAsset_History_Rpt_Typeid]
(
@Group_By varchar(50),
@TypeId varchar(50)
)
As
BEGIN
SET NOCOUNT ON  

if(@Group_By='Type')
	select  AssetTypeCode as  TypeCode,'TypeCode' AS TypeName  from EngAssetTypeCode where AssetTypeCodeId = @TypeId
else if((@Group_By='Condition') and (@TypeId='1111'))
	select 'Good' as  TypeCode,'Process_Status' AS TypeName
else if(@Group_By='Condition')
  select @TypeId as TypeCode,'Process_Status' AS TypeName 
else if(@Group_By='Variation')
   select distinct dbo.Fn_DisplayNameofLov(VariationStatus) as  TypeCode,'Variation_Status' AS TypeName from VmVariationTxn  where VariationStatus = @TypeId  
else if(@Group_By='age')
   select @TypeId as  TypeCode,'Asset_Age' AS TypeName
END
GO
