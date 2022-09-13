USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_EquipmentReport]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_EquipmentReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EquipmentCode] [nvarchar](max) NULL,
	[EquipmentDescription] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
