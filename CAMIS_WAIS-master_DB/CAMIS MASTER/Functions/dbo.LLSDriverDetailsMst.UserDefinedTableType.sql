USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSDriverDetailsMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSDriverDetailsMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DriverCode] [nvarchar](200) NULL,
	[LaundryPlantId] [int] NOT NULL,
	[DriverName] [nvarchar](75) NOT NULL,
	[Status] [int] NOT NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[ContactNo] [nvarchar](150) NULL,
	[ICNo] [nvarchar](20) NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
