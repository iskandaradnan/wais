USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARP_Proposal_2]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARP_Proposal_2](
	[ARP Proposal 2 ID] [int] IDENTITY(1,1) NOT NULL,
	[Model] [nvarchar](100) NOT NULL,
	[Brand] [nvarchar](100) NOT NULL,
	[Manufacturer] [nvarchar](100) NOT NULL,
	[Estimation Price(RM)] [int] NOT NULL,
	[Supplier Name] [nvarchar](100) NOT NULL,
	[Contact No] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[Active] [bit] NULL,
	[BuiltIn] [bit] NULL,
	[GuId] [uniqueidentifier] NULL,
	[ARPID] [int] NULL,
 CONSTRAINT [PK_EngARP_Proposal 2] PRIMARY KEY CLUSTERED 
(
	[ARP Proposal 2 ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
