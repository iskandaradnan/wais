USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngWarrantyManagementDefectTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngWarrantyManagementDefectTxn](
	[WarrantyMgmtDDId] [int] IDENTITY(1,1) NOT NULL,
	[WarrantyMgmtId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[DefectDetails] [nvarchar](250) NOT NULL,
	[DefectDate] [datetime] NOT NULL,
	[DefectDateUTC] [datetime] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[StartDateUTC] [datetime] NOT NULL,
	[IsCompleted] [bit] NULL,
	[CompletionDate] [datetime] NULL,
	[ActionTaken] [nvarchar](250) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngWarrantyManagementDefectTxn] PRIMARY KEY CLUSTERED 
(
	[WarrantyMgmtDDId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn] ADD  CONSTRAINT [DF_EngWarrantyManagementDefectTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementDefectTxn_EngWarrantyManagementTxn_WarrantyMgmtId] FOREIGN KEY([WarrantyMgmtId])
REFERENCES [dbo].[EngWarrantyManagementTxn] ([WarrantyMgmtId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementDefectTxn_EngWarrantyManagementTxn_WarrantyMgmtId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementDefectTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementDefectTxn_MstService_ServiceId]
GO
