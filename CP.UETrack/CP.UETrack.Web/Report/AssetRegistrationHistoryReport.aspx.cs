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
    public partial class AssetRegistrationHistoryReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var AssetCategory = Request.QueryString["AssetCategory"];
                    var AssetStatus = Request.QueryString["AssetStatus"];
                    var Typecode = Request.QueryString["Typecode"];
                    var VariationStatus = Request.QueryString["VariationStatus"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\AssetRegistrationRpt.rdlc";
                    var datasource = new ReportDataSource("usp_BEMSAssetRegistration_Rpt", GetSPResult("usp_BEMSAssetRegistration_Rpt", AssetCategory, AssetStatus, Typecode, VariationStatus));
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
            var ParameterName = DrillThroughValues[0].Values[0];
            var AssetCategory = Request.QueryString["AssetCategory"];
            var AssetStatus = Request.QueryString["AssetStatus"];
            var Typecode = Request.QueryString["Typecode"];
            var VariationStatus = Request.QueryString["VariationStatus"];


            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("usp_BEMSAssetRegistration_Rpt_L2", GetSPResult("usp_BEMSAssetRegistration_Rpt_L2", AssetCategory, AssetStatus, Typecode, VariationStatus, ParameterName));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();


            var datasource1 = new ReportDataSource("usp_BEMSAssetRegistration_Rpt_L3", GetSPResult("usp_BEMSAssetRegistration_Rpt_L3", AssetCategory, AssetStatus, Typecode, VariationStatus, ParameterName));
            localreport.DataSources.Add(datasource1);
            localreport.Refresh();

            var datasource2 = new ReportDataSource("usp_BEMSAssetRegistration_Rpt_L4", GetSPResult("usp_BEMSAssetRegistration_Rpt_L4", AssetCategory, AssetStatus, Typecode, VariationStatus, ParameterName));
            localreport.DataSources.Add(datasource2);
            localreport.Refresh();
        }
        private DataTable GetSPResult(string Spname, string AssetCategory, string AssetStatus, string Typecode, string VariationStatus, string ParameterName="")
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
                                case "usp_BEMSAssetRegistration_Rpt":
                                    cmd.CommandText = "usp_BEMSAssetRegistration_Rpt";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@AssetCategory", AssetCategory);
                                    cmd.Parameters.AddWithValue("@AssetStatus", AssetStatus);
                                    cmd.Parameters.AddWithValue("@Typecode", Typecode);
                                    cmd.Parameters.AddWithValue("@VariationStatus", VariationStatus);
                                    cmd.Parameters.AddWithValue("@Level", "1");
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_BEMSAssetRegistration_Rpt_L2":
                                    cmd.CommandText = "usp_BEMSAssetRegistration_Rpt_L2";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@AssetCategory", AssetCategory);
                                    cmd.Parameters.AddWithValue("@AssetStatus", AssetStatus);
                                    cmd.Parameters.AddWithValue("@Typecode", Typecode);
                                    cmd.Parameters.AddWithValue("@VariationStatus", VariationStatus);
                                    cmd.Parameters.AddWithValue("@Level", "1");
                                    cmd.Parameters.AddWithValue("@AssetNo", ParameterName);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_BEMSAssetRegistration_Rpt_L3":
                                    cmd.CommandText = "usp_BEMSAssetRegistration_Rpt_L3";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@AssetCategory", AssetCategory);
                                    cmd.Parameters.AddWithValue("@AssetStatus", AssetStatus);
                                    cmd.Parameters.AddWithValue("@Typecode", Typecode);
                                    cmd.Parameters.AddWithValue("@VariationStatus", VariationStatus);
                                    cmd.Parameters.AddWithValue("@Level", "1");
                                    cmd.Parameters.AddWithValue("@AssetNo", ParameterName);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_BEMSAssetRegistration_Rpt_L4":
                                    cmd.CommandText = "usp_BEMSAssetRegistration_Rpt_L4";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@AssetCategory", AssetCategory);
                                    cmd.Parameters.AddWithValue("@AssetStatus", AssetStatus);
                                    cmd.Parameters.AddWithValue("@Typecode", Typecode);
                                    cmd.Parameters.AddWithValue("@VariationStatus", VariationStatus);
                                    cmd.Parameters.AddWithValue("@Level", "1");
                                    cmd.Parameters.AddWithValue("@AssetNo", ParameterName);
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