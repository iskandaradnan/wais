USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[BemsBlockMst]    Script Date: 20-09-2021 17:00:54 ******/
CREATE TYPE [dbo].[BemsBlockMst] AS TABLE(
	[BlockId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockCode] [nvarchar](50) NOT NULL,
	[BlockName] [nvarchar](50) NOT NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[UserId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL
)
GO
