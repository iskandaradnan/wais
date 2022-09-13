using CP.Framework.ReportHelper;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UETrack.Application.Web.ReportDashboard
{
    public partial class Default
    {
        List<ReportFilterCtrlSet> GetPreviousSearchFiltersByID(int key)
        {
            var previousFilters = new List<ReportFilterCtrlSet>();
            try
            {
                if (Session["SpParam"] != null)
                {
                    var overAllParams = (DictionaryExt<int, List<ReportFilterCtrlSet>, List<ReportFilterCtrlSet>>)Session["SpParam"];
                    var currentParamResult = overAllParams[key];
                    var currentRptParam = currentParamResult.FirstOrDefault().Value;
                    previousFilters = currentRptParam;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return previousFilters;
        }

        List<ReportFilterCtrlSet> GetCurrentSearchFilters()
        {
            var searchFilters = new List<ReportFilterCtrlSet>();
            try
            {
                foreach (Panel trDiv in aspPanelFilter.Controls)
                {
                    foreach (Panel tdDiv in trDiv.Controls)
                    {
                        foreach (Panel formGroup in tdDiv.Controls)
                        {
                            foreach (var ctrlPanel in formGroup.Controls)
                            {
                                if (ctrlPanel.GetType().Name == PANEL_CTRL)
                                {
                                    var panelCtrl = (Panel)ctrlPanel;
                                    foreach (Panel ctrlPanelFluid in panelCtrl.Controls)
                                    {
                                        foreach (var ctrl in ctrlPanelFluid.Controls)
                                        {
                                            if (ctrl.GetType().Name == TXT_CTRL)
                                            {
                                                var textBoxCtrl = (TextBox)ctrl;
                                                var txtID = textBoxCtrl.ID.Trim();
                                                var txtText = string.Empty;
                                                var txtValue = string.Empty;
                                                var IsDateField = textBoxCtrl.CssClass.Contains("datePicker") || textBoxCtrl.CssClass.Contains("dateTimePicker");
                                                if (IsDateField)
                                                {
                                                    var inputDate = textBoxCtrl.Text.Trim();
                                                    if (!string.IsNullOrEmpty(inputDate))
                                                    {
                                                        var convertedDate = DateTime.Parse(inputDate).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                                                        txtText = textBoxCtrl.Text.Trim();
                                                        txtValue = convertedDate.ToString();
                                                    }
                                                }
                                                else
                                                {
                                                    txtText = textBoxCtrl.Text.Trim();
                                                    txtValue = textBoxCtrl.Text.Trim();
                                                }
                                                searchFilters.Add(new ReportFilterCtrlSet(TXT_CTRL, txtID, txtText, txtValue, textBoxCtrl.Visible, textBoxCtrl.Enabled, IsDateField));
                                                var hiddenCtrl = (HiddenField)aspPanelFilter.FindControl(HIDDEN_PREFIX + txtID);
                                                hiddenCtrl.Value = txtText;
                                            }
                                            else if (ctrl.GetType().Name == DROP_DOWN_CTRL)
                                            {
                                                //var dropDownCtrl = (DropDownListExt)ctrl;
                                                //var ddlID = dropDownCtrl.ID.Trim();
                                                //var ddlValue = dropDownCtrl.SelectedItem.Value.Trim();
                                                //var ddlText = dropDownCtrl.SelectedItem.Text.Trim();
                                                //searchFilters.Add(new ReportFilterCtrlSet(DROP_DOWN_CTRL, ddlID, ddlText, ddlValue, dropDownCtrl.Visible, dropDownCtrl.Enabled, false));
                                                //var hiddenCtrl = (HiddenField)aspPanelFilter.FindControl(HIDDEN_PREFIX + ddlID);
                                                //hiddenCtrl.Value = ddlValue;

                                                var dropDownCtrl = (DropDownListExt)ctrl;
                                                var ddlID = dropDownCtrl.ID.Trim();
                                                var ddlValue = string.Empty;
                                                if (dropDownCtrl.Visible)
                                                {
                                                    ddlValue = dropDownCtrl.SelectedItem.Value.Trim();
                                                    var ddlText = dropDownCtrl.SelectedItem.Text.Trim();
                                                    searchFilters.Add(new ReportFilterCtrlSet(DROP_DOWN_CTRL, ddlID, ddlText, ddlValue, dropDownCtrl.Visible, dropDownCtrl.Enabled, false));
                                                }
                                                else
                                                {
                                                    searchFilters.Add(new ReportFilterCtrlSet(DROP_DOWN_CTRL, ddlID, DBNull.Value.ToString(), DBNull.Value.ToString(), dropDownCtrl.Visible, dropDownCtrl.Enabled, false));
                                                }
                                                var hiddenCtrl = (HiddenField)aspPanelFilter.FindControl(HIDDEN_PREFIX + ddlID);
                                                hiddenCtrl.Value = ddlValue;
                                            }
                                        }
                                    }
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
            return searchFilters;
        }

        void SetSearchFilters(EventArgsExt e)
        {
            try
            {
                if (Session["SpParam"] != null)
                {
                    var overAllParams = (DictionaryExt<int, List<ReportFilterCtrlSet>, List<ReportFilterCtrlSet>>)Session["SpParam"];
                    var currentParamResult = overAllParams[e.rptMstEntity.ParentReportID];
                    var currentRptParam = currentParamResult.FirstOrDefault().Value;
                    var currentHiddenParam = currentParamResult.FirstOrDefault().Key;
                    currentHiddenParam.ForEach(hc => { currentRptParam.Add(hc); });
                    foreach (Panel trDiv in aspPanelFilter.Controls)
                    {
                        foreach (Panel tdDiv in trDiv.Controls)
                        {
                            foreach (Panel formGroup in tdDiv.Controls)
                            {
                                foreach (var ctrlPanel in formGroup.Controls)
                                {
                                    if (ctrlPanel.GetType().Name == PANEL_CTRL)
                                    {
                                        var panelCtrl = (Panel)ctrlPanel;
                                        foreach (Panel ctrlPanelFluid in panelCtrl.Controls)
                                        {
                                            foreach (var ctrl in ctrlPanelFluid.Controls)
                                            {
                                                if (ctrl.GetType().Name == TXT_CTRL)
                                                {
                                                    var textBoxCtrl = (TextBox)ctrl;
                                                    var txtID = textBoxCtrl.ID.Trim();
                                                    var txtValue = currentRptParam.FirstOrDefault(x => x.CtrlID == txtID).CtrlText;
                                                    textBoxCtrl.ViewStateMode = ViewStateMode.Enabled;
                                                    var hiddenCtrl = (HiddenField)aspPanelFilter.FindControl(HIDDEN_PREFIX + txtID);
                                                    hiddenCtrl.Value = txtValue;
                                                    hiddenCtrl.ViewStateMode = ViewStateMode.Enabled;
                                                }
                                                else if (ctrl.GetType().Name == DROP_DOWN_CTRL)
                                                {
                                                    var dropDownCtrl = (DropDownList)ctrl;
                                                    var ddlID = dropDownCtrl.ID.Trim();
                                                    var ddlValue = currentRptParam.FirstOrDefault(x => x.CtrlID == ddlID).CtrlValue;
                                                    dropDownCtrl.SelectedValue = ddlValue;
                                                    dropDownCtrl.ViewStateMode = ViewStateMode.Enabled;
                                                    var hiddenCtrl = (HiddenField)aspPanelFilter.FindControl(HIDDEN_PREFIX + ddlID);
                                                    hiddenCtrl.Value = ddlValue;
                                                    hiddenCtrl.ViewStateMode = ViewStateMode.Enabled;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                this.btnSearch_Click(null, e);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}