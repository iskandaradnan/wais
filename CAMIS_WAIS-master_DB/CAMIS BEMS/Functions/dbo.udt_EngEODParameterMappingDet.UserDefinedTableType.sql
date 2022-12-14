USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngEODParameterMappingDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngEODParameterMappingDet] AS TABLE(
	[ParameterMappingDetId] [int] NULL,
	[ParameterMappingId] [int] NULL,
	[Parameter] [nvarchar](150) NULL,
	[Standard] [nvarchar](150) NULL,
	[UOMId] [int] NULL,
	[DataTypeLovId] [int] NULL,
	[DataValue] [nvarchar](500) NULL,
	[Minimum] [numeric](10, 2) NULL,
	[Maximum] [numeric](10, 2) NULL,
	[FrequencyLovId] [int] NULL,
	[EffectiveFrom] [date] NULL,
	[EffectiveFromUTC] [date] NULL,
	[EffectiveTo] [date] NULL,
	[EffectiveToUTC] [date] NULL,
	[Remarks] [nvarchar](500) NULL,
	[StatusId] [int] NULL
)
GO
