USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[BemsLevelMst]    Script Date: 20-09-2021 17:00:54 ******/
CREATE TYPE [dbo].[BemsLevelMst] AS TABLE(
	[LevelId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[LevelCode] [nvarchar](50) NOT NULL,
	[LevelName] [nvarchar](50) NOT NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[UserId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL
)
GO
