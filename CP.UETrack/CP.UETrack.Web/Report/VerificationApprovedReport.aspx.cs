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
    public partial class VerificationApprovedReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Period = Request.QueryString["VAPeriod"];
                    var Year = Request.QueryString["VAYear"];
                    var Fromdate = Request.QueryString["VAFromDate"];
                    var Todate = Request.QueryString["VAToDate"];
                    var Status = Request.QueryString["VAStatus"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\AssetRegistrationHistoryRpt_Condition.rdlc";
                    var datasource = new ReportDataSource("Asis_VMApprovedListofEquipmentBEMS_L3", GetSPResult("uspFM_VMApprovedList_BEMS_L3", Period, Year, Fromdate, Todate, Status));
                    var datasource1 = new ReportDataSource("Asis_DS_From_TO", GetSPResult("uspFM_EngAsset_History_Rpt_From_TO", Period, Year, Fromdate, Todate, Status));                   
                    var datasource2 = new ReportDataSource("Asis_DS_Comp_State", GetSPResult("uspFM_EngAsset_History_Rpt_GetAssetStatus", Period, Year, Fromdate, Todate, Status));                   
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);                    
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string Period,string Year, string Fromdate, string Todate, string Status)
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
                            switch (Spname)
                            {
                                case "uspFM_VMApprovedList_BEMS_L3":
                                    cmd.CommandText = "uspFM_VMApprovedList_BEMS_L3";
                                    cmd.Parameters.AddWithValue("@pFacilityId", "");
                                    cmd.Parameters.AddWithValue("@Period", Period);
                                    cmd.Parameters.AddWithValue("@year", Year);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_EngAsset_History_Rpt_From_TO":
                                    cmd.CommandText = "uspFM_EngAsset_History_Rpt_From_TO";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@From_Date", Fromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", Todate);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;                                
                                case "uspFM_EngAsset_History_Rpt_GetAssetStatus":
                                    cmd.CommandText = "uspFM_EngAsset_History_Rpt_GetAssetStatus";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@Asset_Status", Status);
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