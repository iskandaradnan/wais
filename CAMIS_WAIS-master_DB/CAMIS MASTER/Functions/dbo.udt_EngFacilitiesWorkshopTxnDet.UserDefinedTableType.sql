USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngFacilitiesWorkshopTxnDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngFacilitiesWorkshopTxnDet] AS TABLE(
	[FacilitiesWorkshopDetId] [int] NULL,
	[FacilitiesWorkshopId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[AssetId] [int] NULL,
	[Description] [nvarchar](510) NULL,
	[Manufacturer] [nvarchar](1000) NULL,
	[Model] [nvarchar](1000) NULL,
	[SerialNo] [nvarchar](1000) NULL,
	[CalibrationDueDate] [datetime] NULL,
	[CalibrationDueDateUTC] [datetime] NULL,
	[Location] [int] NULL,
	[Quantity] [int] NULL,
	[SizeArea] [numeric](18, 0) NULL,
	[UserId] [int] NULL
)
GO
