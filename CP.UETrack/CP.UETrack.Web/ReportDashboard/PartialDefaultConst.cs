using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace UETrack.Application.Web.ReportDashboard
{
    public partial class Default
    {
        public string connStringName = ConfigurationManager.AppSettings["connString"].ToString();
        public string excelPath = string.Empty;
        public string reportSheetName = "Report";
        public string paramSheetName = ConfigurationManager.AppSettings["paramSheetName"].ToString();
        public string drillThroughSheetName = ConfigurationManager.AppSettings["drillThroughSheetName"].ToString();
        public string currentRptPath = string.Empty;
        //Session_Key       
        const string USER_ID_SESSION = "UserId";
        const string HOSPITAL_ID_SESSION = "HospitalId";
        const string COMPANY_ID_SESSION = "CompanyId";
        const string SERVICE_ID_SESSION = "ServiceID";

        //UmUserType
        //---Hospital
        const string UM_USER_TYPE_HOSPITAL = "Hospital Users";
        const string UM_USER_TYPE_LAUNDRY = "Laundry Plant Users";
        const string UM_USER_TYPE_TREATMENT = "Treatment Plant Users";
        //---Company
        const string UM_USER_TYPE_COMPANY = "Company Users";
        const string UM_USER_TYPE_COMPANY_HQ = "Company HQ Users";
        //---Moh
        const string UM_USER_TYPE_MOH_BPK = "MOH HQ Users";
        const string UM_USER_TYPE_MOH_STATE = "MOH State User";
        const string UM_USER_TYPE_MOH_STAFF = "MOHStaffMaster";
        const string UM_USER_TYPE_MOH_HQ = "MOH HQ Users";
        //---
        //CtrlBuilder
        const string NULL_KEY = "null";
        const string PANEL_CTRL = "Panel";
        const string TXT_CTRL = "TextBox";
        const string DROP_DOWN_CTRL = "DropDownListExt";
        const string LABEL_PREFIX = "lbl";
        const string HIDDEN_PREFIX = "hid";
        const string PARENT_SUFIX = "_Parent";
        const string COLUMN_TOTAL_RECORD = "Total_Records";
        const string DEFAULT_REPORT = "ClsJointInspectionRpt_L1";
        const string DEFAULT_REPORT_KEY_ID = "CLS007";
        //ToLowerLovID
        const string LEVEL_ID = "Level";
        const string OPTIONS_ID = "Option";
        const string LEVEL_ID_LOWER = "level";
        const string LEVEL_KEY_ID_LOWER = "level_key";
        const string OPTIONS_ID_LOWER = "option";
        const string KEY_ID_LOWER = "key";
        const string FREQUENCY_ID_LOWER = "frequency";
        //LovOptions
        const string NATIONAL_OPTION = "national";
        const string HOSPITAL_OPTION = "hospital";
        const string STATE_OPTION = "state";
        const string CONSORTIA_OPTION = "consortia";
        //GetByID
        const string FREQUENCY_ID = "Frequency";
        const string YEAR_ID = "Year";
        const string FROM_DATE_ID = "From_Date";
        const string TO_DATE_ID = "To_Date";
        //FrequencySelectedValue
        const string FREQUENCY_OPTION_YEARLY = "yearly";
        const string FREQUENCY_OPTION_RANGE = "range";
        //Service selected value
        const string SERVICE_ID_LOWER = "service";
        const string SUB_LEVEL_ID_LOWER = "sub_level";

        const string GROUP_ID_LOWER = "group_by";
        const string AGE_RANGE_ID_LOWER = "age_range";

        const string Planner_Classification_ID_LOWER = "planner_classification";
        const string Type_Of_Planner_ID_LOWER = "type_of_planner";

        //For HWMS Waste Category and Waste Type Cascading

        const string WASTE_CATEGORY_ID_LOWER = "waste_category";
        const string WASTE_TYPE_ID_LOWER = "waste_type";

        //For QAP
        const string SERVICE = "service";
        const string INDICATOR = "indicator";
    }

    public enum UMUserTypeEnum
    {
        SystemAdmin,
        HospitalUsers,
        CompanyUsers,
        MOHHQUsers,
        MOHStateUsers,
        CompanyHQUsers,
        LaundryPlantUsers,
        TreatmentPlantUsers
    };

    public static class CommonDictinary
    {
        public static Dictionary<UMUserTypeEnum, int> UMUserTypeDictinary = new Dictionary<UMUserTypeEnum, int>() {

            { UMUserTypeEnum.SystemAdmin, 1 },
            { UMUserTypeEnum.HospitalUsers, 662 },
            { UMUserTypeEnum.CompanyUsers, 663},
            { UMUserTypeEnum.MOHHQUsers, 3156 },
            { UMUserTypeEnum.MOHStateUsers, 3157},
            {UMUserTypeEnum.CompanyHQUsers, 3187},
            {UMUserTypeEnum.LaundryPlantUsers, 3189},
            {UMUserTypeEnum.TreatmentPlantUsers, 3190}
        };
    }
}