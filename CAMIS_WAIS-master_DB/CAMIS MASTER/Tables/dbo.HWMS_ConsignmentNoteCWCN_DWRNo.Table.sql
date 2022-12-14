USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmentNoteCWCN_DWRNo]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmentNoteCWCN_DWRNo](
	[DWRNoId] [int] IDENTITY(1,1) NOT NULL,
	[ConsignmentId] [int] NULL,
	[DWRDocId] [int] NULL,
	[BinNo] [varchar](100) NULL,
	[Weight] [float] NULL,
	[Remarks_Bin] [varchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteCWCN_DWRNo]  WITH CHECK ADD  CONSTRAINT [consignment_FK_Idno] FOREIGN KEY([ConsignmentId])
REFERENCES [dbo].[HWMS_ConsignmentNoteCWCN] ([ConsignmentId])
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteCWCN_DWRNo] CHECK CONSTRAINT [consignment_FK_Idno]
GO
