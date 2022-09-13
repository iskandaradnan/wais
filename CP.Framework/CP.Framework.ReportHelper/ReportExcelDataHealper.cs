using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace CP.Framework.ReportHelper
{
    public class ReportExcelDataHealper
    {
        public string whereReportIdField = "Report_ID =";
        public string whereParentReportIdField = "Parent_Report_ID =";
        public string whereParentParameterIdField = "Parent_Parameter_ID =";
        public string whereParentDrillThroughIdField = "Parent_Drill_Through_ID =";
        public string whereIsDiffDrillParamField = "IsDiff_Drill_Param =";
        public string whereParentSpName = "Parent_Sp_Name =";

        public DataTable GetDataFromExcelBySheet(string filePath, string sheetName)
        {
            DataTable dt = null;
            try
            {
                var excelFilePath = filePath;
                var extension = Path.GetExtension(excelFilePath);
                var fileName = Path.GetFileNameWithoutExtension(excelFilePath);
                if (File.Exists(excelFilePath) && extension.ToLower() == ExcelReaderHelper.Xlsx)
                {
                    dt = ExcelReaderHelper.ReadExcelData(excelFilePath, ExcelReaderHelper.Xlsx.ToLower(), true, sheetName);
                }
                else if (File.Exists(excelFilePath) && extension.ToLower() == ExcelReaderHelper.Xls)
                {
                    dt = ExcelReaderHelper.ReadExcelData(excelFilePath, ExcelReaderHelper.Xls.ToLower(), true, sheetName);
                }
                else
                {
                    throw new Exception(new Exception(string.Format("File name: {0}", excelFilePath), new FileNotFoundException()).ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return dt;
        }

        public List<ReportParamEntity> GetReportParamSheetById(string excelPath, string paramSheetName, string reportId)
        {
            List<ReportParamEntity> rptDtlEntityList = null;
            try
            {
                string whereCondition = whereParentReportIdField + reportId;
                DataTable dt = this.GetDataFromExcelBySheet(excelPath, paramSheetName).Select(whereCondition).CopyToDataTable();
                if (dt.Rows.Count > 0)
                {
                    rptDtlEntityList = new List<ReportParamEntity>();
                    foreach (DataRow dr in dt.AsEnumerable())
                    {
                        ReportParamEntity paraEntity = new ReportParamEntity();
                        paraEntity.ParameterId = dr["Parameter_ID"].ToString().Trim();
                        paraEntity.ParentReportId = dr["Parent_Report_ID"].ToString().Trim();
                        paraEntity.ParentSpName = dr["Parent_Sp_Name"].ToString().Trim();
                        paraEntity.ReportParamName = dr["Report_Param_Name"].ToString().Trim();
                        paraEntity.ReportParamValue = dr["Report_Param_Value"].ToString().Trim();
                        paraEntity.HasDefaultValue = Convert.ToBoolean(dr["Has_Default_Value"].ToString().Trim());
                        paraEntity.HasSessionValue = Convert.ToBoolean(dr["Has_Session_Value"].ToString().Trim());
                        paraEntity.SessionProperty = dr["Session_Property"].ToString().Trim();
                        paraEntity.IsVisible = Convert.ToBoolean(dr["IsVisible"].ToString().Trim());
                        paraEntity.IsEnabled = Convert.ToBoolean(dr["IsEnabled"].ToString().Trim());
                        paraEntity.IsDatePicker = Convert.ToBoolean(dr["IsDate_Picker"].ToString().Trim());
                        paraEntity.IsDateTimePicker = Convert.ToBoolean(dr["IsDateTime_Picker"].ToString().Trim());
                        paraEntity.IsMultiParam = Convert.ToBoolean(dr["IsMultiParam"].ToString().Trim());
                        paraEntity.MultiParamDataSorceSp = dr["Multi_Param_DataSorce_Sp"].ToString().Trim();
                        paraEntity.MultiParamValueField = dr["Multi_Param_ValueField"].ToString().Trim();
                        paraEntity.MultiParamLabelField = dr["Multi_Param_LabelField"].ToString().Trim();
                        paraEntity.MultiParamHasCondition = Convert.ToBoolean(dr["Multi_Param_Has_Condition"].ToString().Trim());
                        paraEntity.MultiParamConditionSheetName = dr["Multi_Param_Condition_Sheet_Name"].ToString().Trim();
                        paraEntity.HasCascading = Convert.ToBoolean(dr["Has_Cascading"].ToString().Trim());
                        paraEntity.CascadingDataSorceSp = dr["Cascading_DataSorce_Sp"].ToString().Trim();
                        paraEntity.IsValueFieldAsCascading = Convert.ToBoolean(dr["IsValueField_As_Cascading"].ToString().Trim());
                        paraEntity.ReportParamNameToCascading = dr["Report_Param_Name_To_Cascading"].ToString().Trim();
                        if (paraEntity.MultiParamHasCondition)
                        {
                            paraEntity.MultiParamConditionalEntity = this.GetMultiParameterConditionSheetById(excelPath, paraEntity.MultiParamConditionSheetName, paraEntity.ParameterId);
                        }
                        rptDtlEntityList.Add(paraEntity);
                    }
                }
                else
                {
                    throw new Exception("No Data Found In ParamDetails_Sheet: " + paramSheetName + " For ReportID: " + reportId);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return rptDtlEntityList;
        }
        public List<ReportParamEntity> GetReportParamSheetByParentSpName(string excelPath, string paramSheetName, string spName)
        {
            List<ReportParamEntity> rptDtlEntityList = null;
            try
            {
                string whereCondition = whereParentSpName + "'" + spName + "'";
                DataTable dt = this.GetDataFromExcelBySheet(excelPath, paramSheetName).Select(whereCondition).CopyToDataTable();
                if (dt.Rows.Count > 0)
                {
                    rptDtlEntityList = new List<ReportParamEntity>();
                    foreach (DataRow dr in dt.AsEnumerable())
                    {
                        ReportParamEntity paraEntity = new ReportParamEntity();
                        paraEntity.ParameterId = dr["Parameter_ID"].ToString().Trim();
                        paraEntity.ParentReportId = dr["Parent_Report_ID"].ToString().Trim();
                        paraEntity.ParentSpName = dr["Parent_Sp_Name"].ToString().Trim();
                        paraEntity.ReportParamName = dr["Report_Param_Name"].ToString().Trim();
                        paraEntity.ReportParamValue = dr["Report_Param_Value"].ToString().Trim();
                        paraEntity.HasDefaultValue = Convert.ToBoolean(dr["Has_Default_Value"].ToString().Trim());
                        paraEntity.HasSessionValue = Convert.ToBoolean(dr["Has_Session_Value"].ToString().Trim());
                        paraEntity.SessionProperty = dr["Session_Property"].ToString().Trim();
                        paraEntity.IsVisible = Convert.ToBoolean(dr["IsVisible"].ToString().Trim());
                        paraEntity.IsEnabled = Convert.ToBoolean(dr["IsEnabled"].ToString().Trim());
                        paraEntity.IsDatePicker = Convert.ToBoolean(dr["IsDate_Picker"].ToString().Trim());
                        paraEntity.IsDateTimePicker = Convert.ToBoolean(dr["IsDateTime_Picker"].ToString().Trim());
                        paraEntity.IsMultiParam = Convert.ToBoolean(dr["IsMultiParam"].ToString().Trim());
                        paraEntity.MultiParamDataSorceSp = dr["Multi_Param_DataSorce_Sp"].ToString().Trim();
                        paraEntity.MultiParamValueField = dr["Multi_Param_ValueField"].ToString().Trim();
                        paraEntity.MultiParamLabelField = dr["Multi_Param_LabelField"].ToString().Trim();
                        paraEntity.MultiParamHasCondition = Convert.ToBoolean(dr["Multi_Param_Has_Condition"].ToString().Trim());
                        paraEntity.MultiParamConditionSheetName = dr["Multi_Param_Condition_Sheet_Name"].ToString().Trim();
                        paraEntity.HasCascading = Convert.ToBoolean(dr["Has_Cascading"].ToString().Trim());
                        paraEntity.CascadingDataSorceSp = dr["Cascading_DataSorce_Sp"].ToString().Trim();
                        paraEntity.IsValueFieldAsCascading = Convert.ToBoolean(dr["IsValueField_As_Cascading"].ToString().Trim());
                        paraEntity.ReportParamNameToCascading = dr["Report_Param_Name_To_Cascading"].ToString().Trim();
                        if (paraEntity.MultiParamHasCondition)
                        {
                            paraEntity.MultiParamConditionalEntity = this.GetMultiParameterConditionSheetById(excelPath, paraEntity.MultiParamConditionSheetName, paraEntity.ParameterId);
                        }
                        rptDtlEntityList.Add(paraEntity);
                    }
                }
                else
                {
                    throw new Exception("No Data Found In ParamDetails_Sheet: " + paramSheetName + " For SpName: " + spName);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return rptDtlEntityList;
        }
        public List<MultiParamConditionEntity> GetMultiParameterConditionSheetById(string excelPath, string multiParamSheetName, string parameterId)
        {
            List<MultiParamConditionEntity> multiParaEntityList = null;
            try
            {
                string whereCondition = whereParentParameterIdField + parameterId;
                DataTable dt = this.GetDataFromExcelBySheet(excelPath, multiParamSheetName).Select(whereCondition).CopyToDataTable();
                if (dt.Rows.Count > 0)
                {
                    multiParaEntityList = new List<MultiParamConditionEntity>();
                    foreach (DataRow dr in dt.AsEnumerable())
                    {
                        MultiParamConditionEntity multiParaEntity = new MultiParamConditionEntity();
                        multiParaEntity.MultiParameterConditionId = dr["Multi_Parameter_Condition_ID"].ToString().Trim();
                        multiParaEntity.ParentParameterId = dr["Parent_Parameter_ID"].ToString().Trim();
                        multiParaEntity.ParentSpName = dr["Parent_Sp_Name"].ToString().Trim();
                        multiParaEntity.MultiParamConditionName = dr["Multi_Param_Condition_Name"].ToString().Trim();
                        multiParaEntity.MultiParamConditionValue = dr["Multi_Param_Condition_Value"].ToString().Trim();
                        multiParaEntity.HasSessionValue = Convert.ToBoolean(dr["Has_Session_Value"].ToString().Trim());
                        multiParaEntity.SessionProperty = dr["Session_Property"].ToString().Trim();
                        multiParaEntityList.Add(multiParaEntity);
                    }
                }
                else
                {
                    throw new Exception("No Data Found In MultiParamConditionDetails_Sheet: " + multiParamSheetName + " For ReportID: " + parameterId);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return multiParaEntityList;
        }
        public List<ReportDrillThroughEntity> GetReportDrillThroughSheetById(string excelPath, string drillThroughSheetName, string reportId)
        {
            List<ReportDrillThroughEntity> rptDtlEntityList = null;
            try
            {
                string whereCondition = whereParentReportIdField + reportId;
                DataTable dtTemp = null;
                DataTable dt = null;
                dtTemp = this.GetDataFromExcelBySheet(excelPath, drillThroughSheetName);
                if (dtTemp != null && dtTemp.Rows.Count > 0)
                {
                    DataRow[] dra = null;
                    dra = dtTemp.Select(whereCondition);
                    if (dra != null && dra.Length > 0)
                    {
                        dt = dtTemp.Select(whereCondition).CopyToDataTable();
                    }
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    rptDtlEntityList = new List<ReportDrillThroughEntity>();
                    foreach (DataRow dr in dt.AsEnumerable())
                    {
                        ReportDrillThroughEntity paraEntity = new ReportDrillThroughEntity();
                        paraEntity.DrillThroughId = dr["Drill_Through_ID"].ToString().Trim();
                        paraEntity.ParentReportId = dr["Parent_Report_ID"].ToString().Trim();
                        paraEntity.ParentSpName = dr["Parent_Sp_Name"].ToString().Trim();
                        paraEntity.ParentSpNameWithRecordSetIndex = dr["Parent_Sp_Name"].ToString().Trim() + dr["Parent_Sp_RecordSet_Index"].ToString().Trim();
                        paraEntity.DrillThroughColumnName = dr["Drill_Through_Column_Name"].ToString().Trim();
                        paraEntity.IsVisible = Convert.ToBoolean(dr["IsVisible"].ToString().Trim());
                        paraEntity.DrillThroughReportName = dr["Drill_Through_Report_Name"].ToString().Trim();
                        paraEntity.IsDiffDrillParam = Convert.ToBoolean(dr["IsDiff_Drill_Param"].ToString().Trim());
                        paraEntity.HasDrillParam = Convert.ToBoolean(dr["Has_Drill_Param"].ToString().Trim());
                        paraEntity.DrillParamSheetName = dr["Drill_Param_Sheet_Name"].ToString().Trim();
                        if (paraEntity.HasDrillParam)
                        {
                            paraEntity.DrillParamEntity = this.GetDrillParameterSheetById(excelPath, paraEntity);
                        }
                        rptDtlEntityList.Add(paraEntity);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return rptDtlEntityList;
        }
        public List<ReportDrillParamEntity> GetDrillParameterSheetById(string excelPath, ReportDrillThroughEntity paraEntity)
        {
            List<ReportDrillParamEntity> drillParaEntityList = null;
            try
            {
                DataTable dt = new DataTable();
                string whereCondition = string.Empty;
                string parentReportID = paraEntity.ParentReportId;
                string parentDrillThroughId = paraEntity.DrillThroughId;
                bool isDiffDrillParam = paraEntity.IsDiffDrillParam;
                string drillParamSheetName = paraEntity.DrillParamSheetName;
                if (isDiffDrillParam)
                {
                    whereCondition = string.Format("{0}{1}{2}{3}{4}{5}{6}{7}", this.whereParentReportIdField, parentReportID, " AND ", this.whereParentDrillThroughIdField, parentDrillThroughId, " AND ", this.whereIsDiffDrillParamField, isDiffDrillParam);
                    dt = this.GetDataFromExcelBySheet(excelPath, drillParamSheetName).Select(whereCondition).CopyToDataTable();
                }
                else
                {
                    whereCondition = string.Format("{0}{1}{2}{3}{4}", this.whereParentReportIdField, parentReportID, " AND ", this.whereIsDiffDrillParamField, isDiffDrillParam);
                    dt = this.GetDataFromExcelBySheet(excelPath, drillParamSheetName).Select(whereCondition).CopyToDataTable();
                }
                if (!string.IsNullOrEmpty(whereCondition))
                {
                    if (dt.Rows.Count > 0)
                    {
                        drillParaEntityList = new List<ReportDrillParamEntity>();
                        foreach (DataRow dr in dt.AsEnumerable())
                        {
                            ReportDrillParamEntity drillParaEntity = new ReportDrillParamEntity();
                            drillParaEntity.DrillParamId = dr["Drill_Param_ID"].ToString().Trim();
                            drillParaEntity.ParentDrillThroughId = dr["Parent_Drill_Through_ID"].ToString().Trim();
                            drillParaEntity.DrillThroughColumnName = dr["Drill_Through_Column_Name"].ToString().Trim();
                            drillParaEntity.ParentReportId = dr["Parent_Report_ID"].ToString().Trim();
                            drillParaEntity.ParentSpName = dr["Parent_Sp_Name"].ToString().Trim();
                            drillParaEntity.DrillThroughParamName = dr["Drill_Through_Param_Name"].ToString().Trim();
                            drillParaEntity.IsFieldParam = Convert.ToBoolean(dr["IsFieldParam"].ToString().Trim());
                            drillParaEntity.IsDiffDrillParam = Convert.ToBoolean(dr["IsDiff_Drill_Param"].ToString().Trim());
                            drillParaEntity.HasAliasName = Convert.ToBoolean(dr["Has_Alias_Name"].ToString().Trim());
                            drillParaEntity.AliasName = dr["Alias_Name"].ToString().Trim();
                            drillParaEntityList.Add(drillParaEntity);
                        }
                    }
                    else
                    {
                        throw new Exception("No Data Found In MultiParamConditionDetails_Sheet: " + drillParamSheetName + " For ReportID: " + parentReportID);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return drillParaEntityList;
        }
        public string GetReportSheetById(string excelPath, string reportSheetName, string reportId, out string reportHeading, out string parentReportId)
        {
            string backToReportSpName = string.Empty;
            try
            {
                string whereCondition = whereReportIdField + reportId;
                DataRow drTemp = null;
                drTemp = this.GetDataFromExcelBySheet(excelPath, reportSheetName).Select(whereCondition).FirstOrDefault();
                if (drTemp != null)
                {
                    parentReportId = drTemp["Parent_Report_ID"].ToString().Trim();
                    reportHeading = drTemp["Report_Heading"].ToString().Trim();
                    if (!string.IsNullOrEmpty(parentReportId))
                    {
                        string whereReportCondition = whereReportIdField + parentReportId;
                        DataRow drTempRow = null;
                        drTempRow = this.GetDataFromExcelBySheet(excelPath, reportSheetName).Select(whereReportCondition).FirstOrDefault();
                        if (drTempRow != null)
                        {
                            var spName = drTempRow["Sp_Name"].ToString().Trim();
                            if (!string.IsNullOrEmpty(spName))
                            {
                                backToReportSpName = spName;
                            }
                        }
                    }
                    return backToReportSpName;
                }
                else
                {
                    parentReportId = string.Empty;
                    reportHeading = string.Empty;
                    return string.Empty;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}
