USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARP_Propsal]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARP_Propsal](
	[ARP_Proposal_ID] [int] IDENTITY(1,1) NOT NULL,
	[ARPID] [int] NULL,
	[PROP_ID] [int] NULL,
	[CustomerID] [int] NULL,
	[FacilityID] [int] NULL,
	[Model] [nvarchar](100) NOT NULL,
	[Brand] [nvarchar](100) NOT NULL,
	[Manufacturer] [nvarchar](100) NOT NULL,
	[EstimationPrice] [int] NOT NULL,
	[SupplierName] [nvarchar](100) NOT NULL,
	[ContactNo] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[Active] [bit] NULL,
	[Builtin] [bit] NULL,
	[GuId] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[ARP_Proposal_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
