USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSFacilityEquipToolsConsumeMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSFacilityEquipToolsConsumeMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ItemCode] [nvarchar](50) NOT NULL,
	[ItemDescription] [nvarchar](100) NULL,
	[ItemType] [nvarchar](20) NULL,
	[Status] [int] NOT NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveToDate] [datetime2](7) NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
