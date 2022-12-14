USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsumablesReceptaclesItems]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsumablesReceptaclesItems](
	[ItemCodeId] [int] IDENTITY(1,1) NOT NULL,
	[ItemCode] [nvarchar](30) NULL,
	[ItemName] [nvarchar](30) NULL,
	[ItemType] [nvarchar](30) NULL,
	[Size] [nvarchar](30) NULL,
	[UOM] [nvarchar](30) NULL,
	[ConsumablesId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL,
 CONSTRAINT [PK_HWMS_ConsumablesReceptaclesFields] PRIMARY KEY CLUSTERED 
(
	[ItemCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_ConsumablesReceptaclesItems]  WITH CHECK ADD  CONSTRAINT [Consumables_FK_Id] FOREIGN KEY([ConsumablesId])
REFERENCES [dbo].[HWMS_ConsumablesReceptacles] ([ConsumablesId])
GO
ALTER TABLE [dbo].[HWMS_ConsumablesReceptaclesItems] CHECK CONSTRAINT [Consumables_FK_Id]
GO
