USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngPPMRegisterMst]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngPPMRegisterMst] AS TABLE(
	[PPMId] [int] NULL,
	[ServiceId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[StandardTaskDetId] [int] NULL,
	[PPMChecklistNo] [nvarchar](25) NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[PPMFrequency] [int] NOT NULL,
	[PPMHours] [numeric](24, 2) NULL,
	[BemsTaskCode] [nvarchar](50) NULL,
	[UserId] [int] NULL
)
GO
