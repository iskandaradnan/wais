USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedSubParameterDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedSubParameterDet](
	[SubParameterDetId] [int] IDENTITY(1,1) NOT NULL,
	[SubParameterId] [int] NOT NULL,
	[SubParameter] [nvarchar](500) NOT NULL,
	[TotalParameterValue] [numeric](24, 2) NOT NULL,
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
 CONSTRAINT [PK_MstDedSubParameterDet] PRIMARY KEY CLUSTERED 
(
	[SubParameterDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedSubParameterDet] ADD  CONSTRAINT [DF_MstDedSubParameterDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstDedSubParameterDet] ADD  CONSTRAINT [DF_MstDedSubParameterDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstDedSubParameterDet] ADD  CONSTRAINT [DF_MstDedSubParameterDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstDedSubParameterDet]  WITH CHECK ADD  CONSTRAINT [FK_MstDedSubParameterDet_MstDedSubParameter_SubParameterId] FOREIGN KEY([SubParameterId])
REFERENCES [dbo].[MstDedSubParameter] ([SubParameterId])
GO
ALTER TABLE [dbo].[MstDedSubParameterDet] CHECK CONSTRAINT [FK_MstDedSubParameterDet_MstDedSubParameter_SubParameterId]
GO
