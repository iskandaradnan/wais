using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
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
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class AssetQRCodeReport : System.Web.UI.Page
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
                    //var facilityId = Request.QueryString["FacilityId"];
                    var dt = GetSPResult();
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    // rptViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\QRCodeAssetTemplate.rdlc";
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RDLCReports\QR_Code_Asset_Printing.rdlc";
                    var datasource = new ReportDataSource("DataSet1", dt);
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.Refresh();
                    reportViewer.LocalReport.DisplayName = "Asset_QR_Code_"+ CurrentDate;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        //private DataTable GetSPResult()
        //{
        //    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
        //    var ResultsTable = new DataTable();
        //    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
        //    {
        //        try
        //        {
        //            using (var cmd = new SqlCommand("uspFM_AssetQRCode_Report", conn))
        //            {
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.Parameters.AddWithValue("@pFacilityId", userDetails.FacilityId);
        //                using (var adapter = new SqlDataAdapter(cmd))
        //                {
        //                    adapter.Fill(ResultsTable);
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            throw ex;
        //        }
        //        finally
        //        {
        //            if (conn != null)
        //            {
        //                conn.Close();
        //            }
        //        }
        //        return ResultsTable;
        //    }
        //}

        private DataTable GetSPResult()
        {
            try
            {
                var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                var ResultsTable = new DataTable();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                string Connection = dbAccessDAL.ConnectionString;
                if (userDetails.UserDB == 1)
                {
                    var BEMSAccessDAL = new MASTERBEMSDBAccessDAL();
                    Connection = BEMSAccessDAL.ConnectionString;
                }
                else if (userDetails.UserDB == 2)
                {
                    var FEMSAccessDAL = new MASTERFEMSDBAccessDAL();
                    Connection = FEMSAccessDAL.ConnectionString;
                }
                using (SqlConnection con = new SqlConnection(Connection))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_AssetQRCode_Report";
                        cmd.Parameters.AddWithValue("@pFacilityId", userDetails.FacilityId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ResultsTable);
                    }
                }
                return ResultsTable;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }



    }
}