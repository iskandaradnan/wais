using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class CRMReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    reportViewer.Visible = true;
                    var CRMfromdate = Request.QueryString["CRMFromDate"];
                    var CRMtodate = Request.QueryString["CRMToDate"];
                    var CRMrequesttype= Request.QueryString["CRMRequestType"];
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BEMS_CRM_Rpt.rdlc";
                    var datasource = new ReportDataSource("uspFM_CRMRequest_Rpt", GetSPResult("uspFM_CRMRequest_Rpt", CRMfromdate, CRMtodate, CRMrequesttype));
                    var datasource1 = new ReportDataSource("uspFM_From_To_Rpt", GetSPResult("uspFM_From_To_Rpt", CRMfromdate, CRMtodate, CRMrequesttype));
                    var datasource2 = new ReportDataSource("uspFM_GetTypeOfRequest_Rpt", GetSPResult("uspFM_GetTypeOfRequest_Rpt", CRMfromdate, CRMtodate, CRMrequesttype));
                    var datasource3 = new ReportDataSource("uspFM_GetCustomer_Rpt", GetSPResult("uspFM_GetCustomer_Rpt", CRMfromdate, CRMtodate, CRMrequesttype));
                    reportViewer.LocalReport.DataSources.Clear();
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);
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
            var parameterName = DrillThroughValues[0].Values[0];
            var CRMfromdate = Request.QueryString["CRMFromDate"];
            var CRMtodate = Request.QueryString["CRMToDate"];
            var CRMrequesttype = Request.QueryString["CRMRequestType"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            //if (e.ReportPath.Trim() == "L1")
            //{
                DatasetName = "uspFM_CRMRequest_Details_Rpt";
            //}
            //else
            //{
            //    DatasetName = "B2";
            //}

            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource(DatasetName, GetSPResult("uspFM_CRMRequest_Details_Rpt", CRMfromdate, CRMtodate, CRMrequesttype, parameterName));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname,string CRMfromdate, string CRMtodate,string CRMrequesttype, string CRMNo = "")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                var Get_userDetails = new SessionHelper().UserSession();
                try
                {
                    if (CRMrequesttype == "null")
                    {
                        CRMrequesttype = ""; 
                    }
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "uspFM_CRMRequest_Rpt":
                                    cmd.CommandText = "uspFM_CRMRequest_Rpt"; 
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", CRMfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", CRMtodate);
                                    cmd.Parameters.AddWithValue("@RequestType", CRMrequesttype);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_From_To_Rpt":
                                    cmd.CommandText = "uspFM_From_To_Rpt"; 
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@From_Date", CRMfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", CRMtodate);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_GetTypeOfRequest_Rpt":
                                    cmd.CommandText = "uspFM_GetTypeOfRequest_Rpt";   
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@RequestType", CRMrequesttype);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_GetCustomer_Rpt":
                                    cmd.CommandText = "uspFM_GetCustomer_Rpt";  
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_CRMRequest_Details_Rpt":
                                    cmd.CommandText = "uspFM_CRMRequest_Details_Rpt";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@CRMWorkOrderNo", CRMNo);
                                    cmd.Parameters.AddWithValue("@From_Date", CRMfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", CRMtodate);
                                    cmd.Parameters.AddWithValue("@RequestType", CRMrequesttype);
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