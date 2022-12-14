USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecyclableWasteRecords]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecyclableWasteRecords](
	[RecyclableId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[RRWNo] [int] NOT NULL,
	[TotalWeight] [varchar](100) NULL,
	[CSWRepresentative] [varchar](50) NULL,
	[HospitalRepresentative] [varchar](50) NULL,
	[VendorCode] [varchar](50) NULL,
	[UnitRate] [varchar](50) NULL,
	[TotalAmount] [int] NULL,
	[WasteType] [varchar](50) NULL,
	[TransportationCategory] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[DateTime] [datetime] NULL,
	[MethodofDisposal] [varchar](50) NULL,
	[CSWRepresentativeDesignation] [varchar](50) NULL,
	[HospitalRepresentativeDesignation] [varchar](50) NULL,
	[VendorName] [varchar](50) NULL,
	[ReturnValue] [varchar](50) NULL,
	[InvoiceNoReceiptNo] [varchar](50) NULL,
	[WasteCode] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [Recyclable_PK_Id] PRIMARY KEY CLUSTERED 
(
	[RecyclableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[InvoiceNoReceiptNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RRWNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
