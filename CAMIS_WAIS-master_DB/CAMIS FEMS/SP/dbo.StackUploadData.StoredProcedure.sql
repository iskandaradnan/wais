USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[StackUploadData]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[StackUploadData]

@StockUpdateNo nvarchar(50)=NULL,
@FacilityCode nvarchar(50),
@PartNo nvarchar(50),
@PartDescription nvarchar(250),
@SparePartType nvarchar(50),
@ItemNo nvarchar(50),
@ItemDescription nvarchar(50),
@EstimatedLifeSpanInHours numeric(10,2),
@PartSourceId int

AS

BEGIN TRY

	CREATE TABLE #resultTable
	(
		StockUpdateId int NULL,
		CreatedBy int,
		CreatedDate DateTime,
		CreatedDateUTC DateTime,
	)

	IF(@StockUpdateNo is not null)
		BEGIN
			select StockUpdateId,CreatedBy,CreatedDate,CreatedDateUTC 
			from EngStockUpdateRegisterTxn where StockUpdateNo = @StockUpdateNo

			select a.SparePartsId,a.PartNo,a.PartDescription,a.SparePartType,
			b.ItemId,b.ItemNo,b.ItemDescription,a.EstimatedLifeSpanInHours,a.PartSourceId
			INTO #listDetail from EngSpareParts a
			inner join FMItemMaster b on a.ItemId = b.ItemId
			inner join FMLovMst c on a.SparePartType = c.LovId
			inner join FMLovMst d on a.PartSourceId = c.LovId
			where PartNo = @PartNo and PartDescription = @PartDescription and c.FieldValue = @SparePartType
			and b.ItemNo = @ItemNo and b.ItemDescription = @ItemDescription and a.EstimatedLifeSpanInHours = @EstimatedLifeSpanInHours
			and d.FieldValue = @PartSourceId

			DECLARE @Count int = (select Count(*) #listDetail);

			if(@Count = 0)
			BEGIN
				SELECT 0 As StockUpdateId,
				CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
				'Part No and Invoice No should be unique' AS ErrorMessage
			END

		END
	ELSE
		BEGIN
			select StockUpdateId,CreatedBy,CreatedDate,CreatedDateUTC 
			from EngStockUpdateRegisterTxn where StockUpdateNo = @StockUpdateNo
		END



select * from EngStockUpdateRegisterTxn where StockUpdateNo = @StockUpdateNo
select * from MstLocationFacility where FacilityCode = @FacilityCode
select a.SparePartsId,a.PartNo,a.PartDescription,a.SparePartType,b.ItemId,b.ItemNo,b.ItemDescription,a.EstimatedLifeSpanInHours,a.PartSourceId,* from EngSpareParts a
inner join FMItemMaster b on a.ItemId = b.ItemId
 where PartNo = 'prt21'

select * from FMLovMst where FieldValue = @SparePartType

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH

--EXEC StackUploadDate 'BEMS/PAN101/201807/000017','PAN101','236','Inventory'
GO
