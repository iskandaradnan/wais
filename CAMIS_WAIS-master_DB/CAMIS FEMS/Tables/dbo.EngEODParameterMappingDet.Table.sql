USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODParameterMappingDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODParameterMappingDet](
	[ParameterMappingDetId] [int] IDENTITY(1,1) NOT NULL,
	[ParameterMappingId] [int] NOT NULL,
	[Parameter] [nvarchar](150) NULL,
	[Standard] [nvarchar](150) NULL,
	[UOMId] [int] NULL,
	[DataTypeLovId] [int] NULL,
	[DataValue] [nvarchar](500) NULL,
	[Minimum] [numeric](10, 2) NULL,
	[Maximum] [numeric](10, 2) NULL,
	[FrequencyLovId] [int] NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveFromUTC] [date] NOT NULL,
	[EffectiveTo] [date] NULL,
	[EffectiveToUTC] [date] NULL,
	[Remarks] [nvarchar](500) NULL,
	[ParameterMappingMetaDetId] [int] NULL,
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
	[StatusId] [int] NULL,
 CONSTRAINT [PK_EngEODParameterMappingDet] PRIMARY KEY CLUSTERED 
(
	[ParameterMappingDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODParameterMappingDet] ADD  CONSTRAINT [DF_EngEODParameterMappingDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngEODParameterMappingDet] ADD  CONSTRAINT [DF_EngEODParameterMappingDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngEODParameterMappingDet] ADD  CONSTRAINT [DF_EngEODParameterMappingDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODParameterMappingDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMappingDet_EngEODParameterMapping_ParameterMappingId] FOREIGN KEY([ParameterMappingId])
REFERENCES [dbo].[EngEODParameterMapping] ([ParameterMappingId])
GO
ALTER TABLE [dbo].[EngEODParameterMappingDet] CHECK CONSTRAINT [FK_EngEODParameterMappingDet_EngEODParameterMapping_ParameterMappingId]
GO
