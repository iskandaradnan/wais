USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSVehicleDetailsMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSVehicleDetailsMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[VehicleNo] [nvarchar](25) NOT NULL,
	[Model] [nvarchar](50) NULL,
	[Manufacturer] [int] NOT NULL,
	[LaundryPlantId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[EffectiveFrom] [datetime] NOT NULL,
	[EffectiveTo] [datetime] NULL,
	[LoadWeight] [numeric](24, 2) NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
