USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCentralCleanLinenStoreMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCentralCleanLinenStoreMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[StoreType] [nvarchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
