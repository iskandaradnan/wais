USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[DedGenerationTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedGenerationTxn](
	[DedGenerationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Group] [int] NULL,
	[MonthlyServiceFee] [numeric](24, 2) NULL,
	[DeductionStatus] [char](1) NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DedGenerationTxn] PRIMARY KEY CLUSTERED 
(
	[DedGenerationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DedGenerationTxn] ADD  CONSTRAINT [DF_DedGenerationTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[DedGenerationTxn]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[DedGenerationTxn] CHECK CONSTRAINT [FK_DedGenerationTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[DedGenerationTxn]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[DedGenerationTxn] CHECK CONSTRAINT [FK_DedGenerationTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[DedGenerationTxn]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[DedGenerationTxn] CHECK CONSTRAINT [FK_DedGenerationTxn_MstService_ServiceId]
GO
