USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_FacilitiesEquipment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_FacilitiesEquipment](
	[FetcId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemDescription] [varchar](100) NULL,
	[ItemType] [varchar](50) NULL,
	[Status] [int] NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
) ON [PRIMARY]
GO
