USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionValueMetaData]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionValueMetaData](
	[DedValMetaDataId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CostStart] [numeric](24, 2) NULL,
	[CostEnd] [numeric](24, 2) NULL,
	[DeductionValue] [numeric](24, 2) NULL,
	[B4DeductionValue] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DeductionValueMetaData] PRIMARY KEY CLUSTERED 
(
	[DedValMetaDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeductionValueMetaData] ADD  CONSTRAINT [DF_DeductionValueMetaData_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[DeductionValueMetaData] ADD  CONSTRAINT [DF_DeductionValueMetaData_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[DeductionValueMetaData] ADD  CONSTRAINT [DF_DeductionValueMetaData_GuId]  DEFAULT (newid()) FOR [GuId]
GO
