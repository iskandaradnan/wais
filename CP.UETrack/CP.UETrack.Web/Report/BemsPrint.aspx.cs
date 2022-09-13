using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.Report
{
    public partial class BemsPrint : System.Web.UI.Page
    {
        //ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public string userName = ConfigurationManager.AppSettings["SsrsUserName"].ToString();
        public string passWord = ConfigurationManager.AppSettings["SsrsPassword"].ToString();
        public string domain = ConfigurationManager.AppSettings["SsrsDomain"].ToString();
        public string reportServerUrl = ConfigurationManager.AppSettings["SsrsReportServerUrl"].ToString();
        public string reportPath = ConfigurationManager.AppSettings["SsrsReportPath"].ToString();
        public string CAMISReportFolderName = ConfigurationManager.AppSettings["CAMISBemsPrintFolderName"].ToString();
        //  public string CAMISReportInnerFolderName = ConfigurationManager.AppSettings["CAMISBemsReportInnerFolderName"].ToString();



        public static bool isParametersNeedToShow = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            try

            {
                UserDetailsModel _UserSession = new SessionHelper().UserSession();

                HttpContext ctx = default(HttpContext);
                ctx = HttpContext.Current;
                var FacilityID = _UserSession.FacilityId;

                var ReportName = Request.QueryString["Reportname"];
                ReportName = CAMISReportFolderName + ReportName;

                //ReportName =  ReportName;
                reportViewer.ProcessingMode = ProcessingMode.Remote;
                IReportServerCredentials irsc = new CustomReportCredentials(this.userName, this.passWord, this.domain);
                reportViewer.ServerReport.ReportServerCredentials = irsc;
                reportViewer.ServerReport.ReportServerUrl = new Uri(this.reportServerUrl);
                if (ReportName == null)
                    reportViewer.ServerReport.ReportPath = this.reportPath + @"StateReport";
                else
                    reportViewer.ServerReport.ReportPath = this.reportPath + ReportName;

                reportViewer.PromptAreaCollapsed = true;
                //rptViewer.ShowParameterPrompts = false;
                reportViewer.ShowParameterPrompts = isParametersNeedToShow;

                int parameterCount = Request.QueryString.Count;

                //FieldInfo info;
                //foreach (RenderingExtension re in rptViewer.ServerReport.ListRenderingExtensions())
                //{
                //    if ((re.Name != "PDF") /*&& (re.Name != "CSV")*/ && (re.Name != "EXCEL") && (re.Name != "EXCELOPENXML"))
                //    {
                //        info = re.GetType().GetField("m_isVisible", BindingFlags.Instance | BindingFlags.NonPublic);
                //        info.SetValue(re, false);
                //    }
                //}

                if (parameterCount >= 2) // Report name and Another parameter is Must so count is greater than or equal to 2
                {
                    ReportParameter[] rptPara = null;
                    int ii = 0;
                    rptPara = new ReportParameter[parameterCount];
                    rptPara = rptPara.Skip(1).ToArray();  // Report Name parameter should be avoided for report processing so skip (1) ,it remove first array
                    string paramValues = null;
                    string[] paramValuesArray = null;
                    bool bCommaExists = false;
                    var AllKeyValueParameters = Request.QueryString.AllKeys.Skip(1); // Report Name parameter should be avoided for report processing so skip (1) ,it remove first array
                    foreach (String key in AllKeyValueParameters)
                    {
                        if (key == "Report")
                            continue;
                        var Ishospitalcolumn = Request.QueryString[key];
                        if (Ishospitalcolumn == "FacilityId")
                            paramValues = Convert.ToString(FacilityID);
                        else
                            paramValues = Request.QueryString[key];
                        bCommaExists = paramValues.Contains(",");
                        if (bCommaExists == true)
                        {

                            paramValuesArray = paramValues.Split(',');
                            //Response.Write("Key: " + key + " Value: " + Request.QueryString[key]);
                            rptPara[ii] = new ReportParameter(key, paramValuesArray);

                            //rptPara[ii] = new ReportParameter(key, paramValues);
                        }
                        else
                        {
                            //Response.Write("Key: " + key + " Value: " + Request.QueryString[key]);
                            rptPara[ii] = new ReportParameter(key, paramValues);
                        }
                        ii++;
                    }

                    if (rptPara != null)
                    {
                        reportViewer.ServerReport.SetParameters(rptPara);
                    }

                }
                DisableUnwantedExportFormats(reportViewer.ServerReport);
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DisableUnwantedExportFormats(ServerReport rvServer)
        {
            foreach (RenderingExtension re in rvServer.ListRenderingExtensions())
            {
                if ((re.Name != "PDF") /*&& (re.Name != "CSV")*/ && (re.Name != "EXCEL") && (re.Name != "EXCELOPENXML"))
                {
                    re.GetType().GetField("m_isVisible", BindingFlags.Instance | BindingFlags.NonPublic).SetValue(re, false);
                }
            }
        }

        protected void rptViewer_PreRender(object sender, EventArgs e)
        {

            HttpContext ctx = default(HttpContext);
            ctx = HttpContext.Current;


            if (ctx.Session["LoginId"] == null)
            {

                if (Context.Session.IsNewSession == true)
                {
                    if (ctx.Request.Headers["X-Requested-With"] != null)
                    {
                        //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "", "<script type='text/javascript' language='javascript'>parent.location.replace('/ASISBI/Login/UserLogin');</script>");
                        //Response.RedirectToRoute("LogOutDuringSessionExpire");
                        Response.RedirectToRoute(new { controller = "Login", action = "UserSession" });
                    }
                }


            }
            else
            {

                DisableUnwantedExportFormats(reportViewer.ServerReport);
            }

        }
    }
}