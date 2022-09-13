USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CompanyRepresentative]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CompanyRepresentative]
@StaffMasterId int
as
begin
SELECT Designation FROM UserDesignation where userDesignationId in
( select userDesignationId from UMUserRegistration where UserRegistrationId = @StaffMasterId)
end
GO
