USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_QRCodeUserLocation]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[udt_QRCodeUserLocation] AS TABLE(
	[QRCodeUserLocationId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[BlockId] [int] NULL,
	[LevelId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[QRCodeSize1] [varbinary](max) NULL,
	[QRCodeSize2] [varbinary](max) NULL,
	[QRCodeSize3] [varbinary](max) NULL,
	[QRCodeSize4] [varbinary](max) NULL,
	[QRCodeSize5] [varbinary](max) NULL
)
GO
