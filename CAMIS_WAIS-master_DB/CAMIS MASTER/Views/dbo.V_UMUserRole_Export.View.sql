USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_UMUserRole_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_UMUserRole_Export]
AS
	SELECT		UMRole.UMUserRoleId,
				UMRole.Name AS	UserRole,
				UMType.Name	AS	UserTypeValue,
				LovStatus.FieldValue as StatusValue,
				UMRole.Remarks,
				UMRole.ModifiedDateUTC
	FROM		UMUserRole AS UMRole WITH(NOLOCK)
				INNER JOIN UMUserType AS UMType WITH(NOLOCK) ON UMRole.UserTypeId = UMType.UserTypeId
				INNER JOIN FMLovMst AS LovStatus WITH(NOLOCK) ON UMRole.Status = LovStatus.LovId
	WHERE		UMRole.Active =1
GO
