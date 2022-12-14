USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetUserRegistration]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[GetUserRegistration]  
  
(  
  
 @Id INT,  
  
 @UserRegistrationId INT = null  
  
)  
  
   
  
AS   
  
  
  
-- Exec [GetUserRegistration] @Id=76  
  
  
  
--/*=====================================================================================================================  
  
--APPLICATION  : UETrack  
  
--NAME    : GetUserRegistration  
  
--DESCRIPTION  : GET USER REGISTRATION FOR THE GIVEN ID  
  
--AUTHORS   : BIJU NB  
  
--DATE    : 20-March-2018  
  
-------------------------------------------------------------------------------------------------------------------------  
  
--VERSION HISTORY   
  
--------------------:---------------:---------------------------------------------------------------------------------------  
  
--Init    : Date          : Details  
  
--------------------:---------------:---------------------------------------------------------------------------------------  
  
--BIJU NB           : 23-March-2018 :   
  
-------:------------:----------------------------------------------------------------------------------------------------*/  
  
BEGIN  
  
SET NOCOUNT ON  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
BEGIN TRY  
  
   
  
  
  
 DECLARE @pCustomerId INT  
  
  
  
 SET @pCustomerId = (SELECT CustomerId FROM UMUserRegistration WHERE UserRegistrationId = @Id)  
  
  
  
  
  
 SELECT StaffName, UserName, Gender, PhoneNumber, Email, DateJoined, UserTypeId, [Status],   
  
 A.CustomerId, MobileNumber, ExistingStaff, A.[Timestamp],  
  
 UserDesignationId,UserCompetencyId,UserSpecialityId,UserGradeId,Nationality,UserDepartmentId,FacilityId,isnull(A.ContractorId, 0) ContractorId,B.ContractorName  
  
 ,isnull(IsCenterPool, 0) IsCenterPool,LabourCostPerHour  
  
 FROM UMUserRegistration A  
  
 LEFT JOIN MstContractorandVendor B ON A.ContractorId = B.ContractorId  
  
 WHERE UserRegistrationId = @Id  
  
  
  
 SELECT A.FacilityId, UserRoleId, B.FacilityName FROM UMUserLocationMstDet A  
  
 JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId  
  
 WHERE UserRegistrationId = @Id  
  
  
  
 IF (@pCustomerId IS NOT NULL)  
  
 BEGIN  
  
 SELECT A.FacilityId LovId, FacilityName FieldValue,  
  
 0 AS IsDefault FROM MstLocationFacility A  
  
 JOIN UMUserLocationMstDet B ON A.FacilityId = B.FacilityId  
  
 JOIN UMUserRegistration C ON B.UserRegistrationId = C.UserRegistrationId  
  
 WHERE A.CustomerId =  @pCustomerId AND C.UserRegistrationId = @UserRegistrationId  
  
 AND (ActiveTo IS NULL OR cast(ActiveTo as date) >= cast(GETDATE() as date))  
  
 ORDER BY FacilityName   
  
 END  
  
  
  
 IF (@pCustomerId IS NULL)  
  
 BEGIN  
  
 SELECT A.FacilityId LovId, FacilityName FieldValue,  
  
 0 AS IsDefault FROM MstLocationFacility A  
  
 JOIN UMUserLocationMstDet B ON A.FacilityId = B.FacilityId  
  
 JOIN UMUserRegistration C ON B.UserRegistrationId = C.UserRegistrationId  
  
 WHERE C.UserRegistrationId = @UserRegistrationId   
  
 AND (ActiveTo IS NULL OR cast(ActiveTo as date) >= cast(GETDATE() as date))  
  
 ORDER BY FacilityName   
  
 END  
  
  
  
 SELECT UMUserRoleId LovId, Name FieldValue,  
  
 0 AS IsDefault FROM UMUserRole WHERE UserTypeId =   
  
 (SELECT UserTypeId FROM UMUserRegistration WHERE UserRegistrationId = @Id)  
  
 ORDER BY Name  
  
   
  
END TRY  
  
BEGIN CATCH  
  
  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
  
  
THROW  
  
  
  
END CATCH  
  
SET NOCOUNT OFF  
  
END
GO
