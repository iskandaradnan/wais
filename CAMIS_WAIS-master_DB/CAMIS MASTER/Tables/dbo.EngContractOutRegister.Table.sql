USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngContractOutRegister]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngContractOutRegister](
	[ContractId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[ContractorId] [int] NOT NULL,
	[ContractStartDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
	[AResponsiblePerson] [nvarchar](100) NULL,
	[APersonDesignation] [nvarchar](100) NULL,
	[AContactNumber] [nvarchar](30) NULL,
	[AFaxNo] [nvarchar](30) NULL,
	[ScopeofWork] [nvarchar](500) NULL,
	[Remarks] [nvarchar](500) NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsRenewedPreviously] [bit] NULL,
	[NotificationForInspection] [datetime] NULL,
 CONSTRAINT [PK_EngContractOutRegister] PRIMARY KEY CLUSTERED 
(
	[ContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngContractOutRegister] ADD  CONSTRAINT [DF_EngContractOutRegister_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngContractOutRegister]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegister_MstContractorandVendor_ContractorId] FOREIGN KEY([ContractorId])
REFERENCES [dbo].[MstContractorandVendor] ([ContractorId])
GO
ALTER TABLE [dbo].[EngContractOutRegister] CHECK CONSTRAINT [FK_EngContractOutRegister_MstContractorandVendor_ContractorId]
GO
ALTER TABLE [dbo].[EngContractOutRegister]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegister_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngContractOutRegister] CHECK CONSTRAINT [FK_EngContractOutRegister_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngContractOutRegister]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegister_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngContractOutRegister] CHECK CONSTRAINT [FK_EngContractOutRegister_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngContractOutRegister]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegister_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngContractOutRegister] CHECK CONSTRAINT [FK_EngContractOutRegister_MstService_ServiceId]
GO
