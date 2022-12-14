---Penchal
--20-09-2021

--UetrackMasterdbPreProd
-----------------
V_CRMRequest
uspFM_CRMRequest_GetAll
uspFM_CRMRequest_GetById
uspFM_CRMRequest_Save
uspFM_Dropdown

begin tran
SET IDENTITY_INSERT [dbo].[FMLovMst] ON 
GO
INSERT [dbo].[FMLovMst] ([LovId], [ModuleName], [ScreenName], [FieldName], [LovKey], [FieldCode], [FieldValue], [Remarks], [ParentId], [SortNo], [IsDefault], [IsEditable], [CreatedBy], [CreatedDate], [CreatedDateUTC], [ModifiedBy], [ModifiedDate], [ModifiedDateUTC], [Active], [BuiltIn], [GuId], [LovType]) 
VALUES (10809, N'BEMS', N'CRM', N'CRMRequestType', N'CRMRequestTypeValue', N'25', N'Unsheduled Maintenance', N'Unsheduled Maintenance', NULL, 0, 0, 0, 19, CAST(N'2021-09-05 02:09:25.710' AS DateTime), CAST(N'2021-09-05 02:09:25.710' AS DateTime), 2, CAST(N'2021-09-05 02:09:25.710' AS DateTime), CAST(N'2021-09-05 02:09:25.710' AS DateTime), 1, 1, N'60c257f1-33d4-4bde-87ce-a11e934d7a9b', 302)
GO

SET IDENTITY_INSERT [dbo].[FMLovMst] OFF
GO
Rollback

-----------------
ALTER TABLE crmRequest ADD  [Requested_Date] [datetime] NULL

--UetrackBemsdbPreProd
uspFM_CRMRequest_GetById
uspFM_CRMRequest_Save_Master

ALTER TABLE crmRequest ADD  [Requested_Date] [datetime] NULL

--UetrackFemsdbPreProd
uspFM_CRMRequest_GetById
uspFM_CRMRequest_Save_Master

ALTER TABLE crmRequest ADD  [Requested_Date] [datetime] NULL