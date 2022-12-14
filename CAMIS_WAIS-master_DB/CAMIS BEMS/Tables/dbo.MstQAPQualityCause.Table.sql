USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstQAPQualityCause]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstQAPQualityCause](
	[QualityCauseId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CauseCode] [nvarchar](25) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
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
 CONSTRAINT [PK_MstQapQualityCause] PRIMARY KEY CLUSTERED 
(
	[QualityCauseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstQAPQualityCause] ADD  CONSTRAINT [DF_MstQapQualityCause_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstQAPQualityCause] ADD  CONSTRAINT [DF_MstQapQualityCause_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstQAPQualityCause] ADD  CONSTRAINT [DF_MstQapQualityCause_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstQAPQualityCause]  WITH CHECK ADD  CONSTRAINT [FK_MstQAPQualityCause_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[MstQAPQualityCause] CHECK CONSTRAINT [FK_MstQAPQualityCause_MstService_ServiceId]
GO
