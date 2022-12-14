USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedIndicatorDet11012021]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedIndicatorDet11012021](
	[IndicatorDetId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorId] [int] NOT NULL,
	[IndicatorNo] [nvarchar](25) NOT NULL,
	[IndicatorName] [nvarchar](4000) NULL,
	[IndicatorDesc] [nvarchar](4000) NULL,
	[IndicatorType] [int] NOT NULL,
	[Weightage] [numeric](24, 2) NULL,
	[Frequency] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ServiceId] [int] NULL,
	[ServiceNo] [nvarchar](50) NULL
) ON [PRIMARY]
GO
