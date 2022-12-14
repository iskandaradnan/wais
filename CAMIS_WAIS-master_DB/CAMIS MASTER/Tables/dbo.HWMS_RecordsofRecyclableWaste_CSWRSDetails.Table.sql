USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecordsofRecyclableWaste_CSWRSDetails]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecordsofRecyclableWaste_CSWRSDetails](
	[CSWRSId] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaCode] [varchar](50) NULL,
	[UserAreaName] [varchar](50) NULL,
	[CSWRSNo] [varchar](50) NULL,
	[RecyclableId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_RecordsofRecyclableWaste_CSWRSDetails]  WITH CHECK ADD FOREIGN KEY([RecyclableId])
REFERENCES [dbo].[HWMS_RecordsofRecyclableWaste_Save] ([RecyclableId])
GO
