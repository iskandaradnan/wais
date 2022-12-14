USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[StackUploadDate]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StackUploadDate]

@StockUpdateNo nvarchar(50),
@FacilityCode nvarchar(50),
@PartNo nvarchar(50),
@SparePartType nvarchar(50)

as
begin
select * from EngStockUpdateRegisterTxn where StockUpdateNo = @StockUpdateNo
select * from MstLocationFacility where FacilityCode = @FacilityCode
select a.SparePartsId,a.PartNo,a.PartDescription,a.SparePartType,b.ItemId,b.ItemNo,b.ItemDescription,a.EstimatedLifeSpanInHours,a.PartSourceId,* from EngSpareParts a
inner join FMItemMaster b on a.ItemId = b.ItemId
 where PartNo = 'prt21'

select * from FMLovMst where FieldValue = @SparePartType
end

EXEC StackUploadDate 'BEMS/PAN101/201807/000017','PAN101','236','Inventory'
GO
