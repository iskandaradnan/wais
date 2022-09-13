using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using CP.UETrack.Model.CLS;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
   public class ChemicalInuseDAL: IChemicalInUseDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
                
        public ChemicalInUse Save(ChemicalInUse model, out string ErrorMessage)
        {
            try
            {
                
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                
                var ds = new DataSet();                
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_ChemicalInUseFields";
                        
                        cmd.Parameters.AddWithValue("@ChemicalId", model.ChemicalId);
                        cmd.Parameters.AddWithValue("@Customerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@DocumentNo", model.DocumentNo);
                        cmd.Parameters.AddWithValue("@Date", model.Date);
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks == null ? "" : model.Remarks);
                            
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);


                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();

                            model.ChemicalId = Convert.ToInt32(ds.Tables[0].Rows[0]["ChemicalId"]);
                            var ds1 = new DataSet();
                            cmd.CommandText = "SP_CLS_ChemicalInUseChemicals";

                            foreach (var use in model.ChemicalsList)
                            {
                                cmd.Parameters.AddWithValue("@CategoryId", use.CategoryId);
                                cmd.Parameters.AddWithValue("@ChemicalInUseId", model.ChemicalId);
                                cmd.Parameters.AddWithValue("@Category", use.Category);
                                cmd.Parameters.AddWithValue("@AreaOfApplication", use.AreaofApplication);
                                cmd.Parameters.AddWithValue("@ChemicalId", use.ChemicalId);
                                cmd.Parameters.AddWithValue("@KMMNo", use.KMMNO);
                                cmd.Parameters.AddWithValue("@Properties", use.Properties);
                                cmd.Parameters.AddWithValue("@Status", use.Status);
                                cmd.Parameters.AddWithValue("@EffectiveDate", use.EffectiveDate);
                                cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);


                                da.SelectCommand = cmd;
                                da.Fill(ds1);
                                cmd.Parameters.Clear();

                            }
                        }

                        model = Get(model.ChemicalId);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        public List<ChemicalInUseAttachments> AttachmentSave(ChemicalInUse model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();                
               
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_ChemicalInUseAttachment";

                        foreach (var use in model.lstChemicalInUseAttachments)
                        {
                            ChemicalInUse ID = new ChemicalInUse();

                            cmd.Parameters.AddWithValue("@AttachmentId", use.AttachmentId);
                            cmd.Parameters.AddWithValue("@ChemicalId", model.ChemicalId);
                            cmd.Parameters.AddWithValue("@FileType", use.FileType);
                            cmd.Parameters.AddWithValue("@FileName", use.FileName);
                            cmd.Parameters.AddWithValue("@AttachmentName", use.AttachmentName);
                            cmd.Parameters.AddWithValue("@FilePath", use.FilePath);
                            cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                            cmd.Parameters.Clear();

                        }
                    }
                }

                model = Get(model.ChemicalId);

                Log4NetLogger.LogExit(_FileName, nameof(AttachmentSave), Level.Info.ToString());
                return model.AttachmentList;
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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_CLS_ChemicalInUse_GetAll";

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
            catch (Exception)
            {
                throw;
            }
        }

        public ChemicalInUse Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());                

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_ChemicalInUse_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                ChemicalInUse _chemicalInUse = new ChemicalInUse();               

                if(ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _chemicalInUse.ChemicalId = Convert.ToInt32(dr["ChemicalId"]);
                    _chemicalInUse.DocumentNo = dr["DocumentNo"].ToString();
                    _chemicalInUse.Remarks = dr["Remarks"].ToString();
                    _chemicalInUse.Date = Convert.ToDateTime(dr["Date"].ToString());    
                }

                if (ds.Tables[1].Rows.Count > 0)
                {
                    List<Chemicals> _ChemicalsList = new List<Chemicals>();
                    foreach (DataRow dr in ds.Tables[1].Rows)
                    {
                        Chemicals Auto = new Chemicals();
                        Auto.CategoryId = Convert.ToInt32(dr["CategoryId"]);
                        Auto.ChemicalInUseId = Convert.ToInt32(dr["ChemicalInUseId"].ToString());
                        Auto.Category = Convert.ToInt32(dr["Category"]);
                        Auto.AreaofApplication = Convert.ToInt32(dr["AreaOfApplication"]);
                        Auto.ChemicalId = Convert.ToInt32(dr["ChemicalId"]);
                        Auto.KMMNO = dr["KMMNo"].ToString();
                        Auto.Properties = dr["Properties"].ToString();
                        Auto.Status = Convert.ToInt32(dr["Status"].ToString());
                        Auto.EffectiveDate = Convert.ToDateTime(dr["EffectiveDate"].ToString()); 
                        

                        _ChemicalsList.Add(Auto);
                    }
                    _chemicalInUse.ChemicalsList = _ChemicalsList;
                }
                if(ds.Tables[2].Rows.Count > 0)
                {
                    List<ChemicalInUseAttachments> _ChemicalAttachmentList = new List<ChemicalInUseAttachments>();

                    foreach(DataRow dr in ds.Tables[2].Rows)
                    {
                        ChemicalInUseAttachments obj = new ChemicalInUseAttachments();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _ChemicalAttachmentList.Add(obj);
                       
                    }
                    _chemicalInUse.AttachmentList = _ChemicalAttachmentList;
                }
                
               

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _chemicalInUse;
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
               

        public ChemicalInUse AutoGeneratedCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                ChemicalInUse chemicalInUse = new ChemicalInUse();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_ChemicalInUseAutoGenerateCode";

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    chemicalInUse = (from n in ds.Tables[0].AsEnumerable()
                                     select new ChemicalInUse
                                     {
                                         DocumentNo = Convert.ToString(n["DocumentNo"])
                                     }).FirstOrDefault();
                }



                Log4NetLogger.LogExit(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                return chemicalInUse;
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

        public Chemicals ChemicalNameData(int ChemicalId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ChemicalNameData), Level.Info.ToString());
                Chemicals _chemicals = new Chemicals();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_ChemicalNameData";
                        cmd.Parameters.AddWithValue("@ChemicalId", ChemicalId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    _chemicals = (from n in ds.Tables[0].AsEnumerable()
                                     select new Chemicals
                                     {
                                         KMMNO = Convert.ToString(n["KKMNumber"]),
                                         Properties = Convert.ToString(n["Properties"]),
                                         Status = Convert.ToInt32(n["Status"]),
                                         EffectiveDate = Convert.ToDateTime(n["EffectiveFromDate"]),


                                     }).FirstOrDefault();
                }


                Log4NetLogger.LogExit(_FileName, nameof(ChemicalNameData), Level.Info.ToString());
                return _chemicals;
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

        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_CIU_Attachment_Delete";
                        cmd.Parameters.AddWithValue("@AttachmentId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
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
        public void CategoryRowsDelete(int ID, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CategoryRowsDelete), Level.Info.ToString());
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_ChemicalInUse_Delete";
                        cmd.Parameters.AddWithValue("@ChemicalInUseId", ID);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
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
    }
}
