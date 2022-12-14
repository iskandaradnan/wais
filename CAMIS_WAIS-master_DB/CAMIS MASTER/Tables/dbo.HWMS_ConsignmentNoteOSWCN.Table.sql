USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmentNoteOSWCN]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmentNoteOSWCN](
	[ConsignmentOSWCNId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ConsignmentNoteNo] [nvarchar](30) NULL,
	[DateTime] [datetime] NULL,
	[TotalEst] [int] NULL,
	[TotalNoofPackaging] [int] NULL,
	[OSWRepresentative] [nvarchar](30) NULL,
	[OSWRepresentativeDesignation] [nvarchar](30) NULL,
	[HospitalRepresentative] [nvarchar](30) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](30) NULL,
	[TreatmentPlant] [nvarchar](30) NULL,
	[Ownership] [nvarchar](30) NULL,
	[VehicleNo] [nvarchar](30) NULL,
	[DriverName] [nvarchar](30) NULL,
	[WasteType] [nvarchar](30) NULL,
	[WasteCode] [nvarchar](30) NULL,
	[ChargeRM] [int] NULL,
	[ReturnValueRM] [int] NULL,
	[TransportationCategory] [nvarchar](30) NULL,
	[TotalWeight] [nvarchar](30) NULL,
	[Remarks] [nvarchar](100) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ConsignmentOSWCNId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
