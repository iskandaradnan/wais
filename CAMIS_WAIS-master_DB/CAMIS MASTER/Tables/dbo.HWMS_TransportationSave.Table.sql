USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TransportationSave]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TransportationSave](
	[TransportationCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[HospitalCode] [nvarchar](100) NULL,
	[HospitalName] [nvarchar](100) NULL
) ON [PRIMARY]
GO
