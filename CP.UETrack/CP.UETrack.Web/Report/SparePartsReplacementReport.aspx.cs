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
    public partial class SparePartsReplacementReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var CurrentDate = DateTime.Today.ToString("dd_MMM_yyyy");
                    var Spareparts = Request.QueryString["SPSpareparts"];
                    var Fromdate = Request.QueryString["SPFromDate"];
                    var Todate = Request.QueryString["SPToDate"];
                    if(Spareparts=="")
                    {
                        Spareparts = null;
                    }
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\Spare_Parts.rdlc";
                   // reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RDLCReports\Spare_Parts.rdlc";
                    var datasource = new ReportDataSource("SpareParts", GetSPResult("uspFM_SpareParts", Spareparts, Fromdate, Todate));
                    
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.Refresh();
                    reportViewer.LocalReport.DisplayName = "Spare_Parts_Replacement_" + CurrentDate;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private DataTable GetSPResult(string Spname, string Spareparts, string Fromdate,string Todate)
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
                                case "uspFM_SpareParts":
                                    cmd.CommandText = "uspFM_SpareParts";
                                    cmd.Parameters.AddWithValue("@SparePartId", Spareparts);
                                    cmd.Parameters.AddWithValue("@FromDate", Fromdate);
                                    cmd.Parameters.AddWithValue("@ToDate", Todate);                                    
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