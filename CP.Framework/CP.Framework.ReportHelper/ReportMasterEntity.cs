using System.Collections.Generic;
using System.Data.SqlClient;


namespace CP.Framework.ReportHelper
{
    public class DictionaryExt<K, T1, T2> : Dictionary<K, Dictionary<T1, T2>> { }

    public class ReportMasterEntity
    {
        #region ExcelDetailsEntity
        public string ExcelPath { get; set; }
        #endregion

        #region SqlDetailEntity
        public string ConnectionStringName { get; set; }
        public SqlParameter[] SqlParamArray { get; set; } //To accept null value SqlParameter[] array is used.        
        #endregion

        #region RptMasterEntity        
        public string SpNameWithOutPrefix { get; set; }
        public string SpName { get; set; }
        public string ParamSheetName { get; set; }

        public int ParentReportID { get; set; }
        public int CurrentReportID { get; set; }
        public string BackToSpName { get; set; }
        public string CurrentReportHeading { get; set; }
        #endregion

        #region RptChildEntity
        public List<ReportParamEntity> ParamEntity { get; set; }
        public List<ReportDrillThroughEntity> DrillThroughEntity { get; set; }
        #endregion
    }

    public class ReportParamEntity
    {
        #region RptParamEntity
        public string ParameterId { get; set; }
        public string ParentReportId { get; set; }
        public string ParentSpName { get; set; }
        public string ReportParamName { get; set; }
        public string ReportParamValue { get; set; }
        public bool HasDefaultValue { get; set; }
        public bool HasSessionValue { get; set; }
        public string SessionProperty { get; set; }
        public bool IsVisible { get; set; }
        public bool IsEnabled { get; set; }
        public bool IsDatePicker { get; set; }
        public bool IsDateTimePicker { get; set; }
        public bool IsMultiParam { get; set; }
        public string MultiParamDataSorceSp { get; set; }
        public string MultiParamValueField { get; set; }
        public string MultiParamLabelField { get; set; }
        public bool MultiParamHasCondition { get; set; }
        public string MultiParamConditionSheetName { get; set; }
        public bool HasCascading { get; set; }
        public string CascadingDataSorceSp { get; set; }
        public bool IsValueFieldAsCascading { get; set; }
        public string ReportParamNameToCascading { get; set; }
        public List<MultiParamConditionEntity> MultiParamConditionalEntity { get; set; }
        #endregion
    }

    public class MultiParamConditionEntity
    {
        #region MultiParamConditionEntity
        public string MultiParameterConditionId { get; set; }
        public string ParentParameterId { get; set; }
        public string ParentSpName { get; set; }
        public string MultiParamConditionName { get; set; }
        public string MultiParamConditionValue { get; set; }
        public bool HasSessionValue { get; set; }
        public string SessionProperty { get; set; }
        #endregion
    }

    public class ReportDrillThroughEntity
    {
        #region RptDrillThroughEntity
        public string DrillThroughId { get; set; }
        public string ParentReportId { get; set; }
        public string ParentSpName { get; set; }
        public string ParentSpNameWithRecordSetIndex { get; set; }
        public string DrillThroughColumnName { get; set; }
        public bool IsVisible { get; set; }
        public string DrillThroughReportName { get; set; }
        public bool IsDiffDrillParam { get; set; }
        public bool HasDrillParam { get; set; }
        public string DrillParamSheetName { get; set; }
        public List<ReportDrillParamEntity> DrillParamEntity { get; set; }
        #endregion
    }

    public class ReportDrillParamEntity
    {
        #region RptDrillThroughEntity
        public string DrillParamId { get; set; }
        public string ParentDrillThroughId { get; set; }
        public string DrillThroughColumnName { get; set; }
        public string ParentReportId { get; set; }
        public string ParentSpName { get; set; }
        public string DrillThroughParamName { get; set; }
        public bool IsFieldParam { get; set; }
        public bool IsDiffDrillParam { get; set; }
        public bool HasAliasName { get; set; }
        public string AliasName { get; set; }
        #endregion
    }
}
