USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DedNCRValidationTxnDet11012021]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedNCRValidationTxnDet11012021](
	[DedNCRValidationDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DedNCRValidationId] [int] NOT NULL,
	[CRMRequestId] [int] NULL,
	[RequestNo] [nvarchar](100) NULL,
	[RequestDateTime] [datetime] NULL,
	[AssetId] [int] NULL,
	[AssetNo] [nvarchar](100) NULL,
	[DemeritPoint] [int] NULL,
	[FinalDemeritPoint] [int] NULL,
	[DisputedDemeritPoints] [int] NULL,
	[IsValid] [bit] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[DeductionValue] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[IndicatorDetId] [int] NULL,
	[FileName] [nvarchar](250) NULL,
	[RemarksJOHN] [nvarchar](1000) NULL,
	[Completed_Date] [datetime] NULL
) ON [PRIMARY]
GO
