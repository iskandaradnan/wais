USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DailyWeighingRecord]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DailyWeighingRecord](
	[DWRId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[DWRNo] [varchar](30) NULL,
	[TotalWeight] [float] NULL,
	[Date] [datetime] NULL,
	[TotalBags] [int] NULL,
	[TotalNoofBins] [int] NULL,
	[HospitalRepresentative] [varchar](100) NULL,
	[ConsignmentNo] [int] NULL,
	[Status] [varchar](30) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
 CONSTRAINT [DWRId_PK] PRIMARY KEY CLUSTERED 
(
	[DWRId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
