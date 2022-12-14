USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSWeighingScaleMst]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSWeighingScaleMst](
	[WeighingScaleId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[IssuedBy] [nvarchar](100) NOT NULL,
	[ItemDescription] [nvarchar](255) NULL,
	[SerialNo] [nvarchar](100) NULL,
	[IssuedDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LLSWeighingScaleMst] PRIMARY KEY CLUSTERED 
(
	[WeighingScaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSWeighingScaleMst] ADD  CONSTRAINT [DF_LLSWeighingScaleMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
