//using CP.Framework.ReportHelper;
using CP.UETrack.Model.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    public class ReportMapper
    {
        //public ReportParamEntity MapReportParameter(ReportParameters reportParameters)
        //{
        //    var multiParamConditionEntity = new List<MultiParamConditionEntity>();
        //    var data = new List<ReportMultiParameters>();
        //    data = reportParameters.ReportMultiParameters;
        //    if (data != null)
        //    {
        //        foreach (var multiParamEntity in data)
        //        {
        //            multiParamConditionEntity.Add(MapReportMultiParameter(multiParamEntity));
        //        }
        //    }

        //    var ReportParamEntity = new ReportParamEntity
        //    {
        //        MultiParamConditionalEntity = multiParamConditionEntity,
        //        CascadingDataSorceSp = reportParameters.CascadingDataSorceSp,
        //        HasCascading = reportParameters.HasCascading != null ? reportParameters.HasCascading.Value : false,
        //        HasDefaultValue = reportParameters.HasDefaultValue != null ? reportParameters.HasDefaultValue.Value : false,
        //        HasSessionValue = reportParameters.HasSessionValue != null ? reportParameters.HasSessionValue.Value : false,
        //        IsDatePicker = reportParameters.IsDatePicker != null ? reportParameters.IsDatePicker.Value : false,
        //        IsDateTimePicker = reportParameters.IsDateTimePicker != null ? reportParameters.IsDateTimePicker.Value : false,
        //        IsEnabled = reportParameters.IsEnabled != null ? reportParameters.IsEnabled.Value : false,
        //        IsMultiParam = reportParameters.IsMultiParam != null ? reportParameters.IsMultiParam.Value : false,
        //        IsValueFieldAsCascading = reportParameters.IsValueFieldAsCascading != null ? reportParameters.IsValueFieldAsCascading.Value : false,
        //        IsVisible = reportParameters.IsVisible != null ? reportParameters.IsVisible.Value : false,
        //        MultiParamDataSorceSp = string.IsNullOrEmpty(reportParameters.MultiParamDataSorceSp) ? string.Empty : reportParameters.MultiParamDataSorceSp,
        //        MultiParamHasCondition = reportParameters.IsMultiParamHasCondition != null ? reportParameters.IsMultiParamHasCondition.Value : false,
        //        MultiParamLabelField = string.IsNullOrEmpty(reportParameters.MultiParamLabelField) ? string.Empty : reportParameters.MultiParamLabelField,
        //        MultiParamValueField = string.IsNullOrEmpty(reportParameters.MultiParamValueField) ? string.Empty : reportParameters.MultiParamValueField,
        //        ParameterId = reportParameters.ParamKeyId != 0 ? reportParameters.ParamKeyId.ToString() : "0",
        //        ParentReportId = reportParameters.LevelKeyId != 0 ? reportParameters.LevelKeyId.ToString() : "0",
        //        ParentSpName = string.IsNullOrEmpty(reportParameters.ParentSpName) ? string.Empty : reportParameters.ParentSpName,
        //        ReportParamName = string.IsNullOrEmpty(reportParameters.ReportParamName) ? string.Empty : reportParameters.ReportParamName,
        //        ReportParamNameToCascading = string.IsNullOrEmpty(reportParameters.ReportParamNameToCascading) ? string.Empty : reportParameters.ReportParamNameToCascading,
        //        ReportParamValue = string.IsNullOrEmpty(reportParameters.ReportParamValue) ? string.Empty : reportParameters.ReportParamValue,
        //        SessionProperty = string.IsNullOrEmpty(reportParameters.SessionProperty) ? string.Empty : reportParameters.SessionProperty
        //    };
        //    return ReportParamEntity;
        //}

        //public MultiParamConditionEntity MapReportMultiParameter(ReportMultiParameters reportMultiParameters)
        //{
        //    var multiParamConditionEntity = new MultiParamConditionEntity
        //    {
        //        HasSessionValue = reportMultiParameters.HasSessionValue != null ? reportMultiParameters.HasSessionValue.Value : false,
        //        MultiParamConditionName = string.IsNullOrEmpty(reportMultiParameters.MultiParamConditionName) ? string.Empty : reportMultiParameters.MultiParamConditionName,
        //        MultiParamConditionValue = string.IsNullOrEmpty(reportMultiParameters.MultiParamConditionValue) ? string.Empty : reportMultiParameters.MultiParamConditionValue,
        //        MultiParameterConditionId = reportMultiParameters.ParamKeyId != 0 ? reportMultiParameters.ParamKeyId.ToString() : "0",
        //        ParentSpName = string.IsNullOrEmpty(reportMultiParameters.ParentSpName) ? string.Empty : reportMultiParameters.ParentSpName,
        //        SessionProperty = string.IsNullOrEmpty(reportMultiParameters.SessionProperty) ? string.Empty : reportMultiParameters.SessionProperty
        //    };
        //    return multiParamConditionEntity;
        //}

        //public ReportDrillThroughEntity MapReportMultiParameter(ReportDrill reportDrill)
        //{
        //    var lstReportDrillMultiParameters = new List<ReportDrillParamEntity>();
        //    var data = reportDrill.ReportDrillMultiParameters;
        //    if (data != null)
        //    {
        //        foreach (var multiParamEntity in data)
        //        {
        //            lstReportDrillMultiParameters.Add(MapDrillReportMultiParameters(multiParamEntity));
        //        }
        //    }

        //    var reportDrillThroughEntity = new ReportDrillThroughEntity
        //    {
        //        DrillParamEntity = lstReportDrillMultiParameters,
        //        DrillThroughColumnName = string.IsNullOrEmpty(reportDrill.DrillThroughColumnName) ? string.Empty : reportDrill.DrillThroughColumnName,
        //        DrillThroughId = reportDrill.DrillThroughId != 0 ? reportDrill.DrillThroughId.ToString() : "0",
        //        DrillThroughReportName = string.IsNullOrEmpty(reportDrill.DrillThroughReportName) ? string.Empty : reportDrill.DrillThroughReportName,
        //        HasDrillParam = reportDrill.HasDrillParam != null ? reportDrill.HasDrillParam.Value : false,
        //        IsDiffDrillParam = reportDrill.IsDiffDrillParam != null ? reportDrill.IsDiffDrillParam.Value : false,
        //        IsVisible = reportDrill.IsVisible != null ? reportDrill.IsVisible.Value : false,
        //        ParentReportId = reportDrill.LevelKeyId != 0 ? reportDrill.LevelKeyId.ToString() : "0",
        //        ParentSpName = string.IsNullOrEmpty(reportDrill.ParentSpName) ? string.Empty : reportDrill.ParentSpName,
        //        ParentSpNameWithRecordSetIndex = reportDrill.ParentSpRecordSetIndex != null ? reportDrill.ParentSpRecordSetIndex.ToString() : null,
        //    };
        //    return reportDrillThroughEntity;
        //}


        //public ReportDrillParamEntity MapDrillReportMultiParameters(ReportDrillMultiParameters reportDrillMultiParameters)
        //{
        //    var reportDrillParamEntity = new ReportDrillParamEntity
        //    {
        //        AliasName = string.IsNullOrEmpty(reportDrillMultiParameters.AliasName) ? string.Empty : reportDrillMultiParameters.AliasName,
        //        DrillParamId = reportDrillMultiParameters.DrillParamId == 0 ? "0" : reportDrillMultiParameters.DrillParamId.ToString(),
        //        DrillThroughColumnName = string.IsNullOrEmpty(reportDrillMultiParameters.DrillThroughColumnName) ? string.Empty : reportDrillMultiParameters.DrillThroughColumnName,
        //        DrillThroughParamName = string.IsNullOrEmpty(reportDrillMultiParameters.DrillThroughParamName) ? string.Empty : reportDrillMultiParameters.DrillThroughParamName,
        //        HasAliasName = reportDrillMultiParameters.HasAliasName != null ? reportDrillMultiParameters.HasAliasName.Value : false,
        //        IsDiffDrillParam = reportDrillMultiParameters.IsDiffDrillParam != null ? reportDrillMultiParameters.IsDiffDrillParam.Value : false,
        //        IsFieldParam = reportDrillMultiParameters.IsFieldParam != null ? reportDrillMultiParameters.IsFieldParam.Value : false,
        //        ParentDrillThroughId = reportDrillMultiParameters.DrillKeyId == 0 ? "0" : reportDrillMultiParameters.DrillKeyId.ToString(),
        //        ParentReportId = reportDrillMultiParameters.LevelKeyId == 0 ? string.Empty : reportDrillMultiParameters.LevelKeyId.ToString(),
        //        ParentSpName = string.IsNullOrEmpty(reportDrillMultiParameters.ParentSpName) ? string.Empty : reportDrillMultiParameters.ParentSpName
        //    };
        //    return reportDrillParamEntity;
        //}

        //public ReportMasterEntity MapReportEntity(ReportEntity reportEntity)
        //{
        //    var lstReportParamEntity = new List<ReportParamEntity>();
        //    var lstReportDrillParamEntity = new List<ReportDrillThroughEntity>();
        //    if (reportEntity.ParamEntity != null)
        //    {
        //        foreach (var reportParameterEntity in reportEntity.ParamEntity)
        //        {
        //            lstReportParamEntity.Add(MapReportParameter(reportParameterEntity));
        //        }
        //    }

        //    if (reportEntity.DrillThroughEntity != null)
        //    {
        //        foreach (var reportDrillEntity in reportEntity.DrillThroughEntity)
        //        {
        //            lstReportDrillParamEntity.Add(MapReportMultiParameter(reportDrillEntity));
        //        }
        //    }

        //    var reportMasterEntity = new ReportMasterEntity
        //    {
        //        BackToSpName = string.IsNullOrEmpty(reportEntity.SpName) ? string.Empty : reportEntity.SpName,
        //        ConnectionStringName = string.IsNullOrEmpty(reportEntity.ConnectionStringName) ? string.Empty : reportEntity.ConnectionStringName,
        //        CurrentReportHeading = string.IsNullOrEmpty(reportEntity.CurrentReportHeading) ? string.Empty : reportEntity.CurrentReportHeading,
        //        CurrentReportID = reportEntity.CurrentReportID,
        //        DrillThroughEntity = lstReportDrillParamEntity != null ? lstReportDrillParamEntity : null,
        //        ExcelPath = string.IsNullOrEmpty(reportEntity.ExcelPath) ? string.Empty : reportEntity.ExcelPath,
        //        ParamEntity = lstReportParamEntity != null ? lstReportParamEntity : null,
        //        ParamSheetName = string.IsNullOrEmpty(reportEntity.ParamSheetName) ? string.Empty : reportEntity.ParamSheetName,
        //        ParentReportID = reportEntity.ParentReportID,
        //        SpName = string.IsNullOrEmpty(reportEntity.SpName) ? string.Empty : reportEntity.SpName,
        //        SpNameWithOutPrefix = string.IsNullOrEmpty(reportEntity.SpNameWithOutPrefix) ? string.Empty : reportEntity.SpNameWithOutPrefix,
        //        SqlParamArray = reportEntity.SqlParamArray

        //    };
        //    reportMasterEntity.BackToSpName = string.IsNullOrEmpty(reportEntity.BackToSpName) ? string.Empty : reportEntity.BackToSpName;
        //    return reportMasterEntity;
        //}
    }
}
