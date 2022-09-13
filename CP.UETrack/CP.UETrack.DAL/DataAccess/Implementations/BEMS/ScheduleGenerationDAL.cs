
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;
using PdfSharp;
using IronPdf;
using PdfSharp.Pdf.IO;
using System.IO;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.ICT;

namespace CP.UETrack.DAL.DataAccess.Implementations
{
    public class ScheduleGenerationDAL : IScheduleGenerationDAL
    {
        private readonly string _FileName = nameof(ScheduleGenerationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ScheduleGenerationDAL()
        {

        }
        public ScheduleGenerationLovs Load()
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ScheduleGenerationLovs lovcollection = null;


                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var ds3 = new DataSet();
                var ds4 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "EngPlannerTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "PlannerClassificationValue,WorkGroup");
                        da.SelectCommand = cmd;
                        da.Fill(ds1);

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "Service");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds2);


                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_group";
                        cmd.Parameters.Clear();
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds3);

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "MaintenanceYear");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds4);                      

                    }
                }

                if (ds.Tables.Count != 0)
                {
                    lovcollection = new ScheduleGenerationLovs();
                    lovcollection.WorkGroupList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    //lovcollection.YearList = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                }
                if (ds1.Tables.Count != 0)
                {
                    lovcollection.TypeOfPlannerList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PlannerClassificationValue");
                }
                if (ds3.Tables.Count != 0)
                {
                    lovcollection.WorkGroup = dbAccessDAL.GetLovRecords(ds3.Tables[0]);
                }
                if (ds2.Tables.Count != 0)
                {
                    lovcollection.ServiceList = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                }
                lovcollection.ServiceDB = _UserSession.UserDB;
                // Year Lov Data
                if (ds4.Tables.Count != 0)
                {
                   // lovcollection.YearList = dbAccessDAL.GetLovRecords(ds4.Tables[0]);
                    lovcollection.YearList = new List<SelectListLookup>();                    
                    

                    for (int i = 0; i < ds4.Tables[0].Rows.Count; i++)
                    {
                        lovcollection.YearList.Add(new SelectListLookup() { LovId = Convert.ToInt32( ds4.Tables[0].Rows[i]["LovId"]), FieldCode = ds4.Tables[0].Rows[i]["FieldValue"].ToString(), FieldValue = ds4.Tables[0].Rows[i]["FieldValue"].ToString() });
                    }
                    //var currentYear = DateTime.Now.Year - 1; var nextYear = currentYear + 1;
                    //lovcollection.YearList = new List<SelectListLookup>();
                    //// plannerLov.Years.Add(new SelectListLookup { LovId = 0, FieldCode = "Select", FieldValue = "Select" });
                    //lovcollection.YearList.Add(new SelectListLookup() { LovId = currentYear, FieldCode = currentYear.ToString(), FieldValue = currentYear.ToString() });
                    //lovcollection.YearList.Add(new SelectListLookup() { LovId = nextYear, FieldCode = nextYear.ToString(), FieldValue = nextYear.ToString() });
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return lovcollection;
            }
            //try
            //{
            //    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            //    PPMPlannerLovs Dropdownentityval = new PPMPlannerLovs();
            //    var dbAccessDAL = new DBAccessDAL();
            //    var obj = new PPMCheckListModel();
            //    var DataSetparameters = new Dictionary<string, DataTable>();
            //    var parameters = new Dictionary<string, string>();
            //    parameters.Add("@pLovKey", "ScheduleTypeValue");
            //    parameters.Add("@pLovKey", "TypeOfPlannerValue");
            //    parameters.Add("@pLovKey", "WarrantyTypeValue");
            //    DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
            //    if (ds != null)
            //    {
            //        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
            //        {
            //            Dropdownentityval.AssetClarificationList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
            //        }
            //    }
            //    ds.Clear();
            //    Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            //    return Dropdownentityval;
            //}
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }

        }
        public ScheduleGenerationModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduleGenerationModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPlannerId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngPlannerTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PpmScheduleId = Convert.ToInt16(ds.Tables[0].Rows[0]["PlannerId"]);
                        obj.ServiceId = Convert.ToInt16(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.Year = Convert.ToInt32(ds.Tables[0].Rows[0]["Year"]);
                        obj.WorkGroup = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkGroupId"]);
                        obj.TypeOfPlanner = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfPlanner"]);

                    }
                    //if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    //{

                    //    var TestAppMstDets = (from n in ds.Tables[1].AsEnumerable()
                    //                          select new PPMCheckListTestAppMstDetModel
                    //                          {
                    //                              PPMCheckListTAppId = Convert.ToInt32(n["PPMCheckListTAppId"]),
                    //                              PPMCheckListId = Convert.ToInt32(n["PPMCheckListId"]),
                    //                              Description = Convert.ToString(n["Description"]),
                    //                              Active = Convert.ToBoolean(n["Active"])
                    //                          }).ToList();

                    //    if (TestAppMstDets != null && TestAppMstDets.Count > 0)
                    //    {
                    //        obj.PPMCheckListTestAppMstDets = TestAppMstDets;

                    //    }
                    //}
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
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

        public List<workorde_week> getby_year(int Id,int WorkGroup,int weeks,int serviceId,int typeofplanner)
        {
        List<workorde_week> week = new List<workorde_week>();
            try
            {
                DataSet ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                string qustring = "";
                string typename = "";


                //if (serviceId != 2)
                //{
                //    if (typeofplanner == 0)
                //    {
                //        qustring = "select* from PPM_Document where FacilityId=" + _UserSession.FacilityId + " and Year=" + Id + " and WorkGroup=" + WorkGroup;
                //    }
                //    else
                //    {
                //        qustring = "select* from PPM_Document where FacilityId=" + _UserSession.FacilityId + " and Year=" + Id + " and WorkGroup=" + WorkGroup+ " and Type_Of_Planner=(select FieldValue from FMLovMst where LovId=" + typeofplanner + ")";
                //    }

                //}
                //else
                //{
                //    if (typeofplanner == 0)
                //    {
                //        qustring = "select* from PPM_Document where FacilityId=" + _UserSession.FacilityId + " and Year=" + Id;

                //    }
                //    else
                //    { 
                //    qustring = "select* from PPM_Document where FacilityId=" + _UserSession.FacilityId + " and Year=" + Id+ " and Type_Of_Planner=(select FieldValue from FMLovMst where LovId=" + typeofplanner + ")";
                //    }
                //}

                //  using (SqlConnection con = new SqlConnection("Data Source=10.249.5.52;Initial Catalog=uetrackfemsdbPreProd;User ID=uesa;Password=nWQy@xrtz+G*"))


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@CustomerId", _UserSession.CustomerId.ToString());
                parameters.Add("@Year", Id.ToString());
                parameters.Add("@typeofplanner", typeofplanner.ToString());
                parameters.Add("@ModuleId", serviceId.ToString());
                parameters.Add("@WorkGroup", WorkGroup.ToString());


                ds = dbAccessDAL.GetDataSet("GetBulkPrintData", parameters, DataSetparameters);


            
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            week = (from n in ds.Tables[0].AsEnumerable()
                                                select new workorde_week
                                                {   WeekLogId= Convert.ToInt32(n["WeekLogId"]),
                                                    type_of_planning = Convert.ToString(n["TypeOfPlanner"]),
                                                    Year = Convert.ToInt32(n["Year"]),
                                                    WeekNo = Convert.ToInt32(n["WeekNo"]),
                                                    WeekStartDate=Convert.ToDateTime(n["WeekStartDate"]),
                                                    WeekEndDate= Convert.ToDateTime(n["WeekEndDate"]),
                                                    CreatedDate= Convert.ToDateTime(n["GeneratedDate"]),
                                                    file_name = Convert.ToString(n["Print_File"]),
                                                    Uniq = Convert.ToInt32(n["Uniq"]),
                                                    FacilityId= Convert.ToInt32(n["FacilityId"]),
                                                    Status= Convert.ToString(n["Status"]),
                                                }).ToList();

                        }

                        
                
                        

                return week;
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
        public ScheduleGenerationModel Save(ScheduleGenerationModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pPlannerId", Convert.ToString(model.PpmScheduleId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@WorkGroupId", Convert.ToString(model.WorkGroup));
                parameters.Add("@TypeOfPlanner", Convert.ToString(model.TypeOfPlanner));
                parameters.Add("@Year", Convert.ToString(model.Year));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngPlannerTxn_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.PpmScheduleId = Convert.ToInt32(row["PlannerId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        public ScheduleGenerationModel Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type, string UserAreaId, string UserLocationId, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                if(_UserSession.UserDB==1)
                {
                    WorkGroup = 1;
                }
                else
                {
                }
                var dbAccessDAL = new DBAccessDAL();

                var obj = new ScheduleGenerationModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (UserAreaId == "null")
                {
                    UserAreaId = null;
                }

                if (UserLocationId == "null")
                {

                    UserLocationId = null;
                }

                if (TOP == "PPM")
                    TOP = "34";
                if (TOP == "RI")
                    TOP = "35";
                if (TOP == "PDM")
                    TOP = "36";
                if (TOP == "Calibration")
                    TOP = "198";
                if (TOP == "Radiology QC")
                    TOP = "343";

                parameters.Add("@pWorkGroupid", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pCustomerId", _UserSession.CustomerId.ToString());
                    parameters.Add("@pUserId", _UserSession.UserId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    parameters.Add("@pTypeOfPlanner", TOP.ToString());
                    parameters.Add("@pWeekStartDate", StartDate.ToString());
                    parameters.Add("@pWeekEndDate", EndDate.ToString());
                    parameters.Add("@pWeekNo", WeekNo.ToString());
                    parameters.Add("@pPageIndex", pageindex.ToString());
                    parameters.Add("@pPageSize", pagesize.ToString());
                    parameters.Add("@pUserAreaId", UserAreaId);
                    parameters.Add("@pUserLocationId", UserLocationId);
                if (Type == "Fetch")
                {
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngScheduleGeneration_Fetch", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            obj.skipweek = 0;
                            obj.ScheduleDets = (from n in ds.Tables[0].AsEnumerable()
                                                select new ScheduleGenerationDetModel
                                                {
                                                    AssetNo = Convert.ToString(n["AssetNo"]),
                                                    UserArea = Convert.ToString(n["UserAreaCode"]),
                                                    WorkOrder = null,
                                                    WorkGroupCode = Convert.ToString(n["WorkGroupCode"]),
                                                    WorkOrderDate = Convert.ToDateTime(n["WorkOrderDate"]),
                                                    TargetDate = Convert.ToDateTime(n["TargetDate"]),
                                                    TypeOfPlanner = Convert.ToString(n["TypeOfPlanner"]),
                                                    AssetType = Convert.ToString(n["AssetType"] == DBNull.Value ? "" : (Convert.ToString(n["AssetType"]))),
                                                    IsParentChildAvailable = Convert.ToBoolean(n["IsParentChildAvailable"]),
                                                    TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                    TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                                }).ToList();

                            obj.ScheduleDets.ForEach((x) =>
                            {
                                x.PageIndex = pageindex;
                                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                            });
                        }
                        else
                        {
                            obj.skipweek = 1;
                        }
                    }
                }
                if (Type == "Generate")
                {
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngScheduleGeneration_Generate", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            obj.ScheduleDets = (from n in ds.Tables[0].AsEnumerable()
                                                select new ScheduleGenerationDetModel
                                                {
                                                    AssetNo = Convert.ToString(n["AssetNo"]),
                                                    UserArea = Convert.ToString(n["UserAreaCode"]),
                                                    WorkOrder = Convert.ToString(n["WorkOrderNo"]),
                                                    WorkGroupCode = Convert.ToString(n["WorkGroupCode"]),
                                                    WorkOrderDate = Convert.ToDateTime(n["WorkOrderDate"]),
                                                    TargetDate = Convert.ToDateTime(n["TargetDate"]),
                                                    TypeOfPlanner = Convert.ToString(n["TypeOfPlanner"]),
                                                    AssetType = Convert.ToString(n["AssetType"] == DBNull.Value ? "" : (Convert.ToString(n["AssetType"]))),
                                                    IsParentChildAvailable= Convert.ToBoolean(n["IsParentChildAvailable"]),
                                                    TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                    TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                                }).ToList();

                            obj.ScheduleDets.ForEach((x) =>
                            {
                                x.PageIndex = pageindex;
                                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                            });
                        }
                    }
                }
                if (Type == "Skip")
                {
                    parameters.Add("@pModuleId", Service.ToString());

                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngScheduleGeneration_Skip", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            obj.ScheduleDets = (from n in ds.Tables[0].AsEnumerable()
                                                select new ScheduleGenerationDetModel
                                                {
                                                    Status = Convert.ToString(n["Status"]),

                                                }).ToList();
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
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

        public ScheduleGenerationModel GetWeekNo(int Service, int WorkGroup, int Year, int TOP)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();

                var obj = new ScheduleGenerationModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
               
                   // parameters.Add("@pServiceId", Service.ToString());
                    parameters.Add("@pWorkGroupId", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    parameters.Add("@pTypeOfPlanner", TOP.ToString());
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngScheduleGenerationWeekLog_GetAll", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            obj.WeekNo = Convert.ToString(ds.Tables[0].Rows[0]["WeekNoToBeGenerated"]);
                            obj.StartDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["WeekStartDate"]);
                            obj.EndDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["WeekEndDate"]);
                        obj.WeekLogId = Convert.ToString(ds.Tables[0].Rows[0]["WeekLogId"]);
                    }
                    //if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    //{
                    //    obj.WeekNo = Convert.ToString(ds.Tables[1].Rows[0]["WeekNoToBeGenerated"]);
                    //    obj.StartDate = Convert.ToDateTime(ds.Tables[1].Rows[0]["WeekStartDate"]);
                    //    obj.EndDate = Convert.ToDateTime(ds.Tables[1].Rows[0]["WeekEndDate"]);
                    //}
                }              
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
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
        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPlannerId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngPlannerTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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

        public bool IsRecordModified(ScheduleGenerationModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (model.PpmScheduleId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.PpmScheduleId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngPPMRegisterMst__GetTimestamp", parameters, DataSetparameters);

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
        public static byte[] MergePdf(List<byte[]> pdfs)
        {
            List<PdfSharp.Pdf.PdfDocument> lstDocuments = new List<PdfSharp.Pdf.PdfDocument>();
            foreach (var pdf in pdfs)
            {
                lstDocuments.Add(PdfSharp.Pdf.IO.PdfReader.Open(new MemoryStream(pdf), PdfDocumentOpenMode.Import));
            }

            using (PdfSharp.Pdf.PdfDocument outPdf = new PdfSharp.Pdf.PdfDocument())
            {
                for (int i = 1; i <= lstDocuments.Count; i++)
                {
                    foreach (PdfSharp.Pdf.PdfPage page in lstDocuments[i - 1].Pages)
                    {
                        outPdf.AddPage(page);
                    }
                }

                MemoryStream stream = new MemoryStream();
                outPdf.Save(stream, false);
                byte[] bytes = stream.ToArray();

                return bytes;
            }
        }




        public List<EngPpmPrintlist> PrintPDF(EngPpmScheduleGenTxnViewModel schedule)
        {
            try
            {
                DataSet ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var week = new List<EngPpmPrintlist>();
                

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@WeekLogId", schedule.WeekLogId.ToString());
                 ds = dbAccessDAL.GetDataSet("GetBulkPrintCheckList", parameters, DataSetparameters);

                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {

                    week = (from n in ds.Tables[0].AsEnumerable()
                            select new EngPpmPrintlist
                            {

                                WeekLogId = Convert.ToInt32(n["WeekLogId"]),
                                WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),

                                WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                checklistpath = Convert.ToString(n["Print_File"]),
                                DocumentId = Convert.ToInt32(n["FacilityId"]),
                                WebRootPath = schedule.WebRootPath,
                                ModuleId = schedule.ServiceId

                            }).ToList();
                   
                }
          
                return week;

            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
          
        }

        public List<EngScheduleGenerationFileJobViewModel> GetPrintList(EngPpmScheduleGenTxnViewModel schedule)
        {

            DataSet ds = new DataSet();
            var dbAccessDAL = new DBAccessDAL();

            var DataSetparameters = new Dictionary<string, DataTable>();
            var parameters = new Dictionary<string, string>();
            
            if (schedule.PrintActionType == "RePrint")
            {
                //DeletePrintList(schedule);
            }
            List<EngScheduleGenerationFileJobViewModel> list = new List<EngScheduleGenerationFileJobViewModel>();

            string guid = "";
            string spName = "EngScheduleGenerationFileJobSave";

            parameters.Add("@WeekLogId", schedule.WeekLogId.ToString());
            parameters.Add("@JobName", "EngScheduleGenerationFileJob");
            parameters.Add("@JobDescription", "EngScheduleGenerationFileJob");
           
            parameters.Add("@Year", schedule.Year.ToString());
            parameters.Add("@TypeOfPlanner", schedule.TypeOfPlanner.ToString());

            parameters.Add("@FacilityIds", _UserSession.FacilityId.ToString());
            parameters.Add("@CustomerIds", _UserSession.CustomerId.ToString());


            parameters.Add("@Gid", Guid.NewGuid().ToString());
            parameters.Add("@Status", "-");
            parameters.Add("@CreatedBy", _UserSession.UserId.ToString());
            parameters.Add("@Service", schedule.ServiceId.ToString());
            parameters.Add("@Flag", "3");
            parameters.Add("@FileInfo", "-");

            

            ds = dbAccessDAL.GetDataSet(spName, parameters, DataSetparameters);
         
            if (ds != null)
            {
                if (ds.Tables[0]!= null && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        list.Add(new EngScheduleGenerationFileJobViewModel
                        {
                            Jobid = Convert.ToInt32(row["Jobid"]),
                            Hospitalid = Convert.ToInt32(row["FacilityId"]),
                            Companyid = Convert.ToInt32(row["CustomerId"]),
                            Service = Convert.ToInt32(row["Service"]),
                            JobName = Convert.ToString(row["JobName"]),
                            JobDescription = Convert.ToString(row["JobDescription"]),
                            Gid = Convert.ToString(row["Gid"]),
                            Status = Convert.ToString(row["Status"]),
                            CreatedBy = Convert.ToInt32(row["CreatedBy"]),
                            CreateDate = Convert.ToDateTime(row["CreatedDate"]),
                            TypeOfPlanner = Convert.ToInt32(row["TypeOfPlanner"]),
                            Year = Convert.ToInt32(row["Year"]),
                            WeekLogId = Convert.ToInt32(row["WeekLogId"]),
                            WeekNo = Convert.ToInt32(row["WeekNo"]),
                            file_name= Convert.ToString(row["FileInfo"]),
                            //WorkGroupId = Convert.ToInt32(row["WorkGroupId"]),
                            //EngUserAreaId = Convert.ToInt32(row["EngUserAreaId"])

                        });

                       
                    }
                }

            }
          
            list.ForEach(x =>
            {
                x.YearPath = Convert.ToString(x.CreateDate.Value.Year);
                x.MonthPath = Convert.ToString(x.CreateDate.Value.Month);
                x.FileName = "WorkOrderChecklist" + "_" + DateTime.Now.ToString("dd_MMM_yyyy");


                if (x.Status != "Completed")
                {
                    var CreateDate = x.CreateDate.Value.AddMinutes(120);
                    x.RePrintStatus = (DateTime.Now > CreateDate) ? true : false;
                }
                else
                {
                    x.RePrintStatus = false;
                }
            });


            return list;
        }

        //public void DeletePrintList(EngPpmScheduleGenTxnViewModel schedule)
        //{


        //    DataSet ds = new DataSet();
        //    var dbAccessDAL = new DBAccessDAL();
        //    var week = new List<EngPpmPrintlist>();


        //    var DataSetparameters = new Dictionary<string, DataTable>();
        //    var parameters = new Dictionary<string, string>();
        //    parameters.Add("@WeekLogId", schedule.WeekLogId.ToString());
        //    parameters.Add("@ServiceId", _UserSession.ModuleId.ToString());

        //    ds = dbAccessDAL.GetDataSet("DeleteSheduleGenrationJobEntry", parameters, DataSetparameters);

          
          

        //}
    }
}
