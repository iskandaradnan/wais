USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedSubParameter]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedSubParameter](
	[SubParameterId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Group] [int] NOT NULL,
	[IndicatorDetId] [int] NOT NULL,
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
 CONSTRAINT [PK_MstDedSubParameter] PRIMARY KEY CLUSTERED 
(
	[SubParameterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedSubParameter] ADD  CONSTRAINT [DF_MstDedSubParameter_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstDedSubParameter] ADD  CONSTRAINT [DF_MstDedSubParameter_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstDedSubParameter] ADD  CONSTRAINT [DF_MstDedSubParameter_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstDedSubParameter]  WITH CHECK ADD  CONSTRAINT [FK_MstDedSubParameter_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[MstDedSubParameter] CHECK CONSTRAINT [FK_MstDedSubParameter_MstService_ServiceId]
GO
