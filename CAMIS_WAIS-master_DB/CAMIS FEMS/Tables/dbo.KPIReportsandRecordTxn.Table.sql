USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordTxn](
	[ReportsandRecordTxnId] [int] IDENTITY(1,1) NOT NULL,
	[FacilityId] [int] NULL,
	[CustomerId] [int] NULL,
	[Month] [int] NULL,
	[Year] [int] NULL,
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
	[Submitted] [bit] NULL,
	[Verified] [bit] NULL,
 CONSTRAINT [PK_KPIReportsandRecordTxn] PRIMARY KEY CLUSTERED 
(
	[ReportsandRecordTxnId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn] ADD  CONSTRAINT [DF_KPIReportsandRecordTxn_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn] ADD  CONSTRAINT [DF_KPIReportsandRecordTxn_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn] ADD  CONSTRAINT [DF_KPIReportsandRecordTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn]  WITH CHECK ADD  CONSTRAINT [FK_KPIReportsandRecordTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn] CHECK CONSTRAINT [FK_KPIReportsandRecordTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn]  WITH CHECK ADD  CONSTRAINT [FK_KPIReportsandRecordTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxn] CHECK CONSTRAINT [FK_KPIReportsandRecordTxn_MstLocationFacility_FacilityId]
GO
