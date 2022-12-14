USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARP_Final_Proposal]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARP_Final_Proposal](
	[ARP Final Proposal ID] [int] IDENTITY(1,1) NOT NULL,
	[Selected Proposal] [nvarchar](100) NULL,
	[Justification] [nvarchar](500) NULL,
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
 CONSTRAINT [PK_EngARP_Final Proposal] PRIMARY KEY CLUSTERED 
(
	[ARP Final Proposal ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
