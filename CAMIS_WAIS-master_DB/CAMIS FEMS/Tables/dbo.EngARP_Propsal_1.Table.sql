USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARP_Propsal_1]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARP_Propsal_1](
	[ARP Proposal 1 ID] [int] IDENTITY(1,1) NOT NULL,
	[Model] [nvarchar](100) NOT NULL,
	[Brand] [nvarchar](100) NOT NULL,
	[Manufacturer] [nvarchar](100) NOT NULL,
	[Estimation Price(RM)] [int] NOT NULL,
	[Supplier Name] [nvarchar](100) NOT NULL,
	[Contact No] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[Active] [bit] NULL,
	[Builtin] [bit] NULL,
	[GuId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EngARP_Propsal1] PRIMARY KEY CLUSTERED 
(
	[ARP Proposal 1 ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
