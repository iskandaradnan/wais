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
    public partial class StockRegisterReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Itemid= Request.QueryString["StkRegItemId"];
                    var StkRegfromdate = Request.QueryString["StkRegFromDate"];
                    var StkRegtodate = Request.QueryString["StkRegToDate"];
                    var PartNo = Request.QueryString["PartNo"];
                    var SaprePartType = Request.QueryString["SaprePartType"];
                    var SPLocation = Request.QueryString["SPLocation"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\UETrack_BemsStockRegisterRpt_L2.rdlc";
                    var datasource = new ReportDataSource("uspFM_BemsStockRegisterRpt_L2", GetSPResult("uspFM_BemsStockRegisterRpt_L2", Itemid, StkRegfromdate, StkRegtodate, PartNo, SaprePartType, SPLocation));
                    reportViewer.LocalReport.DataSources.Clear();
                    reportViewer.LocalReport.DataSources.Add(datasource);                                                         
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname,string Itemid, string StkRegfromdate, string StkRegtodate, string PartNo, string SaprePartType, string SPLocation)
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    int? sparePartType, locationId = null;
                    if (string.IsNullOrEmpty(SaprePartType) || SaprePartType == "null")
                    {
                        sparePartType = null;
                    }
                    else
                    {
                        sparePartType = Convert.ToInt32(SaprePartType);
                    }
                    if (string.IsNullOrEmpty(SPLocation) || SPLocation == "null")
                    {
                        locationId = null;
                    }
                    else
                    {
                        locationId = Convert.ToInt32(SPLocation);
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
                                case "uspFM_BemsStockRegisterRpt_L2":
                                    cmd.CommandText = "uspFM_BemsStockRegisterRpt_L2";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@ItemId", Itemid);
                                    cmd.Parameters.AddWithValue("@From_Date", StkRegfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", StkRegtodate);
                                    cmd.Parameters.AddWithValue("@SparePartType", sparePartType);
                                    cmd.Parameters.AddWithValue("@Location", locationId);
                                    cmd.Parameters.AddWithValue("@PartNo", PartNo);
                                    
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