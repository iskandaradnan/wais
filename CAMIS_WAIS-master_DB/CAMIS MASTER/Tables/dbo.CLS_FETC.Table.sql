USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_FETC]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_FETC](
	[FETCId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemDescription] [varchar](100) NULL,
	[ItemType] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Status] [int] NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_FETC] ADD  CONSTRAINT [DF_CLS_FETC_Quantity]  DEFAULT ((0)) FOR [Quantity]
GO
