USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestDet]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestDet](
	[CRMRequestDetId] [int] IDENTITY(1,1) NOT NULL,
	[CRMRequestId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CRMRequestDet] PRIMARY KEY CLUSTERED 
(
	[CRMRequestDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestDet] ADD  CONSTRAINT [DF_CRMRequestDet]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestDet]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestDet_CRMRequest_CRMRequestId] FOREIGN KEY([CRMRequestId])
REFERENCES [dbo].[CRMRequest] ([CRMRequestId])
GO
ALTER TABLE [dbo].[CRMRequestDet] CHECK CONSTRAINT [FK_CRMRequestDet_CRMRequest_CRMRequestId]
GO
