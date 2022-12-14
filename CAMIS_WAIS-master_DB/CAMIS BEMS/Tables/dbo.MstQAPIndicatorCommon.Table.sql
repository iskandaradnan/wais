USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstQAPIndicatorCommon]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstQAPIndicatorCommon](
	[IndicatorCGId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[QIndicatorId] [int] NOT NULL,
	[CarId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[ExceptedPercentage] [numeric](6, 2) NOT NULL,
	[ActualPercentage] [numeric](6, 2) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[TotalCount] [numeric](18, 2) NULL,
	[ExceptionCount] [numeric](18, 2) NULL,
	[FromDate] [datetime] NULL,
	[FromDateUTC] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[ToDateUTC] [datetime] NULL,
	[PassedCount] [numeric](18, 2) NULL,
	[TotalAssetCount] [numeric](18, 2) NULL,
	[PassedAssetCount] [numeric](18, 2) NULL,
	[ExceptionAssetCount] [numeric](18, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MstQAPIndicatorCommon] PRIMARY KEY CLUSTERED 
(
	[IndicatorCGId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstQAPIndicatorCommon] ADD  CONSTRAINT [DF_MstQAPIndicatorCommon_GuId]  DEFAULT (newid()) FOR [GuId]
GO
