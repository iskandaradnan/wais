USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedIndicatorDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedIndicatorDet](
	[IndicatorDetId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorId] [int] NOT NULL,
	[IndicatorNo] [nvarchar](25) NOT NULL,
	[IndicatorName] [nvarchar](4000) NULL,
	[IndicatorDesc] [nvarchar](4000) NULL,
	[IndicatorType] [int] NOT NULL,
	[Weightage] [numeric](24, 2) NULL,
	[Frequency] [int] NULL,
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
	[ServiceId] [int] NULL,
	[ServiceNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_MstDedIndicatorDet] PRIMARY KEY CLUSTERED 
(
	[IndicatorDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedIndicatorDet] ADD  CONSTRAINT [DF_MstDedIndicatorDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstDedIndicatorDet] ADD  CONSTRAINT [DF_MstDedIndicatorDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstDedIndicatorDet] ADD  CONSTRAINT [DF_MstDedIndicatorDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstDedIndicatorDet]  WITH CHECK ADD  CONSTRAINT [FK_MstDedIndicatorDet_MstDedIndicator_IndicatorId] FOREIGN KEY([IndicatorId])
REFERENCES [dbo].[MstDedIndicator] ([IndicatorId])
GO
ALTER TABLE [dbo].[MstDedIndicatorDet] CHECK CONSTRAINT [FK_MstDedIndicatorDet_MstDedIndicator_IndicatorId]
GO
