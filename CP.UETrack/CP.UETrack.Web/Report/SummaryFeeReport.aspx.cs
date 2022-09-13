using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class SummaryFeeReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Assetfromdate = Request.QueryString["Fromdate"];
                    var AssetTodate = Request.QueryString["Todate"];

                    var dt = GetSPResult(Assetfromdate, AssetTodate);
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\AssetRegistrationHistoryRpt_Condition.rdlc";
                    var datasource = new ReportDataSource("Asis_BemsAssetRegistrationHistoryRpt_L2_Condition", dt);
                    var datasource1 = new ReportDataSource("Asis_DS_From_TO", dt);
                    var datasource2 = new ReportDataSource("Asis_Ds_GetAssetGrouping", dt);
                    var datasource3 = new ReportDataSource("Asis_DS_GetAssetStatus", dt);
                    var datasource4 = new ReportDataSource("Asis_Ds_GetAssetGrouping_Typeid", dt);
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);
                    reportViewer.LocalReport.DataSources.Add(datasource4);
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Assetfromdate, string AssetTodate)
        {
            UserDetailsModel _UserSession = new SessionHelper().UserSession();
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
                            cmd.CommandText = "uspFM_EngAsset_History_Rpt";
                            cmd.Parameters.AddWithValue("@Option", "");
                            cmd.Parameters.AddWithValue("@Group_By", "");
                            cmd.Parameters.AddWithValue("@From_Date", Assetfromdate);
                            cmd.Parameters.AddWithValue("@To_Date", AssetTodate);
                            cmd.Parameters.AddWithValue("@Asset_Status", "");
                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
                            }

                            cmd.CommandText = "uspFM_EngAsset_History_Rpt_From_TO";
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@From_Date", Assetfromdate);
                            cmd.Parameters.AddWithValue("@To_Date", AssetTodate);
                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
                            }

                            cmd.CommandText = "uspFM_EngAsset_History_Rpt_GetAssetGrouping";
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@Group_By", "");
                            cmd.Parameters.AddWithValue("@Age_Range", "");
                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
                            }

                            cmd.CommandText = "uspFM_EngAsset_History_Rpt_GetAssetStatus";
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@Asset_Status", "");
                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
                            }

                            cmd.CommandText = "uspFM_EngAsset_History_Rpt_Typeid";
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@Group_By", "");
                            cmd.Parameters.AddWithValue("@TypeId", "");
                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
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