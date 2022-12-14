USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstQAPIndicator]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstQAPIndicator](
	[QAPIndicatorId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[IndicatorCode] [nvarchar](25) NOT NULL,
	[IndicatorDescription] [nvarchar](250) NULL,
	[IndicatorStandard] [numeric](24, 2) NOT NULL,
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
 CONSTRAINT [PK_MstQAPIndicator] PRIMARY KEY CLUSTERED 
(
	[QAPIndicatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstQAPIndicator] ADD  CONSTRAINT [DF_MstQAPIndicator_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstQAPIndicator] ADD  CONSTRAINT [DF_MstQAPIndicator_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstQAPIndicator] ADD  CONSTRAINT [DF_MstQAPIndicator_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstQAPIndicator]  WITH CHECK ADD  CONSTRAINT [FK_MstQAPIndicator_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[MstQAPIndicator] CHECK CONSTRAINT [FK_MstQAPIndicator_MstService_ServiceId]
GO
