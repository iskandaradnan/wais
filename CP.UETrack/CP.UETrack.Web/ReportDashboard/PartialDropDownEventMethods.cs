using CP.Framework.ReportHelper;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.ReportDashboard
{
    public partial class Default
    {
        void SetDefaultDisableHiddenToLevelAndLevelKeyFrequencyAndFrequencyKey(DropDownListExt ddl, Panel tdDivLblAndCtrl)
        {
            try
            {
                var userDetails = this.GetUserDetailsByUserName();
                //var hospitalUserFlag = userDetails.LevelOfAccessName == UM_USER_TYPE_HOSPITAL || userDetails.LevelOfAccessName == UM_USER_TYPE_LAUNDRY || userDetails.LevelOfAccessName == UM_USER_TYPE_TREATMENT;
                //var companyUserFlag = userDetails.LevelOfAccessName == UM_USER_TYPE_COMPANY || userDetails.LevelOfAccessName == UM_USER_TYPE_COMPANY_HQ;
                //var mohUserFlag = userDetails.LevelOfAccessName == UM_USER_TYPE_MOH_BPK || userDetails.LevelOfAccessName == UM_USER_TYPE_MOH_STATE || userDetails.LevelOfAccessName == UM_USER_TYPE_MOH_STAFF;
                //var sysAdminFlag = userDetails.IsSysAdmin;

                //var hospitalUserFlag = userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.HospitalUsers] || userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.LaundryPlantUsers] || userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.TreatmentPlantUsers];
                //var companyUserFlag = userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.CompanyHQUsers] || userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.CompanyUsers];
                //var mohUserFlag = userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.MOHHQUsers] || userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.MOHStateUsers]; //|| userDetails.LevelOfAccessName == UM_USER_TYPE_MOH_STAFF || userDetails.LevelOfAccessName == UM_USER_TYPE_MOH_HQ;                
                //var sysAdminFlag = userDetails.LevelOfAccess == CommonDictinary.UMUserTypeDictinary[UMUserTypeEnum.SystemAdmin];
                //if (mohUserFlag || sysAdminFlag)
                //{
                //    var levelChildDdlFlag = ddl.ID.ToLower() == LEVEL_KEY_ID_LOWER || ddl.ID.ToLower() == OPTIONS_ID_LOWER || ddl.ID.ToLower() == KEY_ID_LOWER;
                //    if (ddl.ID.ToLower() == LEVEL_ID_LOWER)
                //    {
                //        ////ddl.SelectedValue = NATIONAL_OPTION;
                //        ViewState["ddlParent"] = ddl.SelectedValue.ToString();////As per common bug in Uat for Hospital Filter.
                //        ddl.Enabled = true;
                //        ddl.Visible = true;
                //        tdDivLblAndCtrl.CssClass = "col-sm-1 Report-DDL-MinWidth";
                //    }
                //    else if (levelChildDdlFlag)
                //    {
                //        if (ViewState["ddlParent"] != null)////As per common bug in Uat for Hospital Filter.
                //        {
                //            var optionsCount = this.SetLevelKeyLovList(ViewState["ddlParent"].ToString(), ddl);
                //        }
                //        ////var optionsCount = this.SetLevelKeyLovList(NATIONAL_OPTION.ToLower(), ddl);
                //        ddl.Enabled = true;
                //        ddl.Visible = true;
                //        tdDivLblAndCtrl.CssClass = "col-sm-2";
                //    }
                //}
                //else
                //{
                //    var hospitalOrCompanyUserFlag = hospitalUserFlag || companyUserFlag;
                //    if (hospitalOrCompanyUserFlag)
                //    {
                //        var levelChildDdlFlag = ddl.ID.ToLower() == LEVEL_KEY_ID_LOWER || ddl.ID.ToLower() == OPTIONS_ID_LOWER || ddl.ID.ToLower() == KEY_ID_LOWER;
                //        if (ddl.ID.ToLower() == LEVEL_ID_LOWER)
                //        {
                //            if (hospitalUserFlag)
                //            {
                //                ddl.SelectedValue = HOSPITAL_OPTION;
                //            }
                //            else if (companyUserFlag)
                //            {
                //                ddl.SelectedValue = CONSORTIA_OPTION;
                //            }
                //            ddl.Enabled = false;
                //            ddl.Visible = true;
                //            tdDivLblAndCtrl.CssClass = "col-sm-1 Report-DDL-MinWidth";
                //        }
                //        else if (levelChildDdlFlag)
                //        {
                //            var optionsCount = 0;
                //            if (hospitalUserFlag)
                //            {
                //                optionsCount = this.SetLevelKeyLovList(HOSPITAL_OPTION.ToLower(), ddl);
                //            }
                //            else if (companyUserFlag)
                //            {
                //                optionsCount = this.SetLevelKeyLovList(CONSORTIA_OPTION.ToLower(), ddl);
                //            }
                //            if (optionsCount > 0)
                //            {
                //                ddl.Enabled = true;
                //                ddl.Visible = true;
                //                tdDivLblAndCtrl.CssClass = "col-sm-2";
                //            }
                //        }
                //    }
                //}

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        void SetCascadingDropDownValueFromParent(object sender, ReportMasterEntity rptMstEntityPara, ReportParamEntity rptParaEntityPara)
        {
            try
            {
                var argExt = new EventArgsExt
                {
                    rptMstEntity = rptMstEntityPara,
                    rptParaEntity = rptParaEntityPara
                };
                this.ddl_SelectedIndexChanged(sender, argExt);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        void ddl_SelectedIndexChanged(object sender, EventArgsExt eventArgs)
        {
            try
            {
                var dt = new DataTable();
                var rptMstEntity = eventArgs.rptMstEntity;
                var para = eventArgs.rptParaEntity;
                var paraValues = new List<string>();
                var sqlParamList = new List<SqlParameter>();
                var ddlParent = (DropDownListExt)sender;
                if (ddlParent != null)
                {
                    if (ddlParent.ID.ToLower() == LEVEL_ID_LOWER)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                            if (ddlChildToCascading != null)
                            {
                                this.SetLevelKeyLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                            }
                        }
                    }
                    //else if (ddlParent.ID.ToLower() == SERVICE_ID_LOWER)
                    //{
                    //    if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                    //    {
                    //        var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                    //        if (ddlChildToCascading != null)
                    //        {
                    //            this.SetServiceLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                    //        }
                    //    }
                    //}
                    else if (ddlParent.ID.ToLower() == GROUP_ID_LOWER)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            var AgeCount = 0;
                            var panelChildToCascading = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + para.ReportParamNameToCascading);
                            var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                            var panelGroup = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + GROUP_ID_LOWER);
                            var ddlGroup = (DropDownListExt)aspPanelFilter.FindControl(GROUP_ID_LOWER);

                            var panelAge = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + AGE_RANGE_ID_LOWER);
                            var ddlAge = (DropDownListExt)aspPanelFilter.FindControl(AGE_RANGE_ID_LOWER);
                            var panelFromDate = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + FROM_DATE_ID);
                            var txtFromDate = (TextBox)aspPanelFilter.FindControl(FROM_DATE_ID);
                            var panelToDate = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + TO_DATE_ID);
                            var txtToDate = (TextBox)aspPanelFilter.FindControl(TO_DATE_ID);

                            ddlChildToCascading.Visible = false;
                            panelChildToCascading.CssClass = "hidden";
                            if (ddlChildToCascading != null)
                            {
                                AgeCount = this.SetAgeLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                            }
                            if (AgeCount > 0)
                            {
                                ddlGroup.Visible = true;
                                panelGroup.CssClass = "col-sm-2 Report-DDL-MinWidth";
                                ddlChildToCascading.Visible = true;
                                panelChildToCascading.CssClass = "col-sm-2 Report-DDL-MinWidth";

                                DateTime now = DateTime.Now;
                                var startDate = new DateTime(now.Year, now.Month, 1);

                                txtFromDate.Visible = false;
                                txtFromDate.Text = startDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                panelFromDate.CssClass = "hidden";

                                txtToDate.Visible = false;
                                txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                panelToDate.CssClass = "hidden";

                            }
                            else
                            {
                                ddlAge.Visible = false;
                                panelAge.CssClass = "hidden";

                                DateTime now = DateTime.Now;
                                var startDate = new DateTime(now.Year, now.Month, 1);

                                txtFromDate.Visible = true;
                                txtFromDate.Text = startDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                panelFromDate.CssClass = "col-sm-1 Report-DDL-MinWidth";

                                txtToDate.Visible = true;
                                txtToDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                panelToDate.CssClass = "col-sm-1 Report-DDL-MinWidth";
                            }

                        }
                    }
                    else if (ddlParent.ID.ToLower() == Planner_Classification_ID_LOWER)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            var PlannerCount = 0;
                            var panelChildToCascading = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + para.ReportParamNameToCascading);
                            var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                            var panelPlanner = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + Planner_Classification_ID_LOWER);
                            var ddlPlanner = (DropDownListExt)aspPanelFilter.FindControl(Planner_Classification_ID_LOWER);

                            var panelPlannerType = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + Type_Of_Planner_ID_LOWER);
                            var ddlPlannerType = (DropDownListExt)aspPanelFilter.FindControl(Type_Of_Planner_ID_LOWER);

                            //ddlChildToCascading.Visible = true;
                            panelChildToCascading.CssClass = "hidden";
                            if (ddlChildToCascading != null)
                            {
                                PlannerCount = this.SetPlannerTypeLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                            }
                            if (PlannerCount > 1)
                            {
                                ddlPlanner.Visible = true;
                                panelPlanner.CssClass = "col-sm-2 Report-DDL-MinWidth";
                                ddlChildToCascading.Visible = true;
                                panelChildToCascading.CssClass = "col-sm-2 Report-DDL-MinWidth";

                            }
                            else
                            {
                                ddlPlannerType.Visible = true;
                                panelPlannerType.CssClass = "hidden";
                            }

                        }
                    }
                    else if (ddlParent.ID.ToLower() == FREQUENCY_ID_LOWER)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            var panelChildToCascading = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + para.ReportParamNameToCascading);
                            var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                            var panelYear = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + YEAR_ID);
                            var ddlYear = (DropDownListExt)aspPanelFilter.FindControl(YEAR_ID);
                            var panelFromDate = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + FROM_DATE_ID);
                            var txtFromDate = (TextBox)aspPanelFilter.FindControl(FROM_DATE_ID);
                            var panelToDate = (Panel)aspPanelFilter.FindControl(PANEL_CTRL + TO_DATE_ID);
                            var txtToDate = (TextBox)aspPanelFilter.FindControl(TO_DATE_ID);
                            var curryear = DateTime.Now.Year;
                            if (ddlChildToCascading != null && panelChildToCascading != null)
                            {
                                if (ddlParent.SelectedValue.ToLower() == FREQUENCY_OPTION_YEARLY)
                                {
                                    ddlChildToCascading.Visible = false;
                                    panelChildToCascading.CssClass = "hidden";
                                    if (txtFromDate != null && panelFromDate != null)
                                    {
                                        txtFromDate.Visible = false;
                                        txtFromDate.Text = "";
                                        panelFromDate.CssClass = "hidden";
                                    }
                                    if (txtToDate != null && panelToDate != null)
                                    {
                                        txtToDate.Visible = false;
                                        txtToDate.Text = "";
                                        panelToDate.CssClass = "hidden";
                                    }
                                    if (ddlYear != null && panelYear != null)
                                    {
                                        ddlYear.Visible = true;
                                        ddlYear.SelectedValue = Convert.ToString(curryear);
                                        panelYear.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                    }
                                }
                                else if (ddlParent.SelectedValue.ToLower() == FREQUENCY_OPTION_RANGE)
                                {
                                    ddlChildToCascading.Visible = false;
                                    panelChildToCascading.CssClass = "hidden";
                                    if (ddlYear != null && panelYear != null)
                                    {
                                        ddlYear.Visible = false;
                                        ddlYear.Text = Convert.ToString(curryear);
                                        panelYear.CssClass = "hidden";
                                    }
                                    if (txtFromDate != null && panelFromDate != null)
                                    {
                                        txtFromDate.Visible = true;
                                        DateTime now = DateTime.Now;
                                        var startDate = new DateTime(now.Year, now.Month, 1);
                                        txtFromDate.Text = startDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                        panelFromDate.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                    }
                                    if (txtToDate != null && panelToDate != null)
                                    {
                                        txtToDate.Visible = true;
                                        txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                        panelToDate.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                    }
                                }
                                else
                                {
                                    if (txtFromDate != null && panelFromDate != null)
                                    {
                                        txtFromDate.Visible = false;
                                        txtFromDate.Text = "";
                                        panelFromDate.CssClass = "hidden";
                                    }
                                    if (txtToDate != null && panelToDate != null)
                                    {
                                        txtToDate.Visible = false;
                                        txtToDate.Text = "";
                                        panelToDate.CssClass = "hidden";
                                    }
                                    if (ddlYear != null && panelYear != null)
                                    {
                                        ddlYear.Visible = true;
                                        ddlYear.Text = Convert.ToString(curryear);
                                        panelYear.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                    }
                                    ddlChildToCascading.Visible = true;
                                    panelChildToCascading.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                }
                                if (para.IsValueFieldAsCascading)
                                {
                                    paraValues.Add(ddlParent.SelectedValue.ToString());
                                }
                                else
                                {
                                    paraValues.Add(ddlParent.SelectedItem.Text.ToString());
                                }
                                paraValues.Insert(0, null);
                                if (paraValues.Count == 1 && string.IsNullOrEmpty(paraValues[0]))
                                {
                                    sqlParamList = reportAPI.GetSqlParmsList(rptMstEntity.ConnectionStringName, para.CascadingDataSorceSp, null);
                                }
                                else
                                {
                                    sqlParamList = reportAPI.GetSqlParmsList(rptMstEntity.ConnectionStringName, para.CascadingDataSorceSp, paraValues);
                                }
                                var sqlParamArray = sqlParamList == null ? null : sqlParamList.ToArray();
                                dt = reportAPI.GetDataTableForDdl(rptMstEntity.ConnectionStringName, para.CascadingDataSorceSp, sqlParamArray);
                                if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                                {
                                    if (ddlChildToCascading != null)
                                    {
                                        if (dt.Rows.Count > 0)
                                        {
                                            ddlChildToCascading.Items.Clear();
                                            ddlChildToCascading.DataSource = dt;
                                            var dr = dt.Rows[0];
                                            ddlChildToCascading.DataTextField = para.MultiParamLabelField;
                                            ddlChildToCascading.DataValueField = para.MultiParamValueField;
                                            //ddlChildToCascading.SelectedValue = dr[para.MultiParamValueField].ToString();
                                            if (para.ReportParamNameToCascading.ToString().ToLower() == "frequency_key" && ddlParent.SelectedItem.Text.ToString().ToLower() == "half-yearly")
                                            {
                                                var halfyearNumber = "h" + ((DateTime.Now.Month - 1) / 6 + 1);
                                                ddlChildToCascading.SelectedValue = (halfyearNumber).ToString();
                                            }
                                            else if (para.ReportParamNameToCascading.ToString().ToLower() == "frequency_key" && ddlParent.SelectedItem.Text.ToString().ToLower() == "quarterly")
                                            {
                                                var quarterNumber = "Q" + ((DateTime.Now.Month - 1) / 3 + 1);
                                                ddlChildToCascading.SelectedValue = Convert.ToString(quarterNumber);
                                            }
                                            else if (para.ReportParamNameToCascading.ToString().ToLower() == "frequency_key" && ddlParent.SelectedItem.Text.ToString().ToLower() == "yearly")
                                            {
                                                ddlChildToCascading.SelectedValue = Convert.ToString(curryear);
                                            }
                                            else if (para.ReportParamNameToCascading.ToString().ToLower() == "frequency_key" && ddlParent.SelectedItem.Text.ToString().ToLower() == "monthly")
                                            {
                                                //if (dr["Lov_Label"].ToString() == "All")
                                                //    dr.Delete();

                                                var currmonth = DateTime.Now.Month;
                                                if (currmonth < 10)
                                                {
                                                    var currmonthNumber = "0" + currmonth;
                                                    ddlChildToCascading.SelectedValue = Convert.ToString(currmonthNumber);
                                                }
                                                else
                                                {
                                                    ddlChildToCascading.SelectedValue = Convert.ToString(currmonth);
                                                }

                                            }
                                            else
                                            {
                                                ddlChildToCascading.SelectedValue = dr[para.MultiParamValueField].ToString();
                                            }
                                            ddlChildToCascading.DataBind();
                                        }
                                        else
                                        {
                                            dt = this.GetDummyLovDataTable(para.MultiParamLabelField, para.MultiParamValueField);
                                            ddlChildToCascading.Items.Clear();
                                            ddlChildToCascading.DataSource = dt;
                                            var dr = dt.Rows[0];
                                            ddlChildToCascading.DataTextField = para.MultiParamLabelField;
                                            ddlChildToCascading.DataValueField = para.MultiParamValueField;
                                            ddlChildToCascading.SelectedValue = dr[para.MultiParamValueField].ToString();
                                            ddlChildToCascading.DataBind();
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (ddlParent.ID.ToLower() == WASTE_CATEGORY_ID_LOWER)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                            if (ddlChildToCascading != null)
                            {
                                this.SetWasteTypeKeyLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                            }
                        }
                    }
                    else if (ddlParent.ID.ToLower() == SERVICE)
                    {
                        if (!string.IsNullOrEmpty(para.ReportParamNameToCascading))
                        {
                            if (para.ReportParamNameToCascading.ToLower() == SUB_LEVEL_ID_LOWER)
                            {
                                var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                                if (ddlChildToCascading != null)
                                {
                                    this.SetServiceLovList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                                }
                            }

                            else if (para.ReportParamNameToCascading.ToLower() == INDICATOR)
                            {
                                var ddlChildToCascading = (DropDownListExt)aspPanelFilter.FindControl(para.ReportParamNameToCascading);
                                if (ddlChildToCascading != null)
                                {
                                    this.SetIndicatorList(ddlParent.SelectedValue.ToLower(), ddlChildToCascading);
                                }
                            }
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        int SetLevelKeyLovList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetLevelKeyRpt";
                var userDetails = this.GetUserDetailsByUserName();
                var userId = userDetails.UserId.ToString();
                var sqlParamArray = new SqlParameter[2]
               {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "LovType", Value = ddlParentSelectedValue.ToLower() },
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "Userid", Value = userId }
               };
                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);

                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }
                else
                {
                    ddlChildToCascading.Items.Clear();
                }
                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        DataTable GetDummyLovDataTable(string labelField, string valueField)
        {
            dynamic dt = null;
            try
            {
                dt = new DataTable();
                dt.Columns.Add(labelField, typeof(string));
                dt.Columns.Add(valueField, typeof(string));
                var dr = dt.NewRow();
                dr[labelField] = string.Empty;
                dr[valueField] = string.Empty;
                dt.Rows.Add(dr);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return dt;
        }

        UserDetailsModel GetLoginSession()
        {
            try
            {
                var _sessionProvider = new SessionHelper();
                var userDetails = _sessionProvider.UserSession();
                return userDetails;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        object GetSessionPropValueByPropName(string propName)
        {
            try
            {
                var _sessionProvider = new SessionHelper();
                var userDetails = _sessionProvider.UserSession();
                var result = userDetails.GetType().GetProperty(propName).GetValue(userDetails, null);
                return result;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        UserDetailsModel GetUserDetailsByUserName()
        {
            UserDetailsModel userDetail = null;
            try
            {
                var currentUserName = HttpContext.Current.User.Identity.Name;
                var sqlParamArray = new SqlParameter[1]
                {
                   new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "User_Name", Value = currentUserName }
                };
                var dt = reportAPI.GetDataTableForDdl(connStringName, "GetUserDetails", sqlParamArray);

                if (dt.Rows.Count > 0)
                {
                    var dr = dt.Rows[0];
                    userDetail = new UserDetailsModel
                    {
                        UserId = Convert.ToInt32(dr["UserId"]),
                        //IsSysAdmin = Convert.ToBoolean(dr["IsSysAdmin"]),
                        //LevelOfAccess = Convert.ToInt32(dr["LevelOfAccess"]),
                        //LevelOfAccessName = dr["LevelOfAccessName"].ToString()
                    };
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return userDetail;
        }

        int SetServiceLovList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetTestTypeforCertificationRpt";
                var userDetails = this.GetUserDetailsByUserName();
                var userId = userDetails.UserId.ToString();
                var sqlParamArray = new SqlParameter[1]
               {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "LovType", Value = ddlParentSelectedValue.ToLower() }//,
                 //new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "Userid", Value = userId }
               };
                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);

                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }
                else
                {
                    ddlChildToCascading.Items.Clear();
                }
                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        int SetAgeLovList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetAgeRange_Case";
                var userDetails = this.GetUserDetailsByUserName();
                var userId = userDetails.UserId.ToString();
                var sqlParamArray = new SqlParameter[1]
               {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "LovType", Value = ddlParentSelectedValue.ToLower() }//,
                 //new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "Userid", Value = userId }
               };
                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);

                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }

                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        int SetWasteTypeKeyLovList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetWasteTypeHwms";
                var sqlParamArray = new SqlParameter[1]
                {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "Waste_Category", Value = ddlParentSelectedValue.ToLower() }
                };

                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);
                if (dt.Rows.Count > 0)
                {
                    var dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }
                else
                {
                    ddlChildToCascading.Items.Clear();
                }
                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        int SetIndicatorList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetServiceList_Indicator";
                var sqlParamArray = new SqlParameter[1]
                {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "Service", Value = ddlParentSelectedValue.ToLower() }
                };

                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);
                if (dt.Rows.Count > 0)
                {
                    var dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }
                else
                {
                    ddlChildToCascading.Items.Clear();
                }
                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        int SetPlannerTypeLovList(string ddlParentSelectedValue, DropDownListExt ddlChildToCascading)
        {
            try
            {
                var spName = "GetTypeOfPlanner_Case";
                var userDetails = this.GetUserDetailsByUserName();
                var userId = userDetails.UserId.ToString();
                var sqlParamArray = new SqlParameter[1]
               {
                 new SqlParameter { SqlValue = SqlDbType.VarChar, ParameterName = "LovType", Value = ddlParentSelectedValue.ToLower() }
               };
                var dt = reportAPI.GetDataTableForDdl(connStringName, spName, sqlParamArray);

                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    ddlChildToCascading.Items.Clear();
                    ddlChildToCascading.DataSource = dt;
                    ddlChildToCascading.DataTextField = "Lov_Label";
                    ddlChildToCascading.DataValueField = "Lov_Value";
                    ddlChildToCascading.SelectedValue = dr["Lov_Value"].ToString();
                    ddlChildToCascading.DataBind();
                }

                return dt.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}