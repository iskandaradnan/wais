USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecyclableWasteRecord]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecyclableWasteRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RRWNo] [nvarchar](max) NULL,
	[TotalWeight] [nvarchar](max) NULL,
	[CSWRepresentative] [nvarchar](max) NULL,
	[HospitalRepresentative] [nvarchar](max) NULL,
	[VendorCode] [nvarchar](max) NULL,
	[UnitRate] [nvarchar](max) NULL,
	[TotalAmount] [nvarchar](max) NULL,
	[WasteType] [nvarchar](max) NULL,
	[TransportationCategory] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[DateTime] [datetime] NULL,
	[MethodofDisposal] [nvarchar](max) NULL,
	[CSWRepresentativeDesignation] [nvarchar](max) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](max) NULL,
	[VendorName] [nvarchar](max) NULL,
	[ReturnValue] [nvarchar](max) NULL,
	[InvoiceNoReceiptNo] [nvarchar](max) NULL,
	[WasteCode] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[UserAreaCode] [varchar](max) NULL,
	[UserAreaName] [varchar](max) NULL,
	[CSWRSNo] [varchar](max) NULL,
 CONSTRAINT [PK_HWMS_RecyclableWasteRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
