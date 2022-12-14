USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_ToiletInspectionTxn_Loc]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_ToiletInspectionTxn_Loc](
	[ToiletLocationId] [int] IDENTITY(1,1) NOT NULL,
	[ToiletInspectionId] [int] NOT NULL,
	[LocationCode] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[Mirror] [bit] NULL,
	[Floor] [bit] NULL,
	[Wall] [bit] NULL,
	[Urinal] [bit] NULL,
	[Bowl] [bit] NULL,
	[Basin] [bit] NULL,
	[ToiletRoll] [bit] NULL,
	[SoapDispenser] [bit] NULL,
	[AutoAirFreshner] [bit] NULL,
	[Waste] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ToiletLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_ToiletInspectionTxn_Loc]  WITH CHECK ADD  CONSTRAINT [FK_ToiletInspectionId] FOREIGN KEY([ToiletInspectionId])
REFERENCES [dbo].[CLS_ToiletInspectionTxn] ([ToiletInspectionId])
GO
ALTER TABLE [dbo].[CLS_ToiletInspectionTxn_Loc] CHECK CONSTRAINT [FK_ToiletInspectionId]
GO
