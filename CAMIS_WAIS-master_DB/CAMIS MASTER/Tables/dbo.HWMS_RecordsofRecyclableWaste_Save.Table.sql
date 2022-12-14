USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecordsofRecyclableWaste_Save]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecordsofRecyclableWaste_Save](
	[RecyclableId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[RRWNo] [nvarchar](50) NULL,
	[TotalWeight] [float] NULL,
	[CSWRepresentative] [nvarchar](50) NULL,
	[HospitalRepresentative] [nvarchar](50) NULL,
	[VendorCode] [nvarchar](50) NULL,
	[UnitRate] [float] NULL,
	[TotalAmount] [float] NULL,
	[WasteType] [nvarchar](50) NULL,
	[TransportationCategory] [nvarchar](50) NULL,
	[Remarks] [nvarchar](50) NULL,
	[DateTime] [datetime] NULL,
	[MethodofDisposal] [nvarchar](50) NULL,
	[CSWRepresentativeDesignation] [nvarchar](50) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](50) NULL,
	[VendorName] [nvarchar](50) NULL,
	[ReturnValue] [float] NULL,
	[InvoiceNoReceiptNo] [nvarchar](50) NULL,
	[WasteCode] [nvarchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RecyclableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
