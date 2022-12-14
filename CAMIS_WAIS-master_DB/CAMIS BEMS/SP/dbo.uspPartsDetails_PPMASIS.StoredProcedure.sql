USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspPartsDetails_PPMASIS]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop proc PartsDetails_PPMASIS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		
-- Create date: 28-06-2017
-- Description:	uspPartsDetails_PPMASIS
---Exec dbo.PartsDetails_PPMASIS 96
-- =============================================
CREATE PROCEDURE [dbo].[uspPartsDetails_PPMASIS]
	
	@WorkOrderId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
sparepart.PartNo
,sparepart.PartDescription
,(select FieldValue from  FMLovMst where  lovid=sparepart.UnitOfMeasurement) as uom
,partreplacement.Cost
,partreplacement.Quantity
from 
engmwopartreplacementtxn partreplacement  
Left outer join	EngSpareParts  sparepart  
ON sparepart.SparePartsId=partreplacement.SparePartStockRegisterId
where partreplacement.WorkOrderId=@WorkOrderId 
END
GO
