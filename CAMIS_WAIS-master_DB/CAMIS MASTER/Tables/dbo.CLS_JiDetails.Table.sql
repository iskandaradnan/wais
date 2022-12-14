USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_JiDetails]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_JiDetails](
	[DetailsId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[DateTime] [datetime] NULL,
	[UserAreaCode] [nvarchar](80) NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[HospitalRepresentative] [nvarchar](100) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](80) NULL,
	[CompanyRepresentative] [nvarchar](100) NULL,
	[CompanyRepresentativeDesignation] [nvarchar](80) NULL,
	[Remarks] [nvarchar](80) NULL,
	[ReferenceNo] [nvarchar](80) NULL,
	[Satisfactory] [int] NULL,
	[NoofUserLocation] [int] NULL,
	[UnSatisfactory] [int] NULL,
	[GrandTotalElementsInspected] [int] NULL,
	[NotApplicable] [int] NULL,
	[IsSubmitted] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
