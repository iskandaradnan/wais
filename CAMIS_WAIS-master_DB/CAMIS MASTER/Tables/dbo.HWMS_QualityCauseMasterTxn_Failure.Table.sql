USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_QualityCauseMasterTxn_Failure]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_QualityCauseMasterTxn_Failure](
	[QualityId] [int] IDENTITY(1,1) NOT NULL,
	[QualityCauseMasterId] [int] NULL,
	[FailureType] [varchar](50) NULL,
	[FailureRootCauseCode] [varchar](500) NULL,
	[Details] [varchar](50) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_QualityCauseMasterTxn_Failure]  WITH CHECK ADD  CONSTRAINT [QualityCause_FK_Idno] FOREIGN KEY([QualityCauseMasterId])
REFERENCES [dbo].[HWMS_QualityCauseMasterTxn] ([QualityCauseMasterId])
GO
ALTER TABLE [dbo].[HWMS_QualityCauseMasterTxn_Failure] CHECK CONSTRAINT [QualityCause_FK_Idno]
GO
