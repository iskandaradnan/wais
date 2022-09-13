

CREATE TABLE [dbo].[ReportLogo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FacilityId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[Logo1] [varbinary](max) NULL,
	[Logo2] [varbinary](max) NULL,
	[Logo3] [varbinary](max) NULL,
	[Logo4] [varbinary](max) NULL,
 CONSTRAINT [PK_ReportLogo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportLogo] ADD  CONSTRAINT [DF_ReportLogo_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [dbo].[ReportLogo] ADD  CONSTRAINT [DF_ReportLogo_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO


