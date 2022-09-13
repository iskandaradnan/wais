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
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model.UM;

namespace CP.UETrack.DAL.DataAccess.Implementations.UM
{
   public class TrackingTechnicianDAL: ITrackingTechnicianDAL
    {
        private readonly string _FileName = nameof(TrackingTechnicianDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public List<UMTrackingTechnician> GetAll(string starDate, string endDate, string customerid, string facilityid, int staffid)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                List<UMTrackingTechnician> trackingtechnician = new List<UMTrackingTechnician>();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                       
                        cmd.CommandText = "UspFM_FEGPSPositionLastHistory_Mobile_GetById";
                        cmd.Parameters.AddWithValue("@pStartDate", starDate);
                        cmd.Parameters.AddWithValue("@pEndDate", endDate);
                        if(customerid=="" || customerid == null)
                            cmd.Parameters.AddWithValue("@pCustomerid", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@pCustomerid", customerid);
                        if(facilityid=="" || facilityid==null)
                        cmd.Parameters.AddWithValue("@pFacilityid", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@pFacilityid", facilityid);

                        //if (staffname=="" || staffname== null)
                        //cmd.Parameters.AddWithValue("@pStaffname", DBNull.Value);
                        //else
                        //    cmd.Parameters.AddWithValue("@pStaffname", staffname);
                        //if(username=="" || username==null)
                        //cmd.Parameters.AddWithValue("@pUsername", DBNull.Value);
                        //else
                        //    cmd.Parameters.AddWithValue("@pUsername", username);

                        if (staffid == 0 )
                            cmd.Parameters.AddWithValue("@pStaffId", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@pStaffId", staffid);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    trackingtechnician = (from n in ds.Tables[0].AsEnumerable()
                                select new UMTrackingTechnician
                                {
                                    UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                    StaffName = Convert.ToString(n["StaffName"]),
                                    DateTime = Convert.ToDateTime(n["DateTime"]),
                                    Latitude = Convert.ToDecimal(n["Latitude"]),
                                    Longitude = Convert.ToDecimal(n["Longitude"]),
                                    ROWNUMBER = Convert.ToInt32(n["ROWNUMBER"])
                                }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
               
                return trackingtechnician;
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
        public List<UMTrackingFacility> GetFacility()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                List<UMTrackingFacility> trackingtechnician = new List<UMTrackingFacility>();


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstLocationFacility_Mobile_GetById";
                        cmd.Parameters.AddWithValue("@pcustomerId", _UserSession.CustomerId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    trackingtechnician = (from n in ds.Tables[0].AsEnumerable()
                                          select new UMTrackingFacility
                                          {
                                              FacilityId= Convert.ToInt32(n["FacilityId"]),
                                              FacilityName = Convert.ToString(n["FacilityName"]),                                             
                                              Latitude = Convert.ToDecimal(n["Latitude"]),
                                              Longitude = Convert.ToDecimal(n["Longitude"]),
                                             
                                          }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());

                return trackingtechnician;
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

        public List<UMTrackingTechnicianView> GetEngineerByid(int Engineerid, string starDate, string endDate)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                List<UMTrackingTechnicianView> trackingtechnician = new List<UMTrackingTechnicianView>();


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.CommandText = "UspFM_FEGPSPositionHistoryGet_Mobile_GetById";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", Engineerid);
                        cmd.Parameters.AddWithValue("@pStartDate", starDate);
                        cmd.Parameters.AddWithValue("@pEndDate", endDate);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    trackingtechnician = (from n in ds.Tables[0].AsEnumerable()
                                          select new UMTrackingTechnicianView
                                          {
                                             // UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                             // StaffName = Convert.ToString(n["StaffName"]),
                                              //DateTime = Convert.ToDateTime(n["DateTime"]),
                                              lat = Convert.ToDecimal(n["Latitude"]),
                                              lng = Convert.ToDecimal(n["Longitude"]),
                                              DateTime = Convert.ToDateTime(n["DateTime"])

                                          }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());

                return trackingtechnician;
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
    }
}
