USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[X_typecode]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[X_typecode](
	[NoID] [int] IDENTITY(1,1) NOT NULL,
	[TaskName] [nvarchar](200) NULL,
	[Frequency] [nvarchar](200) NULL,
	[TypeCode] [nvarchar](200) NULL,
	[PreviousTaskCode] [nvarchar](200) NULL,
	[NewTaskCode] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[NoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
