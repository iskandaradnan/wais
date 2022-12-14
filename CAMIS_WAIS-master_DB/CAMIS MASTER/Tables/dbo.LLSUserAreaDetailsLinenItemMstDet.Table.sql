USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSUserAreaDetailsLinenItemMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSUserAreaDetailsLinenItemMstDet](
	[LLSUserAreaLinenItemId] [int] IDENTITY(1,1) NOT NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[UserLocationId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
	[Par1] [numeric](24, 2) NOT NULL,
	[Par2] [numeric](24, 2) NOT NULL,
	[DefaultIssue] [int] NOT NULL,
	[AgreedShelfLevel] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[ParTotal] [int] NULL
) ON [PRIMARY]
GO
