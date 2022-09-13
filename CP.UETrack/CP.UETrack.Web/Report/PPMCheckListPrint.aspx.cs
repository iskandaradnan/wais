using CP.Framework.Common.StateManagement;
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
    public partial class PPMCheckListPrint : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var CurrentDate = DateTime.Today.ToString("dd_MMM_yyyy");
                    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                    var CheckListId = Request.QueryString["PPMCheckListId"];
                    var PPMWOId = Request.QueryString["PPMWOId"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\PPM_CheckList_Print.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("uspFM_EngAssetPPMCheckList_Print", CheckListId, PPMWOId));
                    var datasource1 = new ReportDataSource("DataSet2", GetSPResult("uspFM_EngAssetPPMCheckListQuantasks_Print", CheckListId, PPMWOId));
                    var datasource2 = new ReportDataSource("DataSet3", GetSPResult("uspFM_EngAssetPPMCheckListCategory_Print", CheckListId, PPMWOId));
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.Refresh();
                    reportViewer.LocalReport.DisplayName = "PPM_CheckList_" + CurrentDate;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private DataTable GetSPResult(string Spname, string CheckListId,string PPMWOId)
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
                                case "uspFM_EngAssetPPMCheckList_Print":
                                    cmd.CommandText = "uspFM_EngAssetPPMCheckList_Print"; //
                                    cmd.Parameters.AddWithValue("@pPPMCheckListId", CheckListId);
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", PPMWOId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_EngAssetPPMCheckListQuantasks_Print":
                                    cmd.CommandText = "uspFM_EngAssetPPMCheckListQuantasks_Print"; //
                                    cmd.Parameters.AddWithValue("@pPPMCheckListId", CheckListId);
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", PPMWOId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_EngAssetPPMCheckListCategory_Print":
                                    cmd.CommandText = "uspFM_EngAssetPPMCheckListCategory_Print"; //
                                    cmd.Parameters.AddWithValue("@pPPMCheckListId", CheckListId);
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", PPMWOId);
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