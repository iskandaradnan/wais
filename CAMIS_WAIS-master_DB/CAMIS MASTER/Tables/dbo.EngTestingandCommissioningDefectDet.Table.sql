USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngTestingandCommissioningDefectDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTestingandCommissioningDefectDet](
	[DefectId] [int] IDENTITY(1,1) NOT NULL,
	[TestingandCommissioningId] [int] NULL,
	[ContractorId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[AssetId] [int] NULL,
	[DefectNo] [nvarchar](100) NULL,
	[DefectDate] [datetime] NOT NULL,
	[DefectDateUTC] [datetime] NOT NULL,
	[ReferenceNo] [nvarchar](25) NULL,
	[ProjectDetails] [nvarchar](510) NULL,
	[ClosedDateTime] [datetime] NULL,
	[ClosedDateTimeUTC] [datetime] NULL,
	[Defecttype] [int] NULL,
	[DefectFlag] [int] NOT NULL,
	[WarrantyEndDate] [datetime] NULL,
	[WarrantyEndDateUTC] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngTestingandCommissioningDefectDet] PRIMARY KEY CLUSTERED 
(
	[DefectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningDefectDet] ADD  CONSTRAINT [DF_EngTestingandCommissioningDefectDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
