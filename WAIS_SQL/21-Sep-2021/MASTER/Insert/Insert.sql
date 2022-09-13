begin tran
SET IDENTITY_INSERT [dbo].[FMLovMst] ON 
GO
INSERT [dbo].[FMLovMst] ([LovId], [ModuleName], [ScreenName], [FieldName], [LovKey], [FieldCode], [FieldValue], [Remarks], [ParentId], [SortNo], [IsDefault], [IsEditable], [CreatedBy], [CreatedDate], [CreatedDateUTC], [ModifiedBy], [ModifiedDate], [ModifiedDateUTC], [Active], [BuiltIn], [GuId], [LovType]) 
VALUES (10809, N'BEMS', N'CRM', N'CRMRequestType', N'CRMRequestTypeValue', N'25', N'Unsheduled Maintenance', N'Unsheduled Maintenance', NULL, 0, 0, 0, 19, CAST(N'2021-09-05 02:09:25.710' AS DateTime), CAST(N'2021-09-05 02:09:25.710' AS DateTime), 2, CAST(N'2021-09-05 02:09:25.710' AS DateTime), CAST(N'2021-09-05 02:09:25.710' AS DateTime), 1, 1, N'60c257f1-33d4-4bde-87ce-a11e934d7a9b', 302)
GO

SET IDENTITY_INSERT [dbo].[FMLovMst] OFF
GO
Rollback