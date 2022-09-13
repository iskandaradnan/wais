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
    public partial class UserTrainingReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Useryear = Request.QueryString["UserYear"];
                    var Userquarter = Request.QueryString["UserQuarter"];
                    var TrainingType = Request.QueryString["TrainingType"];
                    var MinNoofParticipants = Request.QueryString["MinNoofParticipants"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BemsUserTrainingRpt_L2.rdlc";
                    var datasource = new ReportDataSource("uspFM_BemsUserTrainingRpt_L2", GetSPResult("uspFM_BemsUserTrainingRpt_L2", Useryear, Userquarter, TrainingType, MinNoofParticipants));
                    var datasource1 = new ReportDataSource("uspFM_GetCustomer_Rpt", GetSPResult("uspFM_GetCustomer_Rpt", Useryear, Userquarter, TrainingType, MinNoofParticipants));
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private DataTable GetSPResult(string Spname, string Useryear, string Userquarter, string TrainingType, string MinNoofParticipants)
        {
            UserDetailsModel _UserSession = new SessionHelper().UserSession();
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    int? noOfPariticipants = null;
                    int? trainingTypeval = null;
                    if (string.IsNullOrEmpty(MinNoofParticipants) || MinNoofParticipants == "null")
                    {
                        noOfPariticipants = null;
                    }
                    else
                    {
                        noOfPariticipants = Convert.ToInt32(MinNoofParticipants);
                    }
                    if (string.IsNullOrEmpty(TrainingType) || TrainingType == "null")
                    {
                        trainingTypeval = null;
                    }
                    else
                    {
                        trainingTypeval = Convert.ToInt32(TrainingType);
                    }

                    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "uspFM_BemsUserTrainingRpt_L2":
                                    cmd.CommandText = "uspFM_BemsUserTrainingRpt_L2";
                                    cmd.Parameters.AddWithValue("@MenuName", "");
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@Year", Useryear);
                                    cmd.Parameters.AddWithValue("@Quarter", Userquarter);
                                    cmd.Parameters.AddWithValue("@TrainingType", trainingTypeval);
                                    cmd.Parameters.AddWithValue("@NoofParticipants", noOfPariticipants);

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