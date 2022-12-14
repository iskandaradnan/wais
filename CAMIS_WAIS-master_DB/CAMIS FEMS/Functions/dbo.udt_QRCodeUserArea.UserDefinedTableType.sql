USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_QRCodeUserArea]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_QRCodeUserArea] AS TABLE(
	[QRCodeUserAreaId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[BlockId] [int] NULL,
	[LevelId] [int] NULL,
	[UserAreaId] [int] NULL,
	[QRCodeSize1] [varbinary](max) NULL,
	[QRCodeSize2] [varbinary](max) NULL,
	[QRCodeSize3] [varbinary](max) NULL,
	[QRCodeSize4] [varbinary](max) NULL,
	[QRCodeSize5] [varbinary](max) NULL,
	[BatchGenerated] [nvarchar](200) NULL
)
GO
