USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[DedExempAssetLogBI]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedExempAssetLogBI](
	[ExemptAssetLogid] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NULL,
	[AssetId] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DedExempAssetLogBI] PRIMARY KEY CLUSTERED 
(
	[ExemptAssetLogid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DedExempAssetLogBI] ADD  CONSTRAINT [DF_DedExempAssetLogBI_GuId]  DEFAULT (newid()) FOR [GuId]
GO
