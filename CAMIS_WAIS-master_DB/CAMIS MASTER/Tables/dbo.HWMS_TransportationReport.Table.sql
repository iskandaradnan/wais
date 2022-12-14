USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TransportationReport]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TransportationReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NULL,
	[Month] [varchar](max) NULL,
	[Company] [varchar](max) NULL,
	[Hospital] [varchar](max) NULL,
	[ConsignmentNote] [varchar](max) NULL,
	[Date] [datetime] NULL,
	[QCValue] [varchar](max) NULL,
	[VehicleNumber] [varchar](max) NULL,
	[DriverName] [varchar](max) NULL,
	[OnSchedule] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
