USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngEODCaptureTxnDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngEODCaptureTxnDet] AS TABLE(
	[CaptureDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CaptureId] [int] NULL,
	[ParameterMappingDetId] [int] NULL,
	[ParamterValue] [nvarchar](150) NULL,
	[Standard] [nvarchar](250) NULL,
	[Minimum] [numeric](24, 2) NULL,
	[Maximum] [numeric](24, 2) NULL,
	[ActualValue] [nvarchar](250) NULL,
	[Status] [int] NULL,
	[UOMId] [int] NULL
)
GO
