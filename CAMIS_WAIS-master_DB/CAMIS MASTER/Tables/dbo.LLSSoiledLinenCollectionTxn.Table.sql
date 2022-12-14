USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSSoiledLinenCollectionTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSSoiledLinenCollectionTxn](
	[SoiledLinenCollectionId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[CollectionDate] [datetime] NOT NULL,
	[LaundryPlantId] [int] NOT NULL,
	[DespatchDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[Guid] [uniqueidentifier] NULL,
 CONSTRAINT [PK_LLSSoiledLinenCollectionTxnNew] PRIMARY KEY CLUSTERED 
(
	[SoiledLinenCollectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSSoiledLinenCollectionTxn]  WITH CHECK ADD  CONSTRAINT [FK_LLSSoiledLinenCollectionTxn_LLSLaundryPlantFacilityMstNew] FOREIGN KEY([LaundryPlantId])
REFERENCES [dbo].[LLSLaundryPlantMst] ([LaundryPlantId])
GO
ALTER TABLE [dbo].[LLSSoiledLinenCollectionTxn] CHECK CONSTRAINT [FK_LLSSoiledLinenCollectionTxn_LLSLaundryPlantFacilityMstNew]
GO
