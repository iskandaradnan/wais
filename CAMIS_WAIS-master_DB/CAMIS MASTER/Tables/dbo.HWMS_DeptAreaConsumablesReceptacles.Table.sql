USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DeptAreaConsumablesReceptacles]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DeptAreaConsumablesReceptacles](
	[ReceptaclesId] [int] IDENTITY(1,1) NOT NULL,
	[WasteType] [nvarchar](50) NULL,
	[ItemCode] [nvarchar](50) NULL,
	[ItemName] [nvarchar](50) NULL,
	[Size] [nvarchar](50) NULL,
	[UOM] [nvarchar](50) NULL,
	[ShelfLevelQuantity] [nvarchar](50) NULL,
	[DeptAreaId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL,
 CONSTRAINT [PK_HWMS_DeptAreaDetailsConsumablesReceptacles] PRIMARY KEY CLUSTERED 
(
	[ReceptaclesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
