USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLaundryPlantMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLaundryPlantMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LaundryPlantCode] [nvarchar](30) NOT NULL,
	[LaundryPlantName] [nvarchar](150) NOT NULL,
	[Ownership] [int] NOT NULL,
	[Capacity] [decimal](10, 2) NOT NULL,
	[ContactPerson] [nvarchar](150) NULL,
	[Status] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
