USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserRegistration]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE   UpdateUserRegistration      
        
        
CREATE PROCEDURE [dbo].[UpdateUserRegistration]        
(        
 @UserRegistration As [dbo].[UMUserRegistrationType] Readonly,        
 @UserLocationDet As [dbo].[UMUserLocationMstDetType] Readonly        
)         
AS         
        
-- Exec [UpdateUserRegistration]         
        
--/*=====================================================================================================================        
--APPLICATION  : UETrack        
--NAME    : UpdateUserRegistration        
--DESCRIPTION  : SAVE USER REGISTRATION SCREEN        
--AUTHORS   : BIJU NB        
--DATE    : 22-March-2018        
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--BIJU NB           : 22-March-2018 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
        
BEGIN TRAN        
        
 DECLARE @UserRegistrationTable TABLE (ID INT)        
 DECLARE @UserLocationTable TABLE (ID INT)        
 DECLARE @UserRegistrationId INT        
        
 SELECT TOP 1 @UserRegistrationId = UserRegistrationId FROM @UserRegistration;        
        
 UPDATE A        
 SET A.StaffName = B.StaffName,        
 A.UserName = B.UserName,        
 A.Gender = B.Gender,         
 A.PhoneNumber = B.PhoneNumber,         
 A.Email = B.Email,         
 A.DateJoined = B.DateJoined,        
    A.DateJoinedUTC = B.DateJoinedUTC,        
 A.UserTypeId = B.UserTypeId,        
 A.[Status] = B.[Status],         
 A.[CustomerId] = B.[CustomerId],        
 A.MobileNumber = B.MobileNumber,        
 A.ModifiedBy = B.UserId,        
 A.ModifiedDate = GETDATE(),        
 A.ModifiedDateUTC = GETUTCDATE(),        
 A.UserDesignationId = B.UserDesignationId,        
 A.UserCompetencyId = B.UserCompetencyId,        
 A.UserSpecialityId = B.UserSpecialityId,        
 A.UserGradeId = B.UserGradeId,        
 A.Nationality = B.Nationality,        
 A.UserDepartmentId = B.UserDepartmentId,        
 A.FacilityId = B.FacilityId,        
 A.ContractorId = B.ContractorId,        
 A.IsCenterPool = B.IsCenterPool,        
 A.LabourCostPerHour = B.LabourCostPerHour ,   
 A.Employee_ID=B.Employee_ID  
 FROM UMUserRegistration A        
 JOIN @UserRegistration B        
 ON A.UserRegistrationId = B.UserRegistrationId        
        
 DELETE FROM UMUserLocationMstDet WHERE UserRegistrationId = @UserRegistrationId        
        
 INSERT INTO [dbo].[UMUserLocationMstDet]        
           ([CustomerId], [FacilityId], [UserRegistrationId], [UserRoleId], [CreatedBy]        
           ,[CreatedDate], [CreatedDateUTC], [Active], [BuiltIn], [GuId])        
     OUTPUT INSERTED.LocationId INTO @UserLocationTable        
    SELECT [CustomerId], [FacilityId], UserRegistrationId, [UserRoleId], [UserId]        
           ,GETDATE(), GETUTCDATE(), 1, 1, NEWID()        
     FROM @UserLocationDet        
        
 SELECT UserRegistrationId, [Timestamp] FROM UMUserRegistration WHERE UserRegistrationId = @UserRegistrationId        
        
COMMIT TRAN        
        
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
ROLLBACK;        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
END          
        
------------------------------------------------------------------------------UDT creation --------------------------------------------------------------------------------        
        
--drop proc [UpdateUserRegistration]        
--drop type [UMUserRegistrationType]        
--drop type [UMUserLocationMstDetType]        
        
--CREATE TYPE [dbo].[UMUserRegistrationType] AS TABLE(      
-- [UserRegistrationId] [int] NOT NULL,        
-- [ExistingStaff] [bit] NOT NULL,        
-- [StaffName] [nvarchar](75) NOT NULL,        
-- [UserName] [nvarchar](75) NOT NULL,    -- [Gender] [int] NOT NULL,        
-- [PhoneNumber] [nvarchar](30) NOT NULL,        
-- [Email] [nvarchar](200) NOT NULL,        
-- [MobileNumber] [nvarchar](30) NULL,        
-- [DateJoined] [datetime] NOT NULL,        
-- [DateJoinedUTC] [datetime] NOT NULL,        
-- [UserTypeId] [int] NOT NULL,        
-- [Status] [int] NOT NULL,        
-- [CustomerId] [int]  NULL,        
-- [StaffMasterId] [int] NULL,        
-- [UserId] [int] NOT NULL,        
-- [UserDesignationId] [int] NULL,        
-- [UserCompetencyId] [nvarchar](100) NULL,        
-- [UserSpecialityId] [nvarchar](100) NULL,        
-- [UserGradeId] [int] NULL,        
-- [Nationality] [int] NULL,        
-- [UserDepartmentId] [int] NULL,        
-- [FacilityId] [int] NULL,        
-- [Password] [nvarchar](max) NULL,        
-- [ContractorId] [int] NULL,        
-- [IsCenterPool] [bit] NULL,        
-- [LabourCostPerHour] [numeric](24, 2) NULL        
--)        
--GO        
        
--CREATE TYPE [dbo].[UMUserLocationMstDetType] AS TABLE(        
-- [LocationId] [int] NOT NULL,        
-- [CustomerId] [int] NULL,        
-- [FacilityId] [int] NOT NULL,        
-- [UserRegistrationId] [int] NOT NULL,        
-- [UserRoleId] [int] NOT NULL,        
-- [UserId] [int] NOT NULL        
--) 
GO
