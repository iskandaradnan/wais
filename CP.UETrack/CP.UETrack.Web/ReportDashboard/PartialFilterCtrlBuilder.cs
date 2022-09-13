using CP.Framework.ReportHelper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace UETrack.Application.Web.ReportDashboard
{
    public partial class Default
    {
        Panel aspPanelFilter = new Panel();
        Panel aspPanelPreviousFilter = new Panel();
        void BuildRptFilterCtrlTemplate(ReportMasterEntity rptMstEntity)
        {
            try
            {
                var i = 0;
                aspPanelFilter.Controls.Clear();
                aspPanelFilter.Dispose();
                aspPanelFilter.CssClass = "form-horizontal";
                Panel trDiv = null;
                var tdDivList = new List<Panel>();
                var limitedParaCount = rptMstEntity.ParamEntity.Where(x => !x.ReportParamName.Contains("Page")).Count() - 1;
                rptMstEntity.ParamEntity.ForEach(para =>
                {
                    using (var tdDiv = new Panel())
                    {
                        tdDiv.ID = PANEL_CTRL + para.ReportParamName;
                        using (var tdFormGroup = new Panel())
                        {
                            if (para.IsVisible)
                            {
                                if (para.ReportParamName == "Year"
                                || para.ReportParamName == "Frequency"
                                || para.ReportParamName == "Level"
                                || para.ReportParamName == "Frequency_Key"
                                || para.ReportParamName == "From_Date"
                                || para.ReportParamName == "To_Date"
                                || para.ReportParamName == "Month"
                                || para.ReportParamName == "Quarter"
                                )
                                {
                                    tdDiv.CssClass = "col-sm-1 Report-DDL-MinWidth";
                                }
                                else if (para.ReportParamName == "Type_Of_Planner")
                                {
                                    tdDiv.CssClass = "hidden";
                                }
                                else
                                {
                                    tdDiv.CssClass = "col-sm-2";
                                }

                            }

                            else
                            {
                                tdDiv.CssClass = "hidden";
                            }
                            tdFormGroup.CssClass = "form-group";
                            var modulosFlag = i != 0 && i % 8 == 0;//Display 3 Ctrls per row

                            if (modulosFlag)
                            {
                                if (limitedParaCount != i)
                                {
                                    modulosFlag = false;
                                }
                            }

                            if (modulosFlag)
                            {
                                using (trDiv = new Panel())
                                {
                                    trDiv.CssClass = "row";
                                    tdDivList.ForEach(t =>
                                    {
                                        trDiv.Controls.Add(t);
                                    });
                                    aspPanelFilter.Controls.Add(trDiv);
                                    tdDivList.Clear();
                                }
                            }
                            using (var lbl = new Label())
                            {
                                lbl.ID = LABEL_PREFIX + para.ReportParamName;
                                lbl.CssClass = "col-sm-12";
                                var lblReplacedText = para.ReportParamName.Replace("_", " ");
                                lbl.Text = lblReplacedText;
                                lbl.Enabled = para.IsEnabled;
                                tdFormGroup.Controls.Add(lbl);
                            }
                            using (var hid = new HiddenField())
                            {
                                hid.ID = HIDDEN_PREFIX + para.ReportParamName;
                                hid.ViewStateMode = ViewStateMode.Enabled;
                                hid.Value = string.Empty;
                                tdFormGroup.Controls.Add(hid);
                            }
                            if (para.IsMultiParam)
                            {
                                var dt = new DataTable();
                                if (para.MultiParamHasCondition)
                                {
                                    var paraValues = new List<string>();
                                    var sqlParamList = new List<SqlParameter>();
                                    foreach (MultiParamConditionEntity multiPara in para.MultiParamConditionalEntity)
                                    {
                                        var value = multiPara.MultiParamConditionValue;
                                        if (multiPara.HasSessionValue)
                                        {
                                            var result = this.GetSessionPropValueByPropName(multiPara.SessionProperty);
                                            value = Convert.ToString(result == null ? string.Empty : result);
                                        }
                                        paraValues.Add(value);
                                    }
                                    paraValues.Insert(0, null);
                                    if (paraValues.Count == 1 && string.IsNullOrEmpty(paraValues[0]))
                                    {
                                        sqlParamList = reportAPI.GetSqlParmsList(this.connStringName, para.MultiParamDataSorceSp, null);
                                    }
                                    else
                                    {
                                        sqlParamList = reportAPI.GetSqlParmsList(this.connStringName, para.MultiParamDataSorceSp, paraValues);
                                    }
                                    var sqlParamArray = sqlParamList == null ? null : sqlParamList.ToArray();
                                    if (!string.IsNullOrEmpty(para.MultiParamDataSorceSp))
                                    {
                                        dt = reportAPI.GetDataTableForDdl(rptMstEntity.ConnectionStringName, para.MultiParamDataSorceSp, sqlParamArray);

                                    }
                                    else
                                    {
                                        dt = this.GetDummyLovDataTable(para.MultiParamLabelField, para.MultiParamValueField);
                                    }
                                }
                                else
                                {
                                    if (!string.IsNullOrEmpty(para.MultiParamDataSorceSp))
                                    {
                                        dt = reportAPI.GetDataTableForDdl(rptMstEntity.ConnectionStringName, para.MultiParamDataSorceSp, null);

                                    }
                                    else
                                    {
                                        dt = this.GetDummyLovDataTable(para.MultiParamLabelField, para.MultiParamValueField);
                                    }
                                }
                                using (var divDdl = new Panel())
                                {
                                    using (var divDdlFluid = new Panel())
                                    {
                                        divDdl.CssClass = "";
                                        divDdlFluid.CssClass = "col-sm-12";
                                        using (var ddl = new DropDownListExt(rptMstEntity, para))
                                        {
                                            dynamic ddlCtrl = null;
                                            List<ReportFilterCtrlSet> preRptParam = null;
                                            dynamic ddlPreCtrl = null;
                                            var ddlID = para.ReportParamName;
                                            ddl.ID = ddlID;
                                            ddl.ViewStateMode = ViewStateMode.Enabled;
                                            ddl.DataSource = dt;
                                            ddl.DataTextField = para.MultiParamLabelField;
                                            ddl.DataValueField = para.MultiParamValueField;
                                            ddl.DataBind();
                                            ddl.CssClass = "form-control";
                                            ddl.Enabled = para.IsEnabled;
                                            ddl.Visible = para.IsVisible;
                                            if (para.HasCascading)
                                            {
                                                ddl.AutoPostBack = true;
                                                ddl.OnCustomSelectedIndexChangedEvent += new DropDownListExt.OnSelectedIndexChangedEventHandlerExt(ddl_SelectedIndexChanged);

                                            }
                                            if (Session["SpParam"] != null)
                                            {
                                                var overAllParams = (DictionaryExt<int, List<ReportFilterCtrlSet>, List<ReportFilterCtrlSet>>)Session["SpParam"];
                                                var currentParamResult = overAllParams[rptMstEntity.ParentReportID];
                                                var currentRptParam = currentParamResult.FirstOrDefault().Value;
                                                var lastRptParam = currentParamResult.FirstOrDefault().Key;
                                                var drillParams = currentRptParam;
                                                ddlCtrl = drillParams.FirstOrDefault(x => x.CtrlID == ddlID);
                                                preRptParam = lastRptParam;
                                                ddlPreCtrl = preRptParam.FirstOrDefault(x => x.CtrlID == ddlID);
                                            }
                                            if (para.HasDefaultValue)
                                            {
                                                ddl.SelectedValue = para.ReportParamValue;
                                            }
                                            else if (para.HasSessionValue)
                                            {
                                                var result = this.GetSessionPropValueByPropName(para.SessionProperty);
                                                ddl.SelectedValue = Convert.ToString(result == null ? string.Empty : result);

                                            }
                                            else if (ddlCtrl != null)
                                            {
                                                ddl.SelectedValue = ddlCtrl.CtrlValue;
                                            }
                                            else if (ddlPreCtrl != null)
                                            {
                                                ddl.SelectedValue = ddlPreCtrl.CtrlValue;
                                                preRptParam.Remove(ddlPreCtrl);
                                            }
                                            else if ((ddl.ID.ToLower() == "year") || (ddl.ID.ToLower() == "from_year") || (ddl.ID.ToLower() == "to_year"))
                                            {
                                                var curryear = DateTime.Now.Year;
                                                ddl.SelectedValue = Convert.ToString(curryear);
                                            }
                                            else if ((ddl.ID.ToLower() == "month") || (ddl.ID.ToLower() == "from_month") || (ddl.ID.ToLower() == "to_month"))
                                            {
                                                var currmonth = DateTime.Now.Month;
                                                if (currmonth < 10)
                                                {
                                                    var currmonthNumber = "0" + currmonth;
                                                    ddl.SelectedValue = Convert.ToString(currmonthNumber);
                                                }
                                                else
                                                {
                                                    ddl.SelectedValue = Convert.ToString(currmonth);
                                                }
                                            }
                                            else if (ddl.ID.ToLower() == "quarter")
                                            {
                                                var quarterNumber = "Q" + ((DateTime.Now.Month - 1) / 3 + 1);
                                                ddl.SelectedValue = Convert.ToString(quarterNumber);
                                            }
                                            else if ((ddl.ID.ToLower() == "half_yearly") || (ddl.ID.ToLower() == "from_period") || (ddl.ID.ToLower() == "to_period"))
                                            {
                                                ddl.SelectedValue = string.Empty;
                                                var halfyearNumber = "h" + ((DateTime.Now.Month - 1) / 6 + 1);
                                                ddl.SelectedValue = (halfyearNumber).ToString();
                                            }

                                            else if (ddl.ID.ToLower() == "frequency_key")
                                            {
                                                int frequency_key = DateTime.Now.Year + 1;
                                                if (ddl.SelectedValue == frequency_key.ToString())
                                                {
                                                    var curryear = DateTime.Now.Year;
                                                    ddl.SelectedValue = Convert.ToString(curryear);
                                                }
                                            }

                                            else
                                            {
                                                ddl.SelectedIndex = 0;
                                            }
                                            this.SetDefaultDisableHiddenToLevelAndLevelKeyFrequencyAndFrequencyKey(ddl, tdDiv);
                                            divDdlFluid.Controls.Add(ddl);
                                            divDdl.Controls.Add(divDdlFluid);
                                            tdFormGroup.Controls.Add(divDdl);
                                        }
                                    }
                                }
                            }
                            else
                            {
                                using (var divTxt = new Panel())
                                {
                                    using (var divTxtFluid = new Panel())
                                    {
                                        divTxt.CssClass = "";
                                        divTxtFluid.CssClass = "col-sm-12";
                                        using (var txt = new TextBox())
                                        {
                                            dynamic txtCtrl = null;
                                            List<ReportFilterCtrlSet> preRptParam = null;
                                            dynamic txtPreCtrl = null;
                                            var txtID = para.ReportParamName;
                                            txt.ID = txtID;
                                            txt.ViewStateMode = ViewStateMode.Enabled;
                                            txt.Enabled = para.IsEnabled;
                                            txt.Visible = para.IsVisible;
                                            if (para.IsDatePicker)
                                            {
                                                txt.CssClass = "form-control datePicker";
                                                if (txt.ID == "From_Date")
                                                {
                                                    DateTime now = DateTime.Now;
                                                    var startDate = new DateTime(now.Year, now.Month, 1);
                                                    txt.Text = startDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                                }
                                                else if (txt.ID == "To_Date")
                                                    txt.Text = DateTime.Now.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture);
                                            }
                                            else if (para.IsDateTimePicker)
                                            {
                                                txt.CssClass = "form-control dateTimePicker";
                                            }
                                            else
                                            {
                                                txt.CssClass = "form-control";
                                            }
                                            if (Session["SpParam"] != null)
                                            {
                                                var overAllParams = (DictionaryExt<int, List<ReportFilterCtrlSet>, List<ReportFilterCtrlSet>>)Session["SpParam"];
                                                var currentParamResult = overAllParams[rptMstEntity.ParentReportID];
                                                var currentRptParam = currentParamResult.FirstOrDefault().Value;
                                                var lastRptParam = currentParamResult.FirstOrDefault().Key;
                                                var drillParams = currentRptParam;
                                                txtCtrl = drillParams.FirstOrDefault(x => x.CtrlID == txtID);
                                                preRptParam = lastRptParam;
                                                txtPreCtrl = preRptParam.FirstOrDefault(x => x.CtrlID == txtID);
                                            }
                                            if (para.HasDefaultValue)
                                            {
                                                txt.Text = para.ReportParamValue;
                                            }
                                            else if (para.HasSessionValue)
                                            {
                                                var result = this.GetSessionPropValueByPropName(para.SessionProperty);
                                                txt.Text = Convert.ToString(result == null ? string.Empty : result);
                                            }
                                            else if (txtCtrl != null)
                                            {
                                                txt.Text = txtCtrl.CtrlText;
                                            }
                                            else if (txtPreCtrl != null)
                                            {
                                                txt.Text = txtPreCtrl.CtrlText;
                                                preRptParam.Remove(txtPreCtrl);
                                            }
                                            else if (!para.IsDatePicker)
                                            {
                                                txt.Text = string.Empty;
                                            }
                                            divTxtFluid.Controls.Add(txt);
                                            divTxt.Controls.Add(divTxtFluid);
                                            tdFormGroup.Controls.Add(divTxt);
                                        }
                                    }
                                }
                            }
                            tdDiv.Controls.Add(tdFormGroup);
                            tdDivList.Add(tdDiv);
                        }
                    }
                    i++;
                });
                //

                var panelFind = new Panel();
                panelFind.CssClass = "col-sm-1";
                panelFind.Style.Add("margin", "17px 0px 10px 0px");
                var panelFind1 = new Panel();
                using (var btnSearch = new ButtonExt(rptMstEntity))
                {
                    using (var spanIcon = new HtmlGenericControl())
                    {
                        spanIcon.Attributes.Add("Class", "glyphicon glyphicon-search");
                        btnSearch.OnCustomClickEvent += new ButtonExt.OnClickEventHandlerExt(btnSearch_Click);
                        btnSearch.ID = "btnSearch";
                        btnSearch.ViewStateMode = ViewStateMode.Enabled;
                        btnSearch.Text = "Fetch"; //string.Empty;
                        btnSearch.ToolTip = "Fetch";
                        btnSearch.CssClass = "btn btn-primary btn-sm pull-left ";
                        btnSearch.OnClientClick = "javascript:return ValidateDateFilter()";
                        rptFilterSearch.Controls.Add(btnSearch);
                    }
                    using (var hidTotalPage = new HiddenField())
                    {
                        hidTotalPage.ID = HIDDEN_PREFIX + "TotalPage";
                        hidTotalPage.ViewStateMode = ViewStateMode.Enabled;
                        hidTotalPage.Value = string.Empty;
                        rptFilterSearch.Controls.Add(hidTotalPage);
                    }
                    using (var hidBackPage = new HiddenField())
                    {
                        hidBackPage.ID = HIDDEN_PREFIX + "BackPage";
                        hidBackPage.ViewStateMode = ViewStateMode.Enabled;
                        hidBackPage.Value = string.Empty;
                        rptFilterSearch.Controls.Add(hidBackPage);
                    }
                    var hidBackPageCtrl = (HiddenField)rptFilterSearch.FindControl("hidBackPage");
                    if (hidBackPageCtrl != null)
                    {
                        if (!string.IsNullOrEmpty(rptMstEntity.BackToSpName))
                        {
                            hidBackPageCtrl.Value = (true).ToString();
                        }
                        else
                        {
                            hidBackPageCtrl.Value = (false).ToString();
                        }
                    }

                    panelFind1.Controls.Add(rptFilterSearch);
                    panelFind.Controls.Add(panelFind1);
                }

                //

                tdDivList.Add(panelFind);
                ////add the table cells from both list to table row
                if (tdDivList != null && tdDivList.Count > 0)
                {
                    using (trDiv = new Panel())
                    {
                        trDiv.CssClass = "row";
                        tdDivList.ForEach(t =>
                        {
                            trDiv.Controls.Add(t);
                        });
                        aspPanelFilter.Controls.Add(trDiv);
                        tdDivList.Clear();
                    }
                }
                rptFilterHolder.Controls.Clear();
                rptFilterHolder.Controls.Add(aspPanelFilter);
                var ddlFrequency = (DropDownListExt)aspPanelFilter.FindControl(FREQUENCY_ID);
                if (ddlFrequency != null)
                {
                    this.SetCascadingDropDownValueFromParent(ddlFrequency, ddlFrequency.rptMstEntity, ddlFrequency.rptParaEntity);
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        void BuildPreviousParams(ReportMasterEntity rptMstEntity)
        {
            try
            {
                if (Session["SpParam"] != null)
                {
                    var overAllParams = (DictionaryExt<int, List<ReportFilterCtrlSet>, List<ReportFilterCtrlSet>>)Session["SpParam"];
                    var currentParamResult = overAllParams[rptMstEntity.ParentReportID];
                    var lastRptParam = currentParamResult.FirstOrDefault().Key;
                    var i = 0;
                    aspPanelPreviousFilter.Controls.Clear();
                    aspPanelPreviousFilter.Dispose();
                    aspPanelPreviousFilter.CssClass = "form-horizontal";
                    Panel trDiv = null;
                    var tdDivList = new List<Panel>();
                    lastRptParam.ForEach(para =>
                    {
                        var levelChildFlag = para.CtrlID.ToLower() == LEVEL_KEY_ID_LOWER || para.CtrlID.ToLower() == OPTIONS_ID_LOWER || para.CtrlID.ToLower() == KEY_ID_LOWER;
                        using (var tdDiv = new Panel())
                        {
                            tdDiv.ID = PANEL_CTRL + para.CtrlID + PARENT_SUFIX; ;
                            using (var tdFormGroup = new Panel())
                            {
                                if (para.IsCtrlVisible)
                                {
                                    tdDiv.CssClass = "col-sm-2";
                                }
                                else
                                {
                                    tdDiv.CssClass = "hidden";
                                }
                                tdFormGroup.CssClass = "form-group";
                                var modulosFlag = i != 0 && i % 8 == 0;//Display 3 Ctrls per row
                                if (modulosFlag)
                                {
                                    using (trDiv = new Panel())
                                    {
                                        trDiv.CssClass = "row";
                                        tdDivList.ForEach(t =>
                                        {
                                            trDiv.Controls.Add(t);
                                        });
                                        aspPanelPreviousFilter.Controls.Add(trDiv);
                                        tdDivList.Clear();
                                    }
                                }
                                using (var lbl = new Label())
                                {
                                    lbl.ID = LABEL_PREFIX + para.CtrlID + PARENT_SUFIX;
                                    lbl.CssClass = "col-sm-12";
                                    var lblSpliteText = para.CtrlID.Replace(PARENT_SUFIX, string.Empty).Replace("_", " ");
                                    lbl.Text = lblSpliteText;
                                    lbl.Visible = para.IsCtrlVisible;
                                    lbl.Enabled = false;
                                    tdFormGroup.Controls.Add(lbl);
                                }
                                using (var hid = new HiddenField())
                                {
                                    hid.ID = HIDDEN_PREFIX + para.CtrlID + PARENT_SUFIX;
                                    hid.ViewStateMode = ViewStateMode.Enabled;
                                    hid.Value = string.Empty;
                                    tdFormGroup.Controls.Add(hid);
                                }
                                using (var divTxt = new Panel())
                                {
                                    using (var divTxtFluid = new Panel())
                                    {
                                        divTxt.CssClass = "";
                                        divTxtFluid.CssClass = "col-sm-12";
                                        using (var txt = new TextBox())
                                        {
                                            txt.ID = para.CtrlID + PARENT_SUFIX;
                                            txt.ViewStateMode = ViewStateMode.Enabled;
                                            txt.Visible = para.IsCtrlVisible;
                                            txt.Enabled = false;
                                            txt.CssClass = "form-control";
                                            txt.Text = para.CtrlText.ToString();
                                            divTxtFluid.Controls.Add(txt);
                                            divTxt.Controls.Add(divTxtFluid);
                                            tdFormGroup.Controls.Add(divTxt);
                                        }
                                    }
                                }
                                tdDiv.Controls.Add(tdFormGroup);
                                tdDivList.Add(tdDiv);
                            }
                        }
                        i++;
                    });
                    if (tdDivList != null && tdDivList.Count > 0)
                    {
                        using (trDiv = new Panel())
                        {
                            trDiv.CssClass = "row";
                            tdDivList.ForEach(t =>
                            {
                                trDiv.Controls.Add(t);
                            });
                            aspPanelPreviousFilter.Controls.Add(trDiv);
                            tdDivList.Clear();
                        }
                    }
                    rptPreviousFilter.Controls.Clear();
                    rptPreviousFilter.Controls.Add(aspPanelPreviousFilter);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}