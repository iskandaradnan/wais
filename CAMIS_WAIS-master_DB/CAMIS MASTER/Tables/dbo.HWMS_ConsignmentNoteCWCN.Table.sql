USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmentNoteCWCN]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmentNoteCWCN](
	[ConsignmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ConsignmentNoteNo] [nvarchar](100) NULL,
	[DateTime] [datetime] NULL,
	[OnSchedule] [nvarchar](100) NULL,
	[QC] [nvarchar](100) NULL,
	[CWRepresentative] [nvarchar](100) NULL,
	[CWRepresentativeDesignation] [nvarchar](100) NULL,
	[HospitalRepresentative] [nvarchar](100) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](100) NULL,
	[TreatmentPlantName] [nvarchar](100) NULL,
	[Ownership] [nvarchar](100) NULL,
	[VehicleNo] [nvarchar](100) NULL,
	[DriverCode] [nvarchar](100) NULL,
	[DriverName] [nvarchar](100) NULL,
	[TotalNoOfBins] [nvarchar](100) NULL,
	[TotalEst] [nvarchar](100) NULL,
	[Remarks] [nvarchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[TreatmentPlant] [varchar](max) NULL,
 CONSTRAINT [Consignment_PK_Id] PRIMARY KEY CLUSTERED 
(
	[ConsignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
