USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBITBLContractCreation]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBITBLContractCreation](
	[AssetId] [int] NULL,
	[ContractId] [int] NULL,
	[ContractStartDate] [datetime] NULL,
	[ContractEndDate] [datetime] NULL,
	[ContractExpireStatus] [varchar](50) NULL
) ON [PRIMARY]
GO
