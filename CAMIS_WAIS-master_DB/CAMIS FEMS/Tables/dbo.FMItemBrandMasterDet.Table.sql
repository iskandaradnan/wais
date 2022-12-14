USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FMItemBrandMasterDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMItemBrandMasterDet](
	[ItemBrandId] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
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
 CONSTRAINT [PK_GIBMMDItemBrandId] PRIMARY KEY CLUSTERED 
(
	[ItemBrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMItemBrandMasterDet] ADD  CONSTRAINT [DF_FMItemBrandMasterDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[FMItemBrandMasterDet] ADD  CONSTRAINT [DF_FMItemBrandMasterDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[FMItemBrandMasterDet] ADD  CONSTRAINT [DF_FMItemBrandMasterDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FMItemBrandMasterDet]  WITH CHECK ADD  CONSTRAINT [FK_FMItemBrandMasterDet_FMItemMaster_DocumentId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[FMItemMaster] ([ItemId])
GO
ALTER TABLE [dbo].[FMItemBrandMasterDet] CHECK CONSTRAINT [FK_FMItemBrandMasterDet_FMItemMaster_DocumentId]
GO
