USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SaveUserRegistration]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SaveUserRegistration]          
(          
      
--3-Sep-2020 added Employee_ID for Insert ,      
 --@UserRegistration As [dbo].[UMUserRegistrationType] Readonly,          
 @UserRegistration As [dbo].[UMUserRegistrationType] Readonly,          
 @UserLocationDet As [dbo].[UMUserLocationMstDetType] Readonly          
)           
AS           
          
-- Exec [SaveUserRegistration]           
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack          
--NAME    : SaveUserRegistration          
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
          
 INSERT INTO [dbo].[UMUserRegistration]          
           ([StaffName], [UserName], [Password], [Gender], [PhoneNumber], [Email], [DateJoined]          
           ,[DateJoinedUTC], [UserTypeId],[LoginAttempt], [Status], [CustomerId], [MobileNumber], [ExistingStaff]          
           ,[CreatedBy], [CreatedDate], [CreatedDateUTC], [Active], [BuiltIn], [GuId],ModifiedBy,ModifiedDate,ModifiedDateUTC,          
     UserDesignationId,UserCompetencyId,UserSpecialityId,UserGradeId,Nationality,UserDepartmentId,FacilityId,ContractorId,IsCenterPool,LabourCostPerHour)          
      OUTPUT INSERTED.UserRegistrationId INTO @UserRegistrationTable          
    SELECT [StaffName], [UserName], [Password], [Gender], [PhoneNumber], [Email], [DateJoined]          
           ,[DateJoinedUTC], [UserTypeId], 0, [Status],  [CustomerId], [MobileNumber], [ExistingStaff]          
           ,[UserId], GETDATE(), GETUTCDATE(), 1, 1, NEWID(),[UserId], GETDATE(), GETUTCDATE(),          
     UserDesignationId,UserCompetencyId,UserSpecialityId,UserGradeId,Nationality,UserDepartmentId,FacilityId,ContractorId,IsCenterPool,LabourCostPerHour          
     FROM @UserRegistration          
          
 SELECT @UserRegistrationId = (SELECT TOP 1 ID FROM @UserRegistrationTable)          
-- INSERT INTO UMUserRegistration_Mapping values(@UserRegistrationId,0,0,0,0,0)          
 INSERT INTO [dbo].[UMUserLocationMstDet]          
           ([CustomerId], [FacilityId], [UserRegistrationId], [UserRoleId], [CreatedBy]          
           ,[CreatedDate], [CreatedDateUTC], [Active], [BuiltIn], [GuId])          
     OUTPUT INSERTED.LocationId INTO @UserLocationTable          
    SELECT [CustomerId], [FacilityId], @UserRegistrationId, [UserRoleId], [UserId]          
           ,GETDATE(), GETUTCDATE(), 1, 1, NEWID()          
     FROM @UserLocationDet          
          
 SELECT UserRegistrationId, [Timestamp] FROM UMUserRegistration WHERE UserRegistrationId IN (SELECT ID FROM @UserRegistrationTable)          
          
           
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
          
------------------------------------------------------------------UDT creation -------------------------------------------------------------------          
          
          
--drop proc [SaveUserRegistration]          
--drop type [UMUserRegistrationType]          
--drop type [UMUserLocationMstDetType]          
          
--CREATE TYPE [dbo].[UMUserRegistrationType] AS TABLE(          
-- [UserRegistrationId] [int] NOT NULL,          
-- [ExistingStaff] [bit] NOT NULL,          
-- [StaffName] [nvarchar](75) NOT NULL,          
-- [UserName] [nvarchar](75) NOT NULL,          
-- [Gender] [int] NOT NULL,          
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
