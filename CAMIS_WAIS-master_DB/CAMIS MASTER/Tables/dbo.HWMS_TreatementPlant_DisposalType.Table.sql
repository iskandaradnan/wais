USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TreatementPlant_DisposalType]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TreatementPlant_DisposalType](
	[DisposalTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MethodofDisposal] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[DesignCapacity] [nvarchar](50) NULL,
	[LicensedCapacity] [nvarchar](50) NULL,
	[Unit] [nvarchar](50) NULL,
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
ALTER TABLE [dbo].[HWMS_TreatementPlant_DisposalType]  WITH CHECK ADD FOREIGN KEY([TreatmentPlantId])
REFERENCES [dbo].[HWMS_TreatementPlant] ([TreatmentPlantId])
GO
