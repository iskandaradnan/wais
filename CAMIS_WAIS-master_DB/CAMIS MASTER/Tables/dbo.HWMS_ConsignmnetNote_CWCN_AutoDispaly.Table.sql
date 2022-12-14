USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmnetNote_CWCN_AutoDispaly]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmnetNote_CWCN_AutoDispaly](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ConsignmnetNote] [varchar](max) NULL,
	[DateTime] [datetime] NULL,
	[DwrNo] [varchar](max) NULL,
	[OnSchedule] [varchar](max) NULL,
	[Qc] [varchar](max) NULL,
	[CwRepresentative] [varchar](max) NULL,
	[CwRepresentativeDesignation] [varchar](max) NULL,
	[HospitalRepresentative] [varchar](max) NULL,
	[HospitalRepresentativeDesignation] [varchar](max) NULL,
	[TreatmentPlant] [varchar](max) NULL,
	[OwnerShip] [varchar](max) NULL,
	[VehicleNo] [varchar](max) NULL,
	[DriverCode] [varchar](max) NULL,
	[DriverName] [varchar](max) NULL,
	[TotalNoOfBins] [varchar](max) NULL,
	[TotalEst] [varchar](max) NULL,
	[Remarks] [varchar](max) NULL,
	[DwrsNo] [varchar](max) NULL,
	[BinNo] [varchar](max) NULL,
	[BinWeight] [varchar](max) NULL,
	[Remarks_Bin] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
