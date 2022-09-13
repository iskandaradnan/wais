using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.MASTER;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.UserTraining;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.MASTER
{
    public class UserTrainingDAL : IUserTrainingDAL
    {
        private readonly string _FileName = nameof(UserTrainingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public UserTrainingDAL()
        {

        }

        public UserTrainingDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                UserTrainingDropdown usertrainingdropdownvalues = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "EngTrainingScheduleTxn");
                        cmd.Parameters.AddWithValue("@pLovKey", _UserSession.FacilityId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "TrainingTypeValue,TrainingQuarterValue,TrainingStatusValue,TrainerSourceValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }

                usertrainingdropdownvalues = new UserTrainingDropdown();
                if (ds.Tables.Count != 0)
                {
                    usertrainingdropdownvalues.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    usertrainingdropdownvalues.FacilityLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }


                if (ds1.Tables.Count != 0)
                {
                    usertrainingdropdownvalues.TrainingTypeLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TrainingTypeValue");
                    //usertrainingdropdownvalues.YearLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TrainingQuarterValue");
                    usertrainingdropdownvalues.QuarterLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TrainingQuarterValue");
                    usertrainingdropdownvalues.TrainingStsLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TrainingStatusValue");
                    usertrainingdropdownvalues.TrainingSourceLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TrainerSourceValue");
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return usertrainingdropdownvalues;
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
        public UserTrainingCompletion Save(UserTrainingCompletion usrtraing, out string ErrorMessage)
        {
            try
            {
                var reqid = usrtraing.TrainingScheduleId;
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                UserTrainingCompletion griddata = new UserTrainingCompletion();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pTrainingScheduleId", Convert.ToString(usrtraing.TrainingScheduleId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pTrainingScheduleNo", Convert.ToString(usrtraing.TrainingScheduleNo));
                parameters.Add("@pTrainingDescription", Convert.ToString(usrtraing.TrainingDescription));
                parameters.Add("@pTrainingType", Convert.ToString(usrtraing.TrainingTypeId));
                parameters.Add("@pNotificationDate", Convert.ToString(usrtraing.NotificationDate == null || usrtraing.NotificationDate == DateTime.MinValue ? null : usrtraing.NotificationDate.Value.ToString("MM-dd-yyy")));
                //parameters.Add("@pPlannedDate", Convert.ToString(usrtraing.PlannedDate));
                parameters.Add("@pPlannedDate", Convert.ToString(usrtraing.PlannedDate == null || usrtraing.PlannedDate == DateTime.MinValue ? null : usrtraing.PlannedDate.Value.ToString("MM-dd-yyy")));
                //parameters.Add("@pPlannedDateUTC", Convert.ToString(usrtraing.PlannedDate));
                parameters.Add("@pPlannedDateUTC", Convert.ToString(usrtraing.PlannedDate == null || usrtraing.PlannedDate == DateTime.MinValue ? null : usrtraing.PlannedDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pYear", Convert.ToString(usrtraing.Year));
                parameters.Add("@pQuarter", Convert.ToString(usrtraing.Quarter));
                parameters.Add("@pTrainingModule", Convert.ToString(usrtraing.Trainingmodule));
                parameters.Add("@pMinimumNoOfParticipants", Convert.ToString(usrtraing.MinNoOfParticipants));
                //parameters.Add("@pActualDate", Convert.ToString(usrtraing.ActualDate));
                parameters.Add("@pActualDate", Convert.ToString(usrtraing.ActualDate == null || usrtraing.ActualDate == DateTime.MinValue ? null : usrtraing.ActualDate.Value.ToString("MM-dd-yyy")));
                //parameters.Add("@pActualDateUTC", Convert.ToString(usrtraing.ActualDate));
                parameters.Add("@pActualDateUTC", Convert.ToString(usrtraing.ActualDate == null || usrtraing.ActualDate == DateTime.MinValue ? null : usrtraing.ActualDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pTrainingStatus", Convert.ToString(usrtraing.TrainingStatusId));
                parameters.Add("@pTrainerSource", Convert.ToString(usrtraing.TrainerSource));
                parameters.Add("@pTrainerUserId", Convert.ToString(usrtraing.TrainerPresenter));
                parameters.Add("@pTrainerUserName", Convert.ToString(usrtraing.TrainerPresenterName));
                parameters.Add("@pDesignation", Convert.ToString(usrtraing.Designation));
                parameters.Add("@pTrainerStaffExperience", Convert.ToString(usrtraing.Experience));
                parameters.Add("@pEmail", Convert.ToString(usrtraing.Email));
                parameters.Add("@pTotalParticipants", Convert.ToString(usrtraing.TotalParticipants));
                parameters.Add("@pVenue", Convert.ToString(usrtraing.venue));
                //parameters.Add("@pTrainingRescheduleDate", Convert.ToString(usrtraing.TrainingRescheduleDate));
                parameters.Add("@pTrainingRescheduleDate", Convert.ToString(usrtraing.TrainingRescheduleDate == null || usrtraing.TrainingRescheduleDate == DateTime.MinValue ? null : usrtraing.TrainingRescheduleDate.Value.ToString("MM-dd-yyy")));
                //parameters.Add("@pTrainingRescheduleDateUTC", Convert.ToString(usrtraing.TrainingRescheduleDate));
                parameters.Add("@pTrainingRescheduleDateUTC", Convert.ToString(usrtraing.TrainingRescheduleDate == null || usrtraing.TrainingRescheduleDate == DateTime.MinValue ? null : usrtraing.TrainingRescheduleDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pOverallEffectiveness", Convert.ToString(usrtraing.OverallEffectiveness));
                parameters.Add("@pRemarks", Convert.ToString(usrtraing.Remarks));

                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(usrtraing.Timestamp));
                parameters.Add("@pIsConfirmed", Convert.ToString(usrtraing.IsConfirmed));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                DataTable dt2 = new DataTable();
                if (usrtraing.UserTrainingGridData != null)
                {

                    dt.Columns.Add("TrainingScheduleDetId", typeof(int));
                    dt.Columns.Add("CustomerId", typeof(int));
                    dt.Columns.Add("FacilityId", typeof(int));
                    dt.Columns.Add("ServiceId", typeof(int));
                    dt.Columns.Add("ParticipantsUserId", typeof(int));
                    dt.Columns.Add("UserAreaId", typeof(int));
                    dt.Columns.Add("Remarks", typeof(string));

                    var deletedId = usrtraing.UserTrainingGridData.Where(y => y.IsDeleted).Select(x => x.TrainingScheduleDetId).ToList();
                    var idstring = string.Empty;
                    if (deletedId.Count() > 0)
                    {
                        foreach (var item in deletedId.Select((value, i) => new { i, value }))
                        {
                            idstring += item.value;
                            if (item.i != deletedId.Count() - 1)
                            { idstring += ","; }
                        }
                        deleteChildrecords(idstring);
                    }

                    foreach (var i in usrtraing.UserTrainingGridData.Where(y => !y.IsDeleted))
                    {
                        dt.Rows.Add(i.TrainingScheduleDetId, _UserSession.CustomerId, _UserSession.FacilityId, 2, i.ParticipantId, i.UserAreaId, null);
                    }
                    DataSetparameters.Add("@EngTrainingScheduleTxnDet", dt);
                }
                else
                {

                }

                if (usrtraing.UserTrainingAreaGridData != null)
                {

                    dt2.Columns.Add("TrainingScheduleAreaId", typeof(int));
                    dt2.Columns.Add("UserAreaId", typeof(int));
                    dt2.Columns.Add("Remarks", typeof(string));
                    dt2.Columns.Add("UserId", typeof(int));

                    // var deletedId = usrtraing.UserTrainingAreaGridData.Where(y => y.IsDeleted).Select(x => x.TrainingScheduleAreaId).ToList();
                    //  var idstring = string.Empty;
                    //if (deletedId.Count() > 0)
                    //{
                    //    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    //    {
                    //        idstring += item.value;
                    //        if (item.i != deletedId.Count() - 1)
                    //        { idstring += ","; }
                    //    }
                    //    deleteChildrecords(idstring);
                    //}

                    foreach (var i in usrtraing.UserTrainingAreaGridData)
                    {
                        dt2.Rows.Add(i.TrainingScheduleAreaId, i.UserAreaId, null, _UserSession.UserId);
                    }
                    DataSetparameters.Add("@EngTrainingScheduleUserAreaHistory", dt2);
                }
                else
                {

                }

                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngTrainingScheduleTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        usrtraing.TrainingScheduleId = Convert.ToInt32(row["TrainingScheduleId"]);
                        usrtraing.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        usrtraing.HiddenId = Convert.ToString(row["GuId"]);
                    }
                }

                usrtraing = Get(usrtraing.TrainingScheduleId, 5, 1);
                if(usrtraing.TrainerSource == 265)
                {
                    usrtraing.TrainerPresenter = 0;
                }
                if (reqid == 0 && usrtraing.TrainingTypeId == 254)
                {
                    SendMail(usrtraing);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return usrtraing;
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

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

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
                //return EODTypeCodeMappings;
                return filterResult;
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
        public UserTrainingCompletion Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                UserTrainingCompletion entity = new UserTrainingCompletion();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTrainingScheduleId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngTrainingScheduleTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null)
                    {
                        entity.TrainingScheduleId = Convert.ToInt16(ds.Tables[0].Rows[0]["TrainingScheduleId"]);
                        entity.Facility = Convert.ToString(ds.Tables[0].Rows[0]["FacilityCode"]);
                        entity.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        entity.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        entity.NotificationDate = ds.Tables[0].Rows[0].Field<DateTime?>("NotificationDate");
                        entity.TrainingTypeId = Convert.ToInt32(ds.Tables[0].Rows[0]["TrainingType"]);
                        entity.PlannedDate = ds.Tables[0].Rows[0].Field<DateTime?>("PlannedDate");
                        entity.Year = ds.Tables[0].Rows[0].Field<int?>("Year");
                        entity.Quarter = ds.Tables[0].Rows[0].Field<int?>("Quarter");
                        entity.TrainingScheduleNo = Convert.ToString(ds.Tables[0].Rows[0]["TrainingScheduleNo"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["TrainingScheduleNo"]);
                        entity.TrainingDescription = Convert.ToString(ds.Tables[0].Rows[0]["TrainingDescription"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["TrainingDescription"]);
                        entity.Trainingmodule = Convert.ToString(ds.Tables[0].Rows[0]["TrainingModule"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["TrainingModule"]);
                        entity.MinNoOfParticipants = ds.Tables[0].Rows[0].Field<int?>("MinimumNoOfParticipants");
                        entity.ActualDate = ds.Tables[0].Rows[0].Field<DateTime?>("ActualDate");
                        entity.TrainingStatusId = ds.Tables[0].Rows[0].Field<int?>("TrainingStatus");
                        entity.TrainerSource = ds.Tables[0].Rows[0].Field<int?>("TrainerSource");
                        entity.TrainerPresenter = ds.Tables[0].Rows[0].Field<int?>("TrainerUserId");
                        entity.TrainerPresenterName = Convert.ToString(ds.Tables[0].Rows[0]["TrainerUserName"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["TrainerUserName"]);
                        entity.Experience = ds.Tables[0].Rows[0].Field<int?>("TrainerStaffExperience");
                        entity.Designation = Convert.ToString(ds.Tables[0].Rows[0]["Designation"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["Designation"]);
                        entity.Email = Convert.ToString(ds.Tables[0].Rows[0]["Email"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["Email"]);
                        entity.TotalParticipants = ds.Tables[0].Rows[0].Field<int?>("TotalParticipants");
                        entity.venue = Convert.ToString(ds.Tables[0].Rows[0]["Venue"] == System.DBNull.Value ? "" : ds.Tables[0].Rows[0]["Venue"]);
                        entity.TrainingRescheduleDate = ds.Tables[0].Rows[0].Field<DateTime?>("TrainingRescheduleDate");
                        entity.OverallEffectiveness = ds.Tables[0].Rows[0].Field<decimal?>("OverallEffectiveness");
                        entity.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);

                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        entity.HiddenId = Convert.ToString((ds.Tables[0].Rows[0]["GuId"]));
                        entity.IsConfirmed = Convert.ToBoolean((ds.Tables[0].Rows[0]["IsConfirmed"]));
                        entity.IsRescheduled = Convert.ToBoolean((ds.Tables[0].Rows[0]["IsRescheduled"]));
                        entity.IsPlanedOver = ds.Tables[0].Rows[0].Field<bool>("IsPlannedDate");
                        entity.AllEmail = Convert.ToString(ds.Tables[0].Rows[0]["UserMailId"]);
                        entity.MultipleNotiIds = Convert.ToString(ds.Tables[0].Rows[0]["AllUserId"]);
                        

                    }

                    entity.UserTrainingGridData = (from n in ds.Tables[1].AsEnumerable()
                                                   select new UserTrainingGrid
                                                   {
                                                       //TrainingScheduleId = Convert.ToInt16(n["TrainingScheduleId"] ),
                                                       TrainingScheduleId = n.Field<int?>("TrainingScheduleId"),
                                                       TrainingScheduleDetId = n.Field<int?>("TrainingScheduleDetId"),
                                                       //TrainingScheduleDetId = Convert.ToInt16(n["TrainingScheduleDetId"]),
                                                       ParticipantId = n.Field<int?>("ParticipantsUserId"),

                                                       ParticipantName = Convert.ToString(n["ParticipantsUserValue"] == System.DBNull.Value ? "" : (n["ParticipantsUserValue"])),
                                                       Designation = Convert.ToString(n["ParticipantsUserDesignationValue"] == System.DBNull.Value ? "" : (n["ParticipantsUserDesignationValue"])),
                                                       UserAreaId = n.Field<int?>("UserAreaId"),
                                                       UserAreaCode = Convert.ToString(n["UserAreaIdCode"] == System.DBNull.Value ? "" : (n["UserAreaIdCode"])),
                                                       UserAreaName = Convert.ToString(n["UserAreaIdName"] == System.DBNull.Value ? "" : (n["UserAreaIdName"])),
                                                       IsConfirmed = Convert.ToBoolean(n["IsConfirmed"]),
                                                       //TotalRecords = n.Field<int?>("TotalRecords"),
                                                       //TotalPages = n.Field<int?>("TotalPageCalc"),
                                                       TotalRecords = Convert.ToInt16(n["TotalRecords"]),
                                                       TotalPages = Convert.ToInt16(n["TotalPageCalc"]),
                                                   }).ToList();

                    entity.UserTrainingAreaGridData = (from n in ds.Tables[2].AsEnumerable()
                                                       select new UserTrainingAreaGrid
                                                       {
                                                           TrainingScheduleAreaId = n.Field<int?>("TrainingScheduleAreaId"),
                                                           TrainingScheduleId = n.Field<int?>("TrainingScheduleId"),
                                                           UserAreaId = n.Field<int?>("UserAreaId"),
                                                           UserAreaCode = Convert.ToString(n["UserAreaCode"] == System.DBNull.Value ? "" : (n["UserAreaCode"])),
                                                           UserAreaName = Convert.ToString(n["UserAreaName"] == System.DBNull.Value ? "" : (n["UserAreaName"])),
                                                           CompRepId = n.Field<int?>("CustomerUserId"),
                                                           CompRepName = Convert.ToString(n["CustomerStaffName"] == System.DBNull.Value ? "" : (n["CustomerStaffName"])),
                                                           CompRepEmail = Convert.ToString(n["CustomerEmailId"] == System.DBNull.Value ? "" : (n["CustomerEmailId"])),
                                                           FacRepId = n.Field<int?>("FacilityUserId"),
                                                           FacRepName = Convert.ToString(n["FacilityStaffName"] == System.DBNull.Value ? "" : (n["FacilityStaffName"])),
                                                           FacRepEmail = Convert.ToString(n["FacilityEmailId"] == System.DBNull.Value ? "" : (n["FacilityEmailId"])),
                                                       }).ToList();

                    entity.UserTrainingGridData.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                    });
                    entity.TrainingScheduleId = Id;

                }
                return entity;
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

        public void Delete(int Id)
        {
            try
            {
                UserTrainingCompletion griddata = new UserTrainingCompletion();
                var ds = new DataTable();
                //ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Delete";
                        cmd.Parameters.AddWithValue("@pTrainingScheduleId", Id);

                        //con.Open();
                        //cmd.ExecuteNonQuery();
                        //con.Close();
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Rows.Count != 0)
                {
                    // ErrorMessage = Convert.ToString(ds.Rows[0]["ErrorMessage"]);
                }
                griddata = Get(Id, 5, 1);
                SendMailTrainCancel(griddata);

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

        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTrainingScheduleTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pTrainingScheduleDetId", id);

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

        public TrainingFeedback SaveFeedback(TrainingFeedback feedback, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveFeedback), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pTrainingFeedbackId", Convert.ToString(feedback.TrainingFeedbackId));
                parameters.Add("@pUserid", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pTrainingScheduleId", Convert.ToString(feedback.TrainingScheduleId));
                parameters.Add("@pCurriculum1", Convert.ToString(feedback.Curriculum1));
                parameters.Add("@pCurriculum2", Convert.ToString(feedback.Curriculum2));
                parameters.Add("@pCurriculum3", Convert.ToString(feedback.Curriculum3));
                parameters.Add("@pCurriculum4", Convert.ToString(feedback.Curriculum4));
                parameters.Add("@pCurriculum5", Convert.ToString(feedback.Curriculum5));
                parameters.Add("@pCourseIntructors1", Convert.ToString(feedback.CourseIntructors1));
                parameters.Add("@pCourseIntructors2", Convert.ToString(feedback.CourseIntructors2));
                parameters.Add("@pCourseIntructors3", Convert.ToString(feedback.CourseIntructors3));
                parameters.Add("@pTrainingDelivery1", Convert.ToString(feedback.TrainingDelivery1));
                parameters.Add("@pTrainingDelivery2", Convert.ToString(feedback.TrainingDelivery2));
                parameters.Add("@pTrainingDelivery3", Convert.ToString(feedback.TrainingDelivery3));
                parameters.Add("@pRecommendation", Convert.ToString(feedback.Recommendation));
                parameters.Add("@pTimestamp", Convert.ToString(feedback.Timestamp));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngTrainingScheduleFeedbackTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        feedback.TrainingFeedbackId = Convert.ToInt32(row["TrainingFeedbackId"]);
                        feedback.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return feedback;
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

        public TrainingFeedback GetFeedback(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetFeedback), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();
                TrainingFeedback entity = new TrainingFeedback();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", 1.ToString());
                parameters.Add("@pTrainingScheduleId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngTrainingScheduleFeedbackTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    entity.TrainingFeedbackId = Convert.ToInt16(dt.Rows[0]["TrainingFeedbackId"]);
                    entity.TrainingScheduleId = Convert.ToInt16(dt.Rows[0]["TrainingScheduleId"]);
                    entity.Curriculum1 = Convert.ToInt16(dt.Rows[0]["Curriculum1"]);
                    entity.Curriculum2 = Convert.ToInt16(dt.Rows[0]["Curriculum2"]);
                    entity.Curriculum3 = Convert.ToInt16(dt.Rows[0]["Curriculum3"]);
                    entity.Curriculum4 = Convert.ToInt16(dt.Rows[0]["Curriculum4"]);
                    entity.Curriculum5 = Convert.ToInt16(dt.Rows[0]["Curriculum5"]);
                    entity.CourseIntructors1 = Convert.ToInt16(dt.Rows[0]["CourseIntructors1"]);
                    entity.CourseIntructors2 = Convert.ToInt16(dt.Rows[0]["CourseIntructors2"]);
                    entity.CourseIntructors3 = Convert.ToInt16(dt.Rows[0]["CourseIntructors3"]);
                    entity.TrainingDelivery1 = Convert.ToInt16(dt.Rows[0]["TrainingDelivery1"]);
                    entity.TrainingDelivery2 = Convert.ToInt16(dt.Rows[0]["TrainingDelivery2"]);
                    entity.TrainingDelivery3 = Convert.ToInt16(dt.Rows[0]["TrainingDelivery3"]);
                    entity.Recommendation = Convert.ToString(dt.Rows[0]["Recommendation"]);
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;

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

        private void SendMail(UserTrainingCompletion model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                email = model.AllEmail;

                emailTemplateId = "25";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var planddt = model.PlannedDate.Value.ToString("dd-MMM-yyyy");

                templateVars = string.Join(",", planddt, model.TrainingScheduleNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                WebNotification(model);
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

        public UserTrainingCompletion WebNotification(UserTrainingCompletion ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WebNotification), Level.Info.ToString());
            UserTrainingCompletion griddata = new UserTrainingCompletion();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var planddt = ent.PlannedDate.Value.ToString("dd-MMM-yyyy");
            var notalert = ent.TrainingScheduleNo + " " + "Training Scheduled on" + planddt;
            var hyplink = "/bems/usertraining?id=" + ent.TrainingScheduleId;

            var allIds = ent.TrainerPresenter + "," + ent.MultipleNotiIds;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(0));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));
            parameters.Add("@pMultipleUserIds", Convert.ToString(allIds));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        private void SendMailTrainCancel(UserTrainingCompletion model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                email = model.AllEmail;

                emailTemplateId = "73";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                templateVars = string.Join(",", model.TrainingScheduleNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                WebNotificationTrainCancel(model);
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

        public UserTrainingCompletion WebNotificationTrainCancel(UserTrainingCompletion ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WebNotification), Level.Info.ToString());
            UserTrainingCompletion griddata = new UserTrainingCompletion();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.TrainingScheduleNo + " - " + "Training is cancelled";
            var hyplink = "/bems/usertraining?id=" + ent.TrainingScheduleId;

            var allIds = ent.MultipleNotiIds + "," + ent.TrainerPresenter;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(0));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));
            parameters.Add("@pMultipleUserIds", Convert.ToString(allIds));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
    }
}
