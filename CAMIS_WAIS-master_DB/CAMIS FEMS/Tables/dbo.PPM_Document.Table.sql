USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[PPM_Document]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPM_Document](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Type_Of_Planner] [varchar](50) NOT NULL,
	[Year] [int] NOT NULL,
	[Week_No] [int] NOT NULL,
	[Start_Date] [datetime] NOT NULL,
	[End_Date] [datetime] NOT NULL,
	[Generated_On] [datetime] NOT NULL,
	[Print_File] [varchar](50) NULL,
	[Uniq] [varchar](50) NULL,
	[FacilityId] [int] NULL,
	[WorkGroup] [int] NULL,
 CONSTRAINT [PK_PPM_Document] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
