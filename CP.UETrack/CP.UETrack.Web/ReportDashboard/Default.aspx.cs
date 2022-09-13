using CP.Framework.Common.StateManagement;
using CP.Framework.ReportHelper;
using CP.UETrack.CodeLib.Helpers;
using Microsoft.Reporting.WebForms;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.ReportDashboard
{
    public partial class Default : System.Web.UI.Page
    {
        ReportExcelDataHealper redh { get; }
        ReportApiHelper reportAPI { get; }
        ReportBaseData rptBd = new ReportBaseData();
        public string ReportExportName { get; set; }
        public bool IsDrillThrough { get; set; }

        public Default()
        {
            try
            {
                this.redh = new ReportExcelDataHealper();
                this.reportAPI = new ReportApiHelper();
            }
            catch (Exception ex)
            {
                //throw new Exception(ex.ToString());
                errorTitle.Visible = true;
                //errorDetail.Visible = true;
                UETrackLogger.Log(string.Format("Error initializing report!"));
                UETrackLogger.Log(ex);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            var sessionSpName = string.Empty;
            var sessionReportKeyId = string.Empty;
            var resultSpname_With = string.Empty;
            var url = string.Empty;
            try
            {
                var ctx = default(HttpContext);
                ctx = HttpContext.Current;
                var multiTabCheck = ctx.Request.Url.ToString().IndexOf("common/multipleTabCheck") > -1;
                url = ctx.Request.Url.ToString().ToLower();

                var sessionDetailsDifferent = false;
                var request = HttpContext.Current.Request;
                var companyId = string.Empty;
                var hospitalId = string.Empty;
                var serviceId = string.Empty;
                var spnameId = string.Empty;
                var reportkeyId = string.Empty;
                var spnameId_with = string.Empty;

                var CompanyID_ID = string.Empty;
                var HospitalID_ID = string.Empty;
                var ServiceID_ID = string.Empty;
                var oldSpname = string.Empty;
                var oldreportkeyId = string.Empty;
                var oldSpname_with = string.Empty;

                this.excelPath = ((string)Session["CurrentRptPath"]) + "ReportData.xls";
                this.currentRptPath = (string)Session["CurrentRptPath"];
                sessionSpName = Session["SpName"] == null ? DEFAULT_REPORT : Session["SpName"].ToString();
                resultSpname_With = Session["SpName"] == null ? DEFAULT_REPORT : Session["SpName"].ToString();
                sessionReportKeyId = Session["ReportKeyId"] == null ? DEFAULT_REPORT_KEY_ID : Session["ReportKeyId"].ToString();

                {
                    //var requestURL = HttpContext.Current.Request.Url.AbsoluteUri;                      
                }

                if (sessionSpName.Split('/').Where(x => x != string.Empty).Select(x => x).ToList().Count > 1)
                {
                    sessionSpName = sessionSpName.Split('/').Where(x => x != string.Empty).Select(x => x).ToList().ElementAt(1);
                }
                else
                {
                    //errorTitle.Visible = true;                     
                    UETrackLogger.Log(string.Format("Error loading report. SessionSpName is empty!"));
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirect();", true);
                }

                if (new SessionHelper().IsSessionExists())
                {
                    var Get_userDetails = new SessionHelper().UserSession();
                    if (Get_userDetails != null)
                    {
                        var resultHospitalId = Get_userDetails.FacilityId;//this.GetSessionPropValueByPropName(HOSPITAL_ID_SESSION);
                        var resultCompanyId = Get_userDetails.CustomerId; // this.GetSessionPropValueByPropName(COMPANY_ID_SESSION);
                        var resultServiceId = Get_userDetails.ServiceId; //this.GetSessionPropValueByPropName(SERVICE_ID_SESSION);  
                        var resultSpname = sessionSpName;
                        var resultReportKeyId = sessionReportKeyId;

                        if (ViewState["rptSpname"] != null)
                        {
                            oldSpname = ViewState["rptSpname"].ToString();
                            oldreportkeyId = ViewState["rptReportKeyId"].ToString();
                            oldSpname_with = ViewState["rptSpname_With"].ToString();
                        }

                        if (ViewState["rptCompanyId"] != null && ViewState["rpttHospitalId"] != null && ViewState["rpttServiceId"] != null)
                        {
                            CompanyID_ID = ViewState["rptCompanyId"].ToString() == null ? "" : ViewState["rptCompanyId"].ToString();
                            HospitalID_ID = ViewState["rpttHospitalId"].ToString() == null ? "" : ViewState["rpttHospitalId"].ToString();
                            ServiceID_ID = ViewState["rpttServiceId"].ToString() == null ? "" : ViewState["rpttServiceId"].ToString();
                        }

                        ViewState["rpttHospitalId"] = resultHospitalId;
                        ViewState["rptCompanyId"] = resultCompanyId;
                        ViewState["rpttServiceId"] = resultServiceId;

                        if (!IsPostBack)
                        {
                            ViewState["rptSpname"] = resultSpname;
                            ViewState["rptReportKeyId"] = resultReportKeyId;
                            ViewState["rptSpname_With"] = resultSpname_With;

                            if (oldSpname != string.Empty) spnameId = oldSpname;
                            if (oldreportkeyId != string.Empty) reportkeyId = oldreportkeyId;
                            if (oldSpname_with != string.Empty) spnameId_with = oldSpname_with;
                        }

                        if (CompanyID_ID != string.Empty) companyId = CompanyID_ID;
                        if (HospitalID_ID != string.Empty) hospitalId = HospitalID_ID;
                        if (ServiceID_ID != string.Empty) serviceId = ServiceID_ID;


                        if (companyId != "" && hospitalId != "" && serviceId != "")
                        {
                            if (new SessionHelper().IsSessionExists())
                            {
                                var userDetails = new SessionHelper().UserSession();
                                if (userDetails == null)
                                {
                                    sessionDetailsDifferent = false;
                                }
                                var companyIdInSession = userDetails.FacilityId;
                                var hospitalIdInSession = userDetails.CustomerId;
                                var serviceIdInSession = userDetails.ServiceId;

                                var intCompanyId = int.Parse(companyId);
                                var intHospitalId = int.Parse(hospitalId);
                                var intServiceId = int.Parse(serviceId);

                                if (intCompanyId != companyIdInSession || intHospitalId != hospitalIdInSession || intServiceId != serviceIdInSession)
                                {
                                    sessionDetailsDifferent = true;
                                }

                            }
                        }
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirect();", true);
                }
                if (!multiTabCheck)
                {
                    if (sessionDetailsDifferent)
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirecttohome();", true);
                    }

                    else if (!string.IsNullOrEmpty(sessionSpName) && !string.IsNullOrEmpty(sessionReportKeyId) && !IsPostBack)
                    {

                        var argExt = new EventArgsExt
                        {
                            rptMstEntity = this.BuildRptFilterAndPaginationAndSetDrillCtrl(sessionSpName, sessionReportKeyId)
                        };
                        if (!IsPostBack)
                        {
                            this.SetSearchFilters(argExt);

                        }
                    }
                    else if (!string.IsNullOrEmpty(oldSpname) && !string.IsNullOrEmpty(oldreportkeyId) && IsPostBack)
                    {

                        var argExt = new EventArgsExt
                        {
                            rptMstEntity = this.BuildRptFilterAndPaginationAndSetDrillCtrl(oldSpname, oldreportkeyId)
                        };
                        if (!IsPostBack)
                        {
                            this.SetSearchFilters(argExt);

                        }
                    }
                }
                else
                {
                    if (sessionDetailsDifferent)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirecttohome();", true);
                    }
                    errorTitle.Visible = true;
                    //errorDetail.Visible = true;
                    UETrackLogger.Log(string.Format("Error loading report. SessionSpName is empty!"));
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirect();", true);
                }

            }

            catch (Exception ex)
            {
                //throw new Exception(ex.ToString());
                errorTitle.Visible = true;
                //errorDetail.Visible = true;
                UETrackLogger.Log(string.Format("Error loading report. SessionSpName={0}", sessionSpName));
                UETrackLogger.Log(ex);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "javascript:Redirect();", true);
            }
        }

        ReportMasterEntity BuildRptFilterAndPaginationAndSetDrillCtrl(string currentSpName, string reportKeyId)
        {
            try
            {
                if (!string.IsNullOrEmpty(currentSpName))
                {
                    var rptMstEntity = this.GetReportMstEntity(currentSpName, reportKeyId).Result;
                    if (rptMstEntity != null)
                    {
                        var paraValues = new List<string>();
                        var paramList = new List<SqlParameter>();
                        if (rptMstEntity.ParamEntity != null && rptMstEntity.ParamEntity.Count > 0)
                        {
                            rptMstEntity.ParamEntity.ForEach(param =>
                            {
                                var str = param.ReportParamValue.Trim().ToLower() == NULL_KEY ? null : param.ReportParamValue.Trim();
                                paraValues.Add(str);
                            });
                        }
                        paraValues.Insert(0, null);
                        if (paraValues.Count == 1 && string.IsNullOrEmpty(paraValues[0]))
                        {
                            paramList = reportAPI.GetSqlParmsList(rptMstEntity.ConnectionStringName, rptMstEntity.SpName, null);
                        }
                        else
                        {
                            paramList = reportAPI.GetSqlParmsList(rptMstEntity.ConnectionStringName, rptMstEntity.SpName, paraValues);
                        }
                        rptMstEntity.SqlParamArray = paramList == null ? null : paramList.ToArray();

                        this.BuildRptSearchCtrlTemplate(rptMstEntity);

                        return rptMstEntity;
                    }
                    throw new Exception("ReportMasterEntity is null");
                }
                throw new Exception("SpName is NullOrEmpty");
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        async Task<ReportMasterEntity> GetReportMstEntity(string spName, string reportKeyId)
        {
            try
            {
                if (!string.IsNullOrEmpty(spName))
                {
                    var rptMstEntity = new ReportMasterEntity();

                    var result = await RestHelper.ApiGet(string.Format("ReportFilter/GetReportParameters/{0}/{1}", spName, reportKeyId));
                    var jsonString = result.Content.ReadAsStringAsync();
                    rptMstEntity = JsonConvert.DeserializeObject<ReportMasterEntity>(jsonString.Result);

                    rptMstEntity.ConnectionStringName = this.connStringName;
                    rptMstEntity.SpName = spName;

                    var currentReportId = rptMstEntity.ParamEntity.FirstOrDefault().ParentReportId;
                    if (!string.IsNullOrEmpty(currentReportId))
                    {
                        var Id = 0;
                        if (int.TryParse(currentReportId, out Id))
                        {
                            rptMstEntity.CurrentReportID = Id;
                        }
                    }

                    return rptMstEntity;
                }


                return null;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        void BuildRptSearchCtrlTemplate(ReportMasterEntity rptMstEntity)
        {
            try
            {
                var paraFlag = rptMstEntity.ParamEntity != null && rptMstEntity.ParamEntity.Count > 0;
                if (paraFlag)
                {
                    var paraLength = rptMstEntity.SqlParamArray.Length;
                    var limitedParaCount = 0;
                    limitedParaCount = rptMstEntity.ParamEntity.Where(x => !x.ReportParamName.Contains("Page")).Count();

                    if (limitedParaCount + 1 == paraLength)
                    {
                        this.BuildRptFilterCtrlTemplate(rptMstEntity);
                    }
                    else
                    {
                        throw new Exception("ParamDetails_Sheet Count and Sql Param Count are Mismatched.");
                    }
                }
                else
                {
                    this.LoadReport(rptMstEntity);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        void btnSearch_Click(object sender, EventArgsExt e)
        {
            try
            {
                var searchParams = this.GetCurrentSearchFilters();
                var rptMstEntity = e.rptMstEntity;
                var paramList = this.BuildSpParameter(searchParams);
                rptMstEntity.SqlParamArray = paramList == null ? null : paramList.ToArray();
                if (rptMstEntity.ParamEntity.Count == searchParams.Count)
                {
                    rptMstEntity.ParamEntity.ForEach(p =>
                    {
                        var idx = rptMstEntity.ParamEntity.IndexOf(p);
                        p.ReportParamName = searchParams[idx].CtrlID;
                        p.ReportParamValue = searchParams[idx].CtrlValue;
                    });
                    this.LoadReport(rptMstEntity);
                }
                else
                {
                    throw new Exception("Parameter Count is Mismatch");
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        List<SqlParameter> BuildSpParameter(List<ReportFilterCtrlSet> InputFields)
        {
            var sqlParams = new List<SqlParameter>();
            try
            {
                InputFields = InputFields.Where(x => !x.CtrlID.Contains("Page")).ToList();
                foreach (var field in InputFields)
                {
                    var param = new SqlParameter("@" + field.CtrlID, field.CtrlValue.ToLower());
                    sqlParams.Add(param);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return sqlParams;
        }

        ReportViewer LoadReport(ReportMasterEntity rptMstEntity)
        {
            try
            {
                ReportParameter[] rptPara = null;
                var paraFlag = rptMstEntity.ParamEntity != null && rptMstEntity.ParamEntity.Count > 0;
                if (paraFlag)
                {
                    var paraLength = rptMstEntity.SqlParamArray.Length;
                    var limitedParaCount = rptMstEntity.ParamEntity.Where(x => !x.ReportParamName.Contains("Page"));
                    if (limitedParaCount.Count() == paraLength)
                    {
                        rptPara = new ReportParameter[limitedParaCount.Count() + 1];
                        rptMstEntity.ParamEntity.Where(x => !x.ReportParamName.Contains("Page")).ToList().ForEach(para =>
                        {
                            var idx = rptMstEntity.ParamEntity.Where(x => !x.ReportParamName.Contains("Page")).ToList().IndexOf(para);
                            rptPara[idx] = new ReportParameter(para.ReportParamName, para.ReportParamValue);
                        });
                        //Added Menu name with param entity
                        rptPara[rptPara.Count() - 1] = new ReportParameter("MenuName", SessionProviderFactory.GetSessionProvider().Get("CurrentMenuName").ToString());
                    }
                    else
                    {
                        throw new Exception("ParamDetails_Sheet Count and Sql Param Count are Mismatched.");
                    }

                }
                if (!string.IsNullOrEmpty(this.currentRptPath))
                {
                    var ReportName = string.Empty;
                    if (!IsPostBack)
                    {
                        ReportName = Session["SpName"].ToString();
                    }
                    else
                    {
                        ReportName = ViewState["rptSpname_With"].ToString();
                    }
                    rptViewer.ProcessingMode = ProcessingMode.Remote;
                    IReportServerCredentials irsc = new CustomReportCredentials(rptBd.userName, rptBd.passWord, rptBd.domain);
                    rptViewer.Reset();

                    // Making controls visible when report details loaded from report server
                    rptViewer.ShowToolBar = true;
                    rptViewer.ShowRefreshButton = true;
                    rptViewer.ShowPageNavigationControls = true;
                    rptViewer.ShowBackButton = true;
                    rptViewer.ShowPrintButton = true;
                    rptViewer.ServerReport.ReportServerCredentials = irsc;
                    rptViewer.ServerReport.ReportServerUrl = new Uri(rptBd.reportServerUrl);
                    if (ReportName == null)
                    {
                        errorTitle.Visible = true;
                        //errorDetail.Visible = true;
                        UETrackLogger.Log(string.Format("Error loading report. SessionSpName is empty!"));
                    }
                    else
                    {
                        rptViewer.ServerReport.ReportPath = rptBd.reportPath + ReportName;

                        rptViewer.ShowParameterPrompts = false;

                        if (rptPara != null)
                        {
                            rptViewer.ServerReport.SetParameters(rptPara);
                        }
                    }
                    return rptViewer;
                }

                throw new Exception("currentRptPath Local Variable Is NullOrEmpty");
            }
            catch (ReportServerException)
            {
                errorTitle.Visible = true;
                //errorDetail.Visible = true;
                UETrackLogger.Log(string.Format("Error loading report. SessionSpName is empty!"));
                return rptViewer;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ScreenName"]) && !IsDrillThrough)
            {
                ReportExportName = Request.QueryString["ScreenName"].ToString() + "_" + "L1";
            }
            rptViewer.ServerReport.DisplayName = ReportExportName;
        }

        protected void rptViewer_Drillthrough(object sender, DrillthroughEventArgs e)
        {
            IsDrillThrough = true;
            ReportExportName = Request.QueryString["ScreenName"].ToString() + e.ReportPath.Substring(e.ReportPath.LastIndexOf("_"), e.ReportPath.Length - e.ReportPath.LastIndexOf("_"));
        }

        protected void rptViewer_Back(object sender, BackEventArgs e)
        {
            IsDrillThrough = true;
            ReportExportName = e.ParentReport.DisplayName;
        }

        protected void rptViewer_ReportRefresh(object sender, System.ComponentModel.CancelEventArgs e)
        {
            IsDrillThrough = true;
            ReportExportName = rptViewer.ServerReport.DisplayName;
        }

    }
}