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
    public partial class Ber1PrintReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)

        {
            try
            {
                if (!IsPostBack)
                {
                    var AppId = Request.QueryString["BERPrintAppId"];
                    

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BERCertificates.rdlc";
                    var datasource = new ReportDataSource("uspFM_BERApplicationTxn_BERCertificate_Rpt", GetSPResult("uspFM_BERApplicationTxn_BERCertificate_Rpt", AppId));                 
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult (string Spname, string AppId)
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
                                case "uspFM_BERApplicationTxn_BERCertificate_Rpt":
                                    cmd.CommandText = "uspFM_BERApplicationTxn_BERCertificate_Rpt";
                                    cmd.Parameters.AddWithValue("@app_id", AppId);
                                   
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