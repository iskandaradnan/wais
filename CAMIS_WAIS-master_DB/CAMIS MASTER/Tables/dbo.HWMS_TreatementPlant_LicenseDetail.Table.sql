USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TreatementPlant_LicenseDetail]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TreatementPlant_LicenseDetail](
	[LicenseCodeId] [int] IDENTITY(1,1) NOT NULL,
	[LicenseCode] [nvarchar](50) NULL,
	[LicenseDescription] [nvarchar](50) NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[Class] [nvarchar](50) NULL,
	[IssueDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[TreatmentPlantId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_TreatementPlant_LicenseDetail]  WITH CHECK ADD FOREIGN KEY([TreatmentPlantId])
REFERENCES [dbo].[HWMS_TreatementPlant] ([TreatmentPlantId])
GO
