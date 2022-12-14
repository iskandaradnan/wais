USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngContractOutRegisterHistory]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngContractOutRegisterHistory](
	[ContractHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ContractStartDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ContractNo] [nvarchar](50) NULL,
	[AssetId] [int] NULL,
	[ContractType] [int] NULL,
	[ContractValue] [int] NULL,
 CONSTRAINT [PK_EngContractOutRegisterHistory_ContractHistoryId] PRIMARY KEY CLUSTERED 
(
	[ContractHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory] ADD  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterHistory_EngContractOutRegister_ContractId] FOREIGN KEY([ContractId])
REFERENCES [dbo].[EngContractOutRegister] ([ContractId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterHistory_EngContractOutRegister_ContractId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterHistory_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterHistory_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterHistory_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterHistory_MstLocationFacility_FacilityId]
GO
