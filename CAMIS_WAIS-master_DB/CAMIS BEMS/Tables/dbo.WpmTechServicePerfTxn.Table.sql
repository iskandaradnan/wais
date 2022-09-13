USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[WpmTechServicePerfTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WpmTechServicePerfTxn](
	[TechServicePerfId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Month] [int] NULL,
	[Year] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TechServicePerfId] PRIMARY KEY CLUSTERED 
(
	[TechServicePerfId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn] ADD  CONSTRAINT [DF_WpmTechServicePerfTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn] CHECK CONSTRAINT [FK_WpmTechServicePerfTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn] CHECK CONSTRAINT [FK_WpmTechServicePerfTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxn] CHECK CONSTRAINT [FK_WpmTechServicePerfTxn_MstService_ServiceId]
GO
