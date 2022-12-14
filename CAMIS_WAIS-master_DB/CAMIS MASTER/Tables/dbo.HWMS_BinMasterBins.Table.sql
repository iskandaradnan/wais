USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_BinMasterBins]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_BinMasterBins](
	[BinNoId] [int] IDENTITY(1,1) NOT NULL,
	[BinMasterId] [int] NOT NULL,
	[BinNo] [varchar](30) NULL,
	[Manufacturer] [varchar](50) NULL,
	[Weight] [varchar](50) NULL,
	[OperationDate] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[DisposedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_BinMasterBins]  WITH CHECK ADD  CONSTRAINT [Bin_FK_Idno] FOREIGN KEY([BinMasterId])
REFERENCES [dbo].[HWMS_BinMaster] ([BinMasterId])
GO
ALTER TABLE [dbo].[HWMS_BinMasterBins] CHECK CONSTRAINT [Bin_FK_Idno]
GO
