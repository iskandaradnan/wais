USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstContractorandVendorSpecialization]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstContractorandVendorSpecialization](
	[SpecializationId] [int] IDENTITY(1,1) NOT NULL,
	[Specialization] [nvarchar](250) NOT NULL,
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
 CONSTRAINT [PK_MstContractorandVendorSpecialization] PRIMARY KEY CLUSTERED 
(
	[SpecializationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstContractorandVendorSpecialization] ADD  CONSTRAINT [DF_MstContractorandVendorSpecialization_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstContractorandVendorSpecialization] ADD  CONSTRAINT [DF_MstContractorandVendorSpecialization_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstContractorandVendorSpecialization] ADD  CONSTRAINT [DF_MstContractorandVendorSpecialization_GuId]  DEFAULT (newid()) FOR [GuId]
GO
