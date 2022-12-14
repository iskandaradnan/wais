USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[vwLLSTotalWeightbyMonthDaySummary]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwLLSTotalWeightbyMonthDaySummary]  
AS  
SELECT        *  
FROM            (SELECT        MONTH, MONTHNAME, Description, WEIGHT, DATE  
                          FROM            vwLLSTotalWeightbyMonthDay) src PIVOT (SUM(WEIGHT) FOR DATE IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31]))  
                          Piv  
GO
