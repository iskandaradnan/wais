USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UserMappingIssue]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserMappingIssue](
	[AssetNo] [nvarchar](50) NOT NULL,
	[MaintenanceWorkNo] [nvarchar](100) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Employee Name] [varchar](60) NULL,
	[Employee ID] [varchar](20) NOT NULL,
	[Location Code] [varchar](16) NOT NULL,
	[TableName] [varchar](10) NOT NULL,
	[Service] [varchar](4) NOT NULL
) ON [PRIMARY]
GO
