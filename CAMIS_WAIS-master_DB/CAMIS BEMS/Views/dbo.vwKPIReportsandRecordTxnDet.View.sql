USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTxnDet]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwKPIReportsandRecordTxnDet]
AS
SELECT        dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId, dbo.KPIReportsandRecordMst.ReportType, dbo.KPIReportsandRecordTxn.Month, dbo.KPIReportsandRecordTxn.Year, dbo.KPIReportsandRecordMst.SubmissionDate, 
                         dbo.KPIReportsandRecordTxnDet.Submitted, dbo.KPIReportsandRecordTxnDet.SubmittedDate, dbo.KPIReportsandRecordTxnDet.Uploaded, dbo.KPIReportsandRecordTxnDet.IsApplicable, 
                         dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnDetId, dbo.KPIReportsandRecordMst.Remarks, dbo.KPIReportsandRecordMst.PIC, dbo.KPIReportsandRecordTxnDet.CustomerReportId, 
                         dbo.KPIReportsandRecordTxnDet.Verified, dbo.KPIReportsandRecordTxnDet.Approved, dbo.KPIReportsandRecordTxnDet.Rejected, dbo.KPIReportsandRecordTxnDet.VerifiedDate, 
                         dbo.KPIReportsandRecordTxn.Status AS StatusId, FMLovMst_1.FieldValue AS Status, dbo.KPIReportsandRecordMst.Frequency AS FrequencyId, B.FieldValue AS Frequency, dbo.KPIReportsandRecordTxnDet.Justification, 
                         dbo.KPIReportsandRecordTxnDet.SubmissionDueDate
FROM            dbo.KPIReportsandRecordMst INNER JOIN
                         uetrackMasterdbPreProd.dbo.FMLovMst AS B ON dbo.KPIReportsandRecordMst.Frequency = B.LovId RIGHT OUTER JOIN
                         dbo.KPIReportsandRecordTxn INNER JOIN
                         dbo.KPIReportsandRecordTxnDet ON dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId = dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnId LEFT OUTER JOIN
                         uetrackMasterdbPreProd.dbo.FMLovMst AS FMLovMst_1 ON dbo.KPIReportsandRecordTxn.Status = FMLovMst_1.LovId ON dbo.KPIReportsandRecordMst.CustomerReportId = dbo.KPIReportsandRecordTxnDet.CustomerReportId
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "KPIReportsandRecordMst"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 445
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KPIReportsandRecordTxn"
            Begin Extent = 
               Top = 6
               Left = 483
               Bottom = 136
               Right = 698
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KPIReportsandRecordTxnDet"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FMLovMst_1"
            Begin Extent = 
               Top = 6
               Left = 736
               Bottom = 136
               Right = 919
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Colu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwKPIReportsandRecordTxnDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'mn = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwKPIReportsandRecordTxnDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwKPIReportsandRecordTxnDet'
GO
