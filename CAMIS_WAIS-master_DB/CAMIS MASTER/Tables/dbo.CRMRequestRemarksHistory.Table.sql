USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestRemarksHistory]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestRemarksHistory](
	[CRMRequestRemarksHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CRMRequestId] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[RequestStatus] [int] NULL,
	[RequestStatusValue] [nvarchar](100) NULL,
	[DoneDateUTC] [datetime] NULL,
 CONSTRAINT [PK_CRMRequestRemarksHistory] PRIMARY KEY CLUSTERED 
(
	[CRMRequestRemarksHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestRemarksHistory] ADD  CONSTRAINT [DF_CRMRequestRemarksHistory]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestRemarksHistory]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestRemarksHistory_CRMRequest_CRMRequestId] FOREIGN KEY([CRMRequestId])
REFERENCES [dbo].[CRMRequest] ([CRMRequestId])
GO
ALTER TABLE [dbo].[CRMRequestRemarksHistory] CHECK CONSTRAINT [FK_CRMRequestRemarksHistory_CRMRequest_CRMRequestId]
GO
