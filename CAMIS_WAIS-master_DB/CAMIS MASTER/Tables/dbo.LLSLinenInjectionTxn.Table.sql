USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenInjectionTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenInjectionTxn](
	[LinenInjectionId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[InjectionDate] [datetime] NOT NULL,
	[DONo] [nvarchar](500) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[PONo] [nvarchar](50) NULL,
	[DODate] [datetime] NULL,
 CONSTRAINT [PK_LLSLinenInjectionTxn] PRIMARY KEY CLUSTERED 
(
	[LinenInjectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenInjectionTxn] ADD  CONSTRAINT [DF__LLSLinenIn__GuId__422E8D3E]  DEFAULT (newid()) FOR [GuId]
GO
