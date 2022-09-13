using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    [Serializable]
    public class AccountEntity
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public System.DateTime? LockoutEndDateUtc { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public bool RememberMe { get; set; }

    }

    [Serializable]
    public class LoginUser
    {
        public string LoginID { get; set; }
    }
    [Serializable]
    public class RolePermission
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public int PermissionId { get; set; }

        public List<Permission> Permissions = new List<Permission>();
    }

    public class Roles
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }

        public string RoleDescription { get; set; }
        public bool IsSysAdmin { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public bool Inactive { get; set; }
    }
    [Serializable]
    public class UserPermission
    {
        public int UserId { get; set; }
        public int PermissionId { get; set; }

        public List<Permission> Permissions = new List<Permission>();
    }
    [Serializable]
    public class UserRole
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }

        public List<Permission> Permissions = new List<Permission>();
    }

    [Serializable]
    public class Permission
    {
        public int Permission_Id { get; set; }
        public string PermissionDescription { get; set; }
        public int PageId { get; set; }
        public string PageName { get; set; }
        public string EventName { get; set; }
        public string PageKey { get; set; }
        public string EventKey { get; set; }
        public Pages PageObj { get; set; }
        public int EventId { get; set; }
        public Events EventObj { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public bool Inactive { get; set; }
    }

    [Serializable]
    public class Pages
    {
        public int PageId { get; set; }
        public string PageName { get; set; }
        public string PageDescription { get; set; }
        public string PageURL { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public bool Inactive { get; set; }
    }
    [Serializable]
    public class Events
    {
        public int EventId { get; set; }
        public string EventName { get; set; }
        public string EventDescription { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public bool Inactive { get; set; }
    }

    [Serializable]
    public class Menus
    {
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public string MenuDescription { get; set; }
        public int? ParentMenuID { get; set; }

        public int PageId { get; set; }
        public string ControllerName { get; set; }
        public int SequenceNo { get; set; }
        //public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public bool Inactive { get; set; }
        public Nullable<int> ScreenPageId { get; set; }
        public string URL { get; set; }
        public int ServiceID { get; set; }

        public List<Menus> SubMenus = new List<Menus>();
    }
    [Serializable]
    public class AuthUser
    {
        public int UserId { get; set; }
        public bool IsSysAdmin { get; set; }
        public string Username { get; set; }
        public List<RolePermission> RolesPerm = new List<RolePermission>();
        public UserPermission UserPerm = new UserPermission();
    }
    [Serializable]
    public class AuthenticatedUser
    {
        public int UserId { get; set; }
        public bool? IsSysAdmin { get; set; }
        public string Username { get; set; }
        public List<UserRoleMapping> UserRoles { get; set; }
        //public bool isBPK { get; set; }
        //public bool isStateEngr { get; set; }
        public List<RoleScreenPermissionMapping> RoleScreenPermissions { get; set; }
       
    }
    [Serializable]
    public class UserRoleMapping
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public int HospitalId { get; set; }
        public List<RoleScreenPermissionMapping> RoleScreenPermission { get; set; }
    }
    [Serializable]
    public class RoleScreenPermissionMapping
    {
        public int RoleId { get; set; }
        public int ScreenId { get; set; }
        public string ControllerName { get; set; }
        public string ServiceKey { get; set; }
        public string Permissions { get; set; }
        public string PageURL { get; set; }
    }
    [Serializable]
    public class UserDetails
    {
     
        public int UserId { get; set; }

        public String UserName { get; set; }
        public int Services { get; set; }

        public int HospitalId { get; set; }

        public String HospitalCode { get; set; }

    

        public int ConsortiaId { get; set; }

       

        public bool IsSysAdmin { get; set; }

        public int LevelOfAccess { get; set; }
    }
    [Serializable]
    public class CompanyHospitalDetViewModel
    {
        public IEnumerable<CompanyUserDetViewModel> companyList { get; set; }
        public IEnumerable<HospitalUserDetViewModel> hospitalList { get; set; }
        public UserDetailsModel userDetails { get; set; }
        public AccessibleServices accessibleServices { get; set; }
        public int selectedCompanyId { get; set; }
        public int selectedHospitalId { get; set; }
        public bool IsPasswordGoingToExpire { get; set; }
        public int DaysToPasswordExpiry { get; set; }
        public bool IsPasswordExpiredNormally { get; set; }
        public bool IsPasswordExpiredDueToInactivity { get; set; }
    }
    public class PasswordPolicy
    {
        public bool IsPasswordGoingToExpire { get; set; }
        public int DaysToPasswordExpiry { get; set; }
        public bool IsPasswordExpiredNormally { get; set; }
        public bool IsPasswordExpiredDueToInactivity { get; set; }
    }

    [Serializable]
    public class CompanyUserDetViewModel
    {
        public int CompanyId { get; set; }
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public int Status { get; set; }
      

    }
    [Serializable]
    public class CompanyPhoneNumbers
    {
        public string CompanyName { get; set; }
        public string PhoneNumber { get; set; }
    }
    [Serializable]
    public class HospitalUserDetViewModel
    {
        public int HospitalId { get; set; }
        public int ConsortiaId { get; set; }
        public string HospitalCode { get; set; }
        public string HospitalName { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string HospitalLocation { get; set; }
        public bool IsMOHUser { get; set; }
        public int Status { get; set; }
    }
}
