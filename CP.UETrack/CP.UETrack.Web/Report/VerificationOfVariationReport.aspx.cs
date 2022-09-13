using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{

    public partial class VerificationOfVariationReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var VOVFromYear = Request.QueryString["VOVFromYear"];
                    var VOVFromMonth = Request.QueryString["VOVFromMonth"];
                    var VOVToYear = Request.QueryString["VOVToyear"];
                    var VOVTomonth = Request.QueryString["VOVTomonth"];

                    if (VOVToYear == "null")
                    {
                        VOVToYear = null;
                    }
                    if (VOVTomonth == "null")
                    {
                        VOVTomonth = null;
                    }

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\VVF_L1.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("uspFM_VMVFEquipmentBEMS_L1",VOVFromYear, VOVFromMonth, VOVToYear, VOVTomonth));
                    reportViewer.LocalReport.DataSources.Clear();
                    reportViewer.LocalReport.DataSources.Add(datasource);                  
                    reportViewer.LocalReport.Refresh();
                }
                else
                {
                    reportViewer.Drillthrough += new DrillthroughEventHandler(reportViewer_Drillthrough);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        protected void reportViewer_Drillthrough(object sender, DrillthroughEventArgs e)
        {
            ReportParameterInfoCollection DrillThroughValues = e.Report.GetParameters();
            var MonthYear  = DrillThroughValues[0].Values[0];
            var temp = MonthYear.Split();
            var month = temp[0];
            int monthNum = DateTime.ParseExact(month, "MMMM", CultureInfo.CurrentCulture).Month;
            month = Convert.ToString(monthNum); 
            var Year = temp[1]; ;
            var VOVFromYear = Request.QueryString["VOVFromYear"];
            var VOVFromMonth = Request.QueryString["VOVFromMonth"];
            var VOVToYear = Request.QueryString["VOVToyear"];
            var VOVTomonth = Request.QueryString["VOVTomonth"];

            if (VOVToYear == "null")
            {
                VOVToYear = null;
            }
            if (VOVTomonth == "null")
            {
                VOVTomonth = null;
            }
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("uspFM_VMVFEquipmentBEMS_L2", GetSPResult("uspFM_VMVFEquipmentBEMS_L2", VOVFromYear, VOVFromMonth, VOVToYear, VOVTomonth, month, Year));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname, string VOVFromYear, string VOVFromMonth, string VOVToYear, string VOVTomonth, string month="", string year = "")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "uspFM_VMVFEquipmentBEMS_L1":
                                    cmd.CommandText = "uspFM_VMVFEquipmentBEMS_L1";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@VOVFromMonth", VOVFromMonth);
                                    cmd.Parameters.AddWithValue("@VOVFromYear", VOVFromYear);
                                    cmd.Parameters.AddWithValue("@VOVTomonth", VOVTomonth);
                                    cmd.Parameters.AddWithValue("@VOVToYear", VOVToYear);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_VMVFEquipmentBEMS_L2":
                                    cmd.CommandText = "uspFM_VMVFEquipmentBEMS_L2";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@VOVFromMonth", month);
                                    cmd.Parameters.AddWithValue("@VOVFromYear", year);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                                                
                            }

                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }
                }
                return ResultsTable;
            }
        }

    }
}