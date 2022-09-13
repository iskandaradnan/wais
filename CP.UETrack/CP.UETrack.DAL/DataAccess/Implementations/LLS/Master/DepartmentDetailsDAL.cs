using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.LLS;
using CP.UETrack.Model.BEMS;
using System.Globalization;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class DepartmentDetailsDAL : IDepartmentDetailsDAL
    {
        private readonly string _FileName = nameof(DepartmentDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int testuserareaid;
        public DepartmentDetailsDAL()
        {

        }

        public DepartmentDetailsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Lovs = new DepartmentDetailsModelLovs();
                string lovs = "YesNoValue,LinenScheduleValue,StatusValue,OperatingDaysValue,CleaningValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.FrequencyList = dbAccessDAL.GetLovRecords(ds.Tables[0], "LinenScheduleValue");
                    Lovs.PpmCategoryList = dbAccessDAL.GetLovRecords(ds.Tables[0], "YesNoValue");
                    Lovs.StatusList = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                    Lovs.OperatingDayList = dbAccessDAL.GetLovRecords(ds.Tables[0], "OperatingDaysValue");
                    Lovs.DayList = dbAccessDAL.GetLovRecords(ds.Tables[0], "CleaningValue");
                }

                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pTableName", "EngEODParameterMapping");
                //DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);

                var ds2 = new DataSet();
                var MdbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(MdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }

                if (ds2 != null && ds2.Tables[0] != null && ds2.Tables[0].Rows.Count > 0)
                {
                    Lovs.Services = dbAccessDAL.GetLovRecords(ds2.Tables[0]);

                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
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
        //public DepartmentDetailsModelLovs Load(int id)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    try
        //    {
        //        var model = new DepartmentDetailsModelLovs();
        //        var dal = new LevelDAL();
        //        var obj = dal.Get(id);

        //        model.LevelId = id;
        //        model.BlockId = obj.BlockId;
        //        model.FacilityId = obj.FacilityId;
        //        model.LevelName = obj.LevelName;
        //        model.LevelCode = obj.LevelCode;
        //        model.BlockCode = obj.BlockCode;
        //        model.BlockName = obj.BlockName;
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return model;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

        public DepartmentDetailsModel Save(DepartmentDetailsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt1 = new DataTable();
                DataTable dt3 = new DataTable();
                //DataTable dss = new DataTable();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var DataSetparameterss = new Dictionary<string, DataTable>();
                var rowparameters = new Dictionary<string, string>();
                List<UserAreaDetailsLocationList> useraAreaLocationList = new List<UserAreaDetailsLocationList>();
                List<LUserAreaDetailsLinenItemList> useraAreaLinenItemList = new List<LUserAreaDetailsLinenItemList>();
                parameters.Add("@UserAreaId", Convert.ToString(model.LLSUserAreaId));
                parameters.Add("@HospitalRep", Convert.ToString(model.HospitalRepresentative));
                parameters.Add("@EffectiveFromDate", Convert.ToString(model.EffectiveFromDate));
                parameters.Add("@EffectiveToDate", Convert.ToString(model.EffectiveToDate));
                parameters.Add("@OperatingDays", Convert.ToString(model.OperatingDays));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@WhiteBag", Convert.ToString(model.WhiteBag));
                parameters.Add("@RedBag", Convert.ToString(model.RedBag));
                parameters.Add("@GreenBag", Convert.ToString(model.GreenBag));
                parameters.Add("@BrownBag", Convert.ToString(model.BrownBag));
                parameters.Add("@AlginateBag", Convert.ToString(model.AlginateBag));
                parameters.Add("@SoiledLinenBagHolder", Convert.ToString(model.SoiledLinenBagHolder));
                parameters.Add("@RejectBagHolder", Convert.ToString(model.RejectLinenBagHolder));
                parameters.Add("@SoiledLinenRack", Convert.ToString(model.SoiledLinenRack));
                parameters.Add("@LAADStartTime", Convert.ToString(model.LAADStartTimess));
                parameters.Add("@CleaningSanitizing", Convert.ToString(model.CleaningSanitizing));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                // Delete grid
                var deletedId = model.UserAreaDetailsLocationGridList.Where(y => y.IsDeleted).Select(x => x.LLSUserAreaLocationId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, var) => new { var, value }))
                    {
                        idstring += item.value;
                        if (item.var != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }

                //TimeSpan FirstScheduleStarts = new TimeSpan();

                //FirstScheduleStarts = TimeSpan.Parse(FirstScheduleStarts.ToString());
                //try
                //{
                    

                //}
                //catch (Exception ex)
                //{
                //    throw ex;
                //}
                if (model.LLSUserAreaId != 0)
                {
                   
                        DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsMst_Update", parameters, DataSetparameters);
                    
                }

                else
                {
                    spName = "LLSUserAreaDetailsMst_Save";

                    DataTable dataTable = new DataTable("LLSUserAreaDetailsMst");
                    dataTable.Columns.Add("CustomerId", typeof(Int32));
                    dataTable.Columns.Add("FacilityId", typeof(Int32));
                    dataTable.Columns.Add("UserAreaId", typeof(Int32));
                    dataTable.Columns.Add("UserAreaCode", typeof(string));
                    dataTable.Columns.Add("HospitalRep", typeof(Int32));
                    dataTable.Columns.Add(new DataColumn("EffectiveFromDate", typeof(DateTime)));
                    dataTable.Columns.Add(new DataColumn("EffectiveToDate", typeof(DateTime)));
                    dataTable.Columns.Add("OperatingDays", typeof(string));
                    dataTable.Columns.Add("Status", typeof(Int32));
                    dataTable.Columns.Add("WhiteBag", typeof(Int32));
                    dataTable.Columns.Add("RedBag", typeof(Int32));
                    dataTable.Columns.Add("GreenBag", typeof(Int32));
                    dataTable.Columns.Add("BrownBag", typeof(Int32));
                    dataTable.Columns.Add("AlginateBag", typeof(Int32));
                    dataTable.Columns.Add("SoiledLinenBagHolder", typeof(Int32));
                    dataTable.Columns.Add("RejectBagHolder", typeof(Int32));
                    dataTable.Columns.Add("SoiledLinenRack", typeof(Int32));
                    dataTable.Columns.Add(new DataColumn("LAADStartTime", typeof(DateTime)));
                    dataTable.Columns.Add("CleaningSanitizing", typeof(Int32));
                    dataTable.Columns.Add("CreatedBy", typeof(int));
                    dataTable.Columns.Add("ModifiedBy", typeof(int));
                    dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.UserAreaID,
                    model.UserAreaCode,
                    model.HospitalRepresentative,
                    Convert.ToDateTime(model.EffectiveFromDate),
                    Convert.ToDateTime(model.EffectiveToDate),
                    model.OperatingDays,
                    model.Status,
                    model.WhiteBag,
                    model.RedBag,
                    model.GreenBag,
                    model.BrownBag,
                    model.AlginateBag,
                    model.SoiledLinenBagHolder,
                    model.RejectLinenBagHolder,
                    model.SoiledLinenRack,
                    model.LAADStartTimess,
                    //Convert.ToDateTime(model.LAADStartTime),
                    //Convert.ToDateTime(model.LAADEndTime),
                    model.CleaningSanitizing,
                    _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString()
                    );

                    var ds = new DataSet();

                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = spName;
                            SqlParameter parameter = new SqlParameter();
                            parameter.ParameterName = "@LLSUserAreaDetailsMst";
                            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }

                    if (ds.Tables.Count != 0)
                    {
                        var llsuserareaid = Convert.ToInt32(ds.Tables[0].Rows[0]["LLSUserAreaId"]);
                        if (llsuserareaid != 0)
                            model.LLSUserAreaId = llsuserareaid;
                        if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                        {
                            model.Timestamp = "";
                        }
                        else
                        {
                            model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        }
                        ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                    }
                }
                //-------------Adding ChildTable1-----------------
                #region Adding Child Table


                var parametersss = new Dictionary<string, string>();
                parametersss.Add("@UserAreaId", model.UserAreaID.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLocationMstDetArea_FetchLLSAreaCode", parametersss, DataSetparameterss);
                if (dt != null && dt.Rows.Count > 0)
                {

                    testuserareaid = Convert.ToInt32(dt.Rows[0]["LLSUserAreaId"]);
                }
                dt1.Columns.Add("LLSUserAreaId", typeof(int));
                dt1.Columns.Add("UserLocationId", typeof(int));
                dt1.Columns.Add("UserAreaCode", typeof(string));
                dt1.Columns.Add("UserLocationCode", typeof(string));
                dt1.Columns.Add("LinenSchedule", typeof(string));
                dt1.Columns.Add(new DataColumn("1stScheduleStartTime", typeof(DateTime)));
                //dt1.Columns.Add(new DataColumn("1stScheduleEndTime", typeof(DateTime)));
                dt1.Columns.Add(new DataColumn("2ndScheduleStartTime", typeof(DateTime)));
                //dt1.Columns.Add(new DataColumn("2ndScheduleEndTime", typeof(DateTime)));
                dt1.Columns.Add(new DataColumn("3rdScheduleStartTime", typeof(DateTime)));
                dt1.Columns.Add(new DataColumn("FacilityId", typeof(int)));
                dt1.Columns.Add(new DataColumn("CustomerId", typeof(int)));
                dt1.Columns.Add(new DataColumn("CreatedBy", typeof(int)));
                dt1.Columns.Add(new DataColumn("ModifiedBy", typeof(int)));

                if (model.LLSUserAreaId != 0)
                {
                    foreach (var row in model.UserAreaDetailsLocationGridList)
                    {
                        if (row.LLSUserAreaLocationId != 0)
                        {
                            rowparameters.Clear();
                            rowparameters.Add("@1stScheduleStartTime", Convert.ToString(row.FirstScheduleStartTime ?? TimeSpan.FromHours(2)));
                            if (row.SecondScheduleStartTime == null)
                            {

                            }
                            else
                            {
                                rowparameters.Add("@2ndScheduleStartTime", Convert.ToString(row.SecondScheduleStartTime ?? TimeSpan.FromHours(2)));
                            }
                            if (row.ThirdScheduleStartTime == null)
                            {

                            }
                            else
                            {
                                rowparameters.Add("@3rdScheduleStartTime", Convert.ToString(row.ThirdScheduleStartTime ?? TimeSpan.FromHours(2)));
                            }


                            rowparameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                            rowparameters.Add("@ModifiedDate", DateTime.Now.ToString());
                            rowparameters.Add("@ModifiedDateUTC", DateTime.UtcNow.ToString());
                            rowparameters.Add("@LLSUserAreaLocationId", Convert.ToString(row.LLSUserAreaLocationId));
                            DataTable dsss = new DataTable();
                            dsss = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLocationMstDet_Update", rowparameters, DataSetparameters);
                        }
                        else
                        {
                            List<UserAreaDetailsLocationList> lipp = new List<UserAreaDetailsLocationList>();
                            lipp = model.UserAreaDetailsLocationGridList;
                            if (row.LinenSchedule == "0" || row.LinenSchedule == null || row.LinenSchedule == "")
                            { }
                            else
                            {
                                foreach (var obj in lipp)
                                {
                                    var FirstScheduleStart = obj.FirstScheduleStartTime;
                                    TimeSpan Starttimespan = TimeSpan.Parse(FirstScheduleStart.ToString());
                                    string Starttime = Starttimespan.ToString();
                                    DateTime ScheduleStartTime = DateTime.ParseExact(Starttime, "HH:mm:ss", CultureInfo.InvariantCulture);

                                    var SecondScheduleStart = obj.SecondScheduleStartTime;
                                    // var ThirdScheduleStart = row.ThirdScheduleStartTime;
                                    DateTime SecondSecondScheduleStartTime = new DateTime();
                                    DateTime ThirdThirdScheduleStartTime = new DateTime();
                                    if (obj.SecondScheduleStartTime == null)
                                    {

                                    }
                                    else
                                    {
                                        TimeSpan Secondtimespan = TimeSpan.Parse(SecondScheduleStart.ToString());
                                        string Secondtime = Secondtimespan.ToString();
                                        SecondSecondScheduleStartTime = DateTime.ParseExact(Secondtime, "HH:mm:ss", CultureInfo.InvariantCulture);
                                    }
                                    if (obj.ThirdScheduleStartTime != null)
                                    {
                                        var ThirdScheduleStart = obj.ThirdScheduleStartTime;
                                        TimeSpan Thirdtimespan = TimeSpan.Parse(ThirdScheduleStart.ToString());
                                        string Thirdtime = Thirdtimespan.ToString();
                                        ThirdThirdScheduleStartTime = DateTime.ParseExact(Thirdtime, "HH:mm:ss", CultureInfo.InvariantCulture);
                                    }
                                    //foreach (var var in lipp)
                                    //{
                                    if (obj.LLSUserAreaLocationId == 0)
                                    {
                                        dt1.Rows.Add(
                                        testuserareaid,
                                        obj.UserLocationId,
                                        model.UserAreaCode,
                                        obj.UserLocationCode,
                                        obj.LinenSchedule,
                                        ScheduleStartTime,
                                        SecondSecondScheduleStartTime,
                                        ThirdThirdScheduleStartTime,
                                        _UserSession.FacilityId,
                                          _UserSession.CustomerId,
                                          _UserSession.UserId.ToString(),
                                     _UserSession.UserId.ToString()
                                        );
                                    }
                                }
                                DataSetparameters.Add("@LLSUserAreaDetailsLocationMstDet", dt1);
                                parameters.Clear();
                                DataTable dt2 = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLocationMstDet_Save", parameters, DataSetparameters);
                            }
                        }
                        rowparameters.Clear();
                        if (row.LLSUserAreaLocationId == 0)
                        {
                            return model;
                        }
                        else { }

                    }
                }
                else
                {
                    List<UserAreaDetailsLocationList> lip = new List<UserAreaDetailsLocationList>();
                    lip = model.UserAreaDetailsLocationGridList;
                    foreach (var row in lip.Where(y => !y.IsDeleted))
                    {
                        if (row.LinenSchedule == "0" || row.LinenSchedule == null || row.LinenSchedule == "")
                        { }
                        else
                        {

                            var FirstScheduleStart = row.FirstScheduleStartTime;
                            TimeSpan Starttimespan = TimeSpan.Parse(FirstScheduleStart.ToString());
                            string Starttime = Starttimespan.ToString();
                            DateTime ScheduleStartTime = DateTime.ParseExact(Starttime, "HH:mm:ss", CultureInfo.InvariantCulture);


                            var SecondScheduleStart = row.SecondScheduleStartTime;
                            // var ThirdScheduleStart = row.ThirdScheduleStartTime;
                            DateTime SecondSecondScheduleStartTime = new DateTime();
                            DateTime ThirdThirdScheduleStartTime = new DateTime();
                            if (row.SecondScheduleStartTime == null)
                            {

                            }
                            else
                            {
                                TimeSpan Secondtimespan = TimeSpan.Parse(SecondScheduleStart.ToString());
                                string Secondtime = Secondtimespan.ToString();
                                SecondSecondScheduleStartTime = DateTime.ParseExact(Secondtime, "HH:mm:ss", CultureInfo.InvariantCulture);
                            }
                            if (row.ThirdScheduleStartTime == null)
                            {
                                var ThirdScheduleStart = row.ThirdScheduleStartTime;
                                TimeSpan Thirdtimespan = TimeSpan.Parse(ThirdScheduleStart.ToString());
                                string Thirdtime = Thirdtimespan.ToString();
                                ThirdThirdScheduleStartTime = DateTime.ParseExact(Thirdtime, "HH:mm:ss", CultureInfo.InvariantCulture);
                            }

                            dt1.Rows.Add(
                            testuserareaid,
                            row.UserLocationId,
                            model.UserAreaCode,
                            row.UserLocationCode,
                            row.LinenSchedule,
                            ScheduleStartTime,
                            SecondSecondScheduleStartTime,
                            ThirdThirdScheduleStartTime,
                            _UserSession.CustomerId,
                            _UserSession.FacilityId,
                            _UserSession.UserId.ToString(),
                                     _UserSession.UserId.ToString()
                            );

                            DataSetparameters.Add("@LLSUserAreaDetailsLocationMstDet", dt1);
                            parameters.Clear();
                            DataTable dt2 = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLocationMstDet_Save", parameters, DataSetparameters);
                        }
                    }
                }
                #endregion

                // -----------------End Here-------------  
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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


        public DepartmentDetailsModel Get(int Id/*, int pagesize, int pageindex*/)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                DepartmentDetailsModel Department = new DepartmentDetailsModel();
                DepartmentDetailsModel Departments = new DepartmentDetailsModel();
                UserAreaDetailsLocationList UserAreaDetailsLocation = new UserAreaDetailsLocationList();
                LUserAreaDetailsLinenItemList LUserAreaDetailsLinenItem = new LUserAreaDetailsLinenItemList();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataSet ds = new DataSet();
                DataSet ds1 = new DataSet();
                var parameters = new Dictionary<string, string>();
                var locationparameters = new Dictionary<string, string>();
                var Linenparameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                //parameters.Add("@pPageIndex", Convert.ToString(pageindex));
                //parameters.Add("@pPageSize", Convert.ToString(pagesize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsMst_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    Department.LLSUserAreaId = Convert.ToInt32(dt.Rows[0]["LLSUserAreaId"]);
                    Department.UserAreaID = Convert.ToInt32(dt.Rows[0]["UserAreaId"]);
                    Department.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
                    Department.FacilityID = Convert.ToInt32(dt.Rows[0]["FacilityID"]);
                    Department.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
                    Department.HospitalRepresentative = Convert.ToString(dt.Rows[0]["HospitalRep"]);
                    Department.hdnHospitalRepresentativeId = Convert.ToInt32(dt.Rows[0]["HospitalRepID"]);
                    Department.HospitalRepresentativeDesignation = Convert.ToString(dt.Rows[0]["HospitalDesignation"]);
                    Department.EffectiveFromDate = Convert.ToDateTime(dt.Rows[0]["EffectiveFromDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveFromDate"])) : (DateTime?)null);
                    //Department.EffectiveToDate = Convert.ToDateTime(dt.Rows[0]["EffectiveToDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveToDate"])) : (DateTime?)null);

                    Department.Status = Convert.ToInt32(dt.Rows[0]["Status"]);
                    Department.WhiteBag = Convert.ToInt32(dt.Rows[0]["WhiteBag"]);
                    Department.RedBag = Convert.ToInt32(dt.Rows[0]["RedBag"]);
                    Department.GreenBag = Convert.ToInt32(dt.Rows[0]["GreenBag"]);
                    Department.BrownBag = Convert.ToInt32(dt.Rows[0]["BrownBag"]);
                    Department.OperatingDays = Convert.ToString(dt.Rows[0]["OperatingDays"]);
                    Department.AlginateBag = Convert.ToInt32(dt.Rows[0]["AlginateBag"]);
                    Department.SoiledLinenBagHolder = Convert.ToInt32(dt.Rows[0]["SoiledLinenBagHolder"]);
                    Department.RejectLinenBagHolder = Convert.ToInt32(dt.Rows[0]["RejectBagHolder"]);
                    Department.SoiledLinenRack = Convert.ToInt32(dt.Rows[0]["SoiledLinenRack"]);
                    Department.LAADStartTime = TimeSpan.Parse(handlenull(dt.Rows[0]["LAADStartTime"].ToString()));
                    Department.LAADEndTime = TimeSpan.Parse(handlenull(dt.Rows[0]["LAADEndTime"].ToString()));
                    Department.CleaningSanitizing = Convert.ToString(dt.Rows[0]["CleaningSanitizing"]);
                }

                locationparameters.Add("Id", Department.LLSUserAreaId.ToString());
                DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSUserAreaDetailsLocationMstDet_GetById", locationparameters, DataSetparameters);
                List<UserAreaDetailsLocationList> listinggrid = new List<UserAreaDetailsLocationList>();
                List<UserAreaDetailsLocationList> resultsfinal = new List<UserAreaDetailsLocationList>();
                //UserAreaDetailsLocation.FirstScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["1stScheduleStartTime"].ToString()));
                //UserAreaDetailsLocation.FirstScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["1stScheduleEndTime"].ToString()));
                //UserAreaDetailsLocation.SecondScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["2ndScheduleStartTime"].ToString()));
                //UserAreaDetailsLocation.SecondScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["2ndScheduleEndTime"].ToString()));
                //UserAreaDetailsLocation.ThirdScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["3rdScheduleStartTime"].ToString()));
                //UserAreaDetailsLocation.ThirdScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["3rdScheduleEndTime"].ToString()));
               
                foreach (DataRow Rows in dt1.Tables[0].Rows)
                {
                    UserAreaDetailsLocationList lovigrids = new UserAreaDetailsLocationList();
                    lovigrids.LLSUserAreaLocationId = Convert.ToInt32(Rows["LLSUserAreaLocationId"]);
                    lovigrids.UserLocationId = Convert.ToInt32(Rows["UserLocationId"]);
                    lovigrids.LLSUserAreaId = Convert.ToInt32(Rows["LLSUserAreaId"]);
                    lovigrids.UserLocationCode = Convert.ToString(Rows["UserLocationCode"]);
                    lovigrids.UserLocationName = Convert.ToString(Rows["UserLocationName"]);
                    lovigrids.LinenSchedule = Convert.ToString(Rows["LinenSchedule"]);
                    lovigrids.FirstScheduleStartTime = TimeSpan.Parse(handlenull(Rows["1stScheduleStartTime"].ToString()));  //UserAreaDetailsLocation.FirstScheduleStartTime,
                    lovigrids.FirstScheduleEndTime = TimeSpan.Parse(handlenull(Rows["1stScheduleEndTime"].ToString()));
                    lovigrids.SecondScheduleStartTime = TimeSpan.Parse(handlenull(Rows["2ndScheduleStartTime"].ToString()));
                    lovigrids.SecondScheduleEndTime = TimeSpan.Parse(handlenull(Rows["2ndScheduleEndTime"].ToString()));
                    lovigrids.ThirdScheduleStartTime = TimeSpan.Parse(handlenull(Rows["3rdScheduleStartTime"].ToString()));
                    lovigrids.ThirdScheduleEndTime = TimeSpan.Parse(handlenull(Rows["3rdScheduleEndTime"].ToString()));
                    listinggrid.Add(lovigrids);
                    resultsfinal = resultsfinal.Concat(listinggrid).ToList();
                    listinggrid.Clear();

                }
                Department.UserAreaDetailsLocationGridList = resultsfinal;


                //if (dt != null && dt1.Tables.Count > 0)
                //{
                //    Department.UserAreaDetailsLocationGridList = (from n in dt1.Tables[0].AsEnumerable()
                //                                                  select new UserAreaDetailsLocationList
                //                                                  {
                //                                                      LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                //                                                      UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                //                                                      LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                //                                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                //                                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                //                                                      LinenSchedule = Convert.ToString(n["LinenSchedule"]),
                //                                                      FirstScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["1stScheduleStartTime"].ToString())),  //UserAreaDetailsLocation.FirstScheduleStartTime,
                //                                                      FirstScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["1stScheduleEndTime"].ToString())),
                //                                                      SecondScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["2ndScheduleStartTime"].ToString())),
                //                                                      SecondScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["2ndScheduleEndTime"].ToString())),
                //                                                      ThirdScheduleStartTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["3rdScheduleStartTime"].ToString())),
                //                                                      ThirdScheduleEndTime = TimeSpan.Parse(handlenull(dt1.Tables[0].Rows[0]["3rdScheduleEndTime"].ToString())),
                //                                                  }).ToList();

                //}

                Linenparameters.Add("Id", Department.LLSUserAreaId.ToString());
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSUserAreaDetailsLinenItemMstDet_GetById", Linenparameters, DataSetparameters);
                if (dt1 != null && dt2.Tables.Count > 0)
                {
                    Department.LUserAreaDetailsLinenItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                                    select new LUserAreaDetailsLinenItemList
                                                                    {
                                                                        LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                                                        UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                                                        LLSUserAreaLinenItemId = Convert.ToInt32(n["LLSUserAreaLinenItemId"]),
                                                                        UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                                                        LinenCode = Convert.ToString(n["LinenCode"]),
                                                                        LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                        Par1 = Convert.ToDecimal(n["Par1"]),
                                                                        Par2 = Convert.ToDecimal(n["Par2"]),
                                                                        AgreedShelfLevel = Convert.ToDecimal(n["AgreedShelfLevel"]),
                                                                        DefaultIssue = Convert.ToInt32(n["DefaultIssue"]),


                                                                    }).ToList();
                    //Department.LUserAreaDetailsLinenItemGridList.ForEach((x) => {
                    //    // entity.TotalCost = x.TotalCost;
                    //    //x.PageIndex = pageindex;
                    //    //x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    //x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                    //});
                }


                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return Department;
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

        string handlenull(string inp)
        {
            if (inp.Length < 1)
            {
                inp = "00:00:00";
            }
            else
            { }
            return inp;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
                if (string.IsNullOrEmpty(QueryCondition))
                {

                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSUserAreaDetailsMst_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                //return Blocks;
                return filterResult;
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

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsMst_Delete", parameters, DataSetparameters);
                //DataTable dt1 = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
            }

            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public bool IsUserAreaDuplicate(DepartmentDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUserAreaDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //if(model.UserAreaID !=0 )
                //{
                //    //model.UserAreaID = 0;
                //}
                parameters.Add("@Id", model.LLSUserAreaId.ToString());
                parameters.Add("@UserAreaCode", model.UserAreaCode.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsUserAreaDuplicate), Level.Info.ToString());
                return IsDuplicate;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }



        public bool IsRecordModified(DepartmentDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new BEMSDBAccessDAL();
                var recordModifed = false;
                if (model.LLSUserAreaId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.LLSUserAreaId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationUserArea_GetTimestamp", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        if (timestamp != model.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public bool AreAllLocationsInactive(int LLSUserAreaId)
        {
            try
            {
                var isExisting = true;
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                if (LLSUserAreaId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@pUserAreaId", Convert.ToString(LLSUserAreaId));
                    DataTable dt = dbAccessDAL.GetMasterDataTable("UspFM_MstLocationUserArea_ActiveCheck", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        isExisting = Convert.ToBoolean((dt.Rows[0]["isExisting"]));

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return isExisting;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }


        }
        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSUserAreaDetailsLocationMstDetSingle_Delete";
                        cmd.Parameters.AddWithValue("@ID", id);
                        cmd.Parameters.AddWithValue("@ModifiedBy", _UserSession.UserId.ToString());
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void deleteChild2records(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSUserAreaDetailsLinenItemMstDetSingle_Delete";
                       
                        cmd.Parameters.AddWithValue("@ID", id);
                        cmd.Parameters.AddWithValue("@ModifiedBy", _UserSession.UserId.ToString());
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public DepartmentDetailsModel LinenItemSave(DepartmentDetailsModel model, out string ErrorMessage)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt1 = new DataTable();
                DataTable dt3 = new DataTable();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var DataSetparameterss = new Dictionary<string, DataTable>();
                var rowparameters = new Dictionary<string, string>();
                List<UserAreaDetailsLocationList> useraAreaLocationList = new List<UserAreaDetailsLocationList>();
                List<LUserAreaDetailsLinenItemList> useraAreaLinenItemList = new List<LUserAreaDetailsLinenItemList>();
                // Delete grid2
                var deletedId1 = model.LUserAreaDetailsLinenItemGridList.Where(z => z.IsDelete).Select(x => x.LLSUserAreaLinenItemId).ToList();
                var idstring1 = string.Empty;
                if (deletedId1.Count() > 0)
                {
                    foreach (var item in deletedId1.Select((value, var) => new { var, value }))
                    {
                        idstring1 += item.value;
                        if (item.var != deletedId1.Count() - 1)
                        { idstring1 += ","; }
                    }
                    deleteChild2records(idstring1);
                }

                #region Adding Child Table2

                var TableDataSetparameters = new Dictionary<string, DataTable>();
                dt3.Columns.Add("LLSUserAreaId", typeof(int));
                dt3.Columns.Add("UserLocationId", typeof(int));
                dt3.Columns.Add("LinenItemId", typeof(int));
                dt3.Columns.Add("Par1", typeof(Decimal));
                dt3.Columns.Add("Par2", typeof(Decimal));
                dt3.Columns.Add("DefaultIssue", typeof(int));
                dt3.Columns.Add("AgreedShelfLevel", typeof(Decimal));
                dt3.Columns.Add("CreatedBy", typeof(int));
                dt3.Columns.Add("ModifiedBy", typeof(int));
                if (model.LLSUserAreaId != 0)
                {
                    foreach (var row in model.LUserAreaDetailsLinenItemGridList)
                    {
                        rowparameters.Clear();
                        rowparameters.Add("@Par1", Convert.ToString(row.Par1));
                        rowparameters.Add("@Par2", Convert.ToString(row.Par2));
                        rowparameters.Add("@DefaultIssue", Convert.ToString(row.DefaultIssue));
                        rowparameters.Add("@AgreedShelfLevel", Convert.ToString(row.AgreedShelfLevel));
                        rowparameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                        rowparameters.Add("@LLSUserAreaLinenItemId", Convert.ToString(row.LLSUserAreaLinenItemId));
                        DataTable dsss = new DataTable();
                        if (row.LLSUserAreaLinenItemId != 0)
                        {
                            DataSetparameters.Clear();
                            dsss = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_Update", rowparameters, DataSetparameters);
                            rowparameters.Clear();
                        }
                        else
                        {

                            List<LUserAreaDetailsLinenItemList> ItemList = new List<LUserAreaDetailsLinenItemList>();
                            ItemList = model.LUserAreaDetailsLinenItemGridList;

                            LUserAreaDetailsLinenItemList Details = new LUserAreaDetailsLinenItemList();
                            dt3.Rows.Add(
                            row.LLSUserAreaId,
                            row.LLSUserAreaLocationId,
                            row.LinenItemId,
                            row.Par1,
                            row.Par2,
                            row.DefaultIssue,
                            row.AgreedShelfLevel,
                            _UserSession.UserId.ToString(),
                           _UserSession.UserId.ToString()
                            );

                            TableDataSetparameters.Add("@LLSUserAreaDetailsLinenItemMstDet", dt3);
                            parameters.Clear();
                            DataTable dt2 = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_Save", parameters, TableDataSetparameters);
                            TableDataSetparameters.Clear();
                            parameters.Clear();
                        }
                    }
                }
                else
                {
                    List<LUserAreaDetailsLinenItemList> ItemList = new List<LUserAreaDetailsLinenItemList>();
                    ItemList = model.LUserAreaDetailsLinenItemGridList;
                    foreach (var row in ItemList.Where(y => !y.IsDelete && y.LinenItemId != 0))
                    {
                        LUserAreaDetailsLinenItemList Details = new LUserAreaDetailsLinenItemList();
                        dt3.Rows.Add(
                        row.LLSUserAreaId,
                        row.LLSUserAreaLocationId,
                        row.LinenItemId,
                        row.Par1,
                        row.Par2,
                        row.DefaultIssue,
                        row.AgreedShelfLevel
                        );
                    }
                    TableDataSetparameters.Add("@LLSUserAreaDetailsLinenItemMstDet", dt3);
                    DataTable dt2 = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_Save", parameters, TableDataSetparameters);
                }
                #endregion

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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
    }
}
