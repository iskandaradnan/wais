USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstLocationFacilityContactInfo]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_MstLocationFacilityContactInfo] AS TABLE(
	[FacilityContactInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Designation] [nvarchar](200) NULL,
	[ContactNo] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
	[UserId] [int] NULL,
	[Active] [bit] NULL
)
GO
