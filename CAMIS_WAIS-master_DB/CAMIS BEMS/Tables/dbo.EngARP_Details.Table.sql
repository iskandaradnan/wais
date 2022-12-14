USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngARP_Details]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngARP_Details](
	[ARPID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[FacilityID] [int] NULL,
	[BERno] [nvarchar](50) NULL,
	[ConditionAppraisalNo] [nvarchar](50) NULL,
	[AssetNo] [nvarchar](50) NULL,
	[AssetName] [nvarchar](50) NULL,
	[AssetTypeDescription] [nvarchar](250) NULL,
	[DepartmentNameID] [int] NULL,
	[LocationNameID] [int] NULL,
	[ApplicationDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NULL,
	[SelectedProposal] [int] NULL,
	[Justification] [nvarchar](500) NULL,
	[BERRemarks] [nvarchar](500) NULL,
	[ARP_Proposal_ID] [int] NULL,
	[AssetID] [int] NULL,
	[Quantity] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ARPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
