using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.VM;
using CP.Framework.Common.Logging;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.Models;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.VM
{
    public class VMDashboardDAL:IVMDashboardDAL
    {
        private readonly string _FileName = nameof(VMDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();     

        public VMDashboardModel GetDate(int Year, int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var VMDashboardObj = new VMDashboardModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pYear", Convert.ToString(Year));
                parameters.Add("@pMonth", Convert.ToString(Month));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_VM_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //VMDashboardObj.Year = Convert.ToInt32(dt.Rows[0]["Year"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_VM_DashBoard", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    VMDashboardObj.VMDashboardListData = (from n in dt1.Tables[0].AsEnumerable()
                                                            select new ItemVMDashboardList
                                                            {                                                               
                                                                StatusName = Convert.ToString(n["StatusName"]),
                                                                TotalCount = Convert.ToInt32(n["TotalCount"]),                                                                
                                                                
                                                            }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(GetDate), Level.Info.ToString());
                return VMDashboardObj;

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public VMDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var VMDashboardTypeDropdown = new VMDashboardTypeDropdown();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var currentYear = DateTime.Now.Year;
                var nextYear = currentYear + 1;
                var preYear = currentYear - 1;
                VMDashboardTypeDropdown.Years = new List<LovValue> { new LovValue { LovId = preYear, FieldValue = preYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() } };
                VMDashboardTypeDropdown.CurrentYear = currentYear;
                VMDashboardTypeDropdown.PreviousYear = preYear;

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "FinMonthlyFeeTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            VMDashboardTypeDropdown.MonthListTypedata = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pTablename", "Service");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            VMDashboardTypeDropdown.VMDashboardServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return VMDashboardTypeDropdown;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public VMDashboardModel Get(int Year)
        {
            throw new NotImplementedException();
        }

    }
}
