USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedIndicator]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedIndicator](
	[IndicatorId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Group] [int] NOT NULL,
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
 CONSTRAINT [PK_MstDedIndicator] PRIMARY KEY CLUSTERED 
(
	[IndicatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedIndicator] ADD  CONSTRAINT [DF_MstDedIndicator_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstDedIndicator] ADD  CONSTRAINT [DF_MstDedIndicator_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstDedIndicator] ADD  CONSTRAINT [DF_MstDedIndicator_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstDedIndicator]  WITH CHECK ADD  CONSTRAINT [FK_MstDedIndicator_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[MstDedIndicator] CHECK CONSTRAINT [FK_MstDedIndicator_MstService_ServiceId]
GO
