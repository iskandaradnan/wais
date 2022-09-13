using CP.Framework.Common.Logging;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Timers;
using System.Threading;

namespace SheduleJobsDaily
{
    class Program
    {
        //private static Log4NetLogger _logger;
        static void Main(string[] args)
        {

            try
            {
                Thread printer = new Thread(new ThreadStart(InvokeMethod));
                printer.Start();
                //_logger.LogMessage("QueueEmail Entry", Level.Info);

                //int CommandTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["CommandTimeout"]);
                //var connectionStringM = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsM"].ConnectionString;
                //var connectionStringB = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsB"].ConnectionString;
                //var connectionStringF = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsF"].ConnectionString;
                //using (SqlConnection con = new SqlConnection(connectionStringM))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;

                //        con.Open();
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();


                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        con.Close();
                //    }
                //}
                //using (SqlConnection con = new SqlConnection(connectionStringB))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;

                //        con.Open();
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();


                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        con.Close();
                //    }
                //}
                //using (SqlConnection con = new SqlConnection(connectionStringF))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;

                //        con.Open();
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();


                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        cmd.Parameters.Clear();
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                //        cmd.CommandTimeout = CommandTimeout;
                //        cmd.ExecuteNonQuery();

                //        con.Close();
                //    }
                //}
                //_logger.LogMessage("QueueEmail Exit", Level.Info);
            }
            catch (Exception ex)
            {
                //if (_logger != null)
                //    _logger.LogException(ex, Level.Error);
            }
        }
        static void InvokeMethod()
        {
            while (true)
            {
                PrintTime();
                Thread.Sleep(1000 * 60 * 1); // 5 Minutes
                                             //Have a break condition
            }
        }
        static void PrintTime()
        {
            int CommandTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["CommandTimeout"]);
            var connectionStringM = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsM"].ConnectionString;
            var connectionStringB = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsB"].ConnectionString;
            var connectionStringF = System.Configuration.ConfigurationManager.ConnectionStrings["SheduleJobsF"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionStringM))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;

                    con.Open();
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();


                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
            using (SqlConnection con = new SqlConnection(connectionStringB))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;

                    con.Open();
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();


                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
            using (SqlConnection con = new SqlConnection(connectionStringF))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;

                    con.Open();
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();


                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_DailyScheduleJobLog_Save";
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    cmd.Parameters.Clear();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_BEMSCalibrationDueDateMail_EmailJob";//Facility&Workshop Calibration due date job.
                    cmd.CommandTimeout = CommandTimeout;
                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
            Console.WriteLine(DateTime.Now.ToString());
        }
    }
}
