USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[QAPCarTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QAPCarTxnDet](
	[CarDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CarId] [int] NOT NULL,
	[Activity] [nvarchar](250) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[StartDateUTC] [datetime] NOT NULL,
	[CompletedDate] [datetime] NULL,
	[CompletedDateUTC] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ResponsiblePersonUserId] [int] NULL,
	[TargetDate] [datetime] NULL,
	[ResponsibilityId] [int] NULL,
 CONSTRAINT [PK_QAPCarTxnDet] PRIMARY KEY CLUSTERED 
(
	[CarDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QAPCarTxnDet] ADD  CONSTRAINT [DF_QAPCarTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QAPCarTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[QAPCarTxnDet] CHECK CONSTRAINT [FK_QAPCarTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[QAPCarTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[QAPCarTxnDet] CHECK CONSTRAINT [FK_QAPCarTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[QAPCarTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[QAPCarTxnDet] CHECK CONSTRAINT [FK_QAPCarTxnDet_MstService_ServiceId]
GO
ALTER TABLE [dbo].[QAPCarTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxnDet_QAPCarTxn_CarId] FOREIGN KEY([CarId])
REFERENCES [dbo].[QAPCarTxn] ([CarId])
GO
ALTER TABLE [dbo].[QAPCarTxnDet] CHECK CONSTRAINT [FK_QAPCarTxnDet_QAPCarTxn_CarId]
GO
