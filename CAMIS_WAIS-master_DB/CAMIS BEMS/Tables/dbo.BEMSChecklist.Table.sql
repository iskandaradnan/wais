USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[BEMSChecklist]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BEMSChecklist](
	[ServiceId] [float] NULL,
	[AssetTypeCodeId] [float] NULL,
	[PPMChecklistNo] [nvarchar](255) NULL,
	[ManufacturerId] [float] NULL,
	[ModelId] [float] NULL,
	[PPMFrequency] [float] NULL,
	[PpmHours] [nvarchar](255) NULL,
	[SpecialPrecautions] [nvarchar](255) NULL,
	[DoneBy] [nvarchar](255) NULL,
	[Remarks] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedBy] [float] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [float] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [nvarchar](255) NULL,
	[Active] [float] NULL,
	[BuiltIn] [float] NULL,
	[TaskCode] [nvarchar](255) NULL,
	[TaskDescription] [nvarchar](255) NULL,
	[VersionNo] [nvarchar](255) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[AssetTypeCode] [nvarchar](255) NULL
) ON [PRIMARY]
GO
