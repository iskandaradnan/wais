using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Configuration;
using Microsoft.Web.Helpers;
using System.Web;
using System.IO;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class AssetRegisterAttachmentDAL : IAssetregisterAttachmentDAL
    {

        private readonly string _FileName = nameof(AssetRegisterAttachmentDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public AssetRegisterAttachment attachment(AssetRegisterAttachment download)
        {
            throw new NotImplementedException();
        }

        public FileTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                FileTypeDropdown FileTypeDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "FMDocument");
                        cmd.CommandText = "uspFM_Dropdown_Others";//spname
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    FileTypeDropdown = new FileTypeDropdown();
                    FileTypeDropdown.FileTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return FileTypeDropdown;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
        }

        
        public AssetRegisterAttachment Save(AssetRegisterAttachment Document, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());                
                var dbAccessDAL = new DBAccessDAL();
                ErrorMessage = string.Empty;
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pGuId", Convert.ToString(Document.DocumentGuId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("DocumentId", typeof(int));
                dt.Columns.Add("GuId", typeof(string));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("DocumentNo", typeof(string));
                dt.Columns.Add("DocumentTitle", typeof(string));
                dt.Columns.Add("DocumentDescription", typeof(string));
                dt.Columns.Add("DocumentCategory", typeof(int));
                dt.Columns.Add("DocumentCategoryOthers", typeof(string));
                dt.Columns.Add("DocumentExtension", typeof(string));
                dt.Columns.Add("MajorVersion", typeof(int));
                dt.Columns.Add("MinorVersion", typeof(int));
                dt.Columns.Add("FileType", typeof(int));
                dt.Columns.Add("FilePath", typeof(string));
                dt.Columns.Add("FileName", typeof(string));
                dt.Columns.Add("UploadedDateUTC", typeof(DateTime));
                dt.Columns.Add("ScreenId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Active", typeof(bool));
                dt.Columns.Add("DocumentGuid", typeof(string));                

                var deletedId = Document.FileUploadList.Where(y => y.IsDeleted).Select(x => x.DocumentId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildRecords(idstring);
                }

                foreach (var i in Document.FileUploadList.Where(y => !y.IsDeleted))
                {                        
                            dt.Rows.Add(i.DocumentId, i.GuId, _UserSession.CustomerId, _UserSession.FacilityId, i.DocumentNo, i.DocumentTitle, 
                                i.DocumentDescription, i.DocumentCategory, i.DocumentCategoryOthers,i.DocumentExtension, i.MajorVersion,i.MinorVersion, 
                                i.FileType, i.FilePath, i.FileName, i.UploadedDateUTC, i.ScreenId, i.Remarks, _UserSession.UserId, i.Active,i.DocumentGuId);                  
                        
                    }
                DataSetparameters.Add("@pFMDocument", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_Attachment_Save", parameters, DataSetparameters);
                if (dt1 != null)

                {
                    int k = 0;
                    foreach (DataRow row in dt1.Rows)
                    {
                        Document.FileUploadList[k].DocumentId = Convert.ToInt32(row["DocumentId"]);
                        Document.FileUploadList[k].Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        k = (k + 1);
                    }
                    //foreach (DataRow row in dt1.Rows)
                    //{
                    //    foreach (var val in Document.FileUploadList)
                    //    {
                    //        val.DocumentId = Convert.ToInt32(row["DocumentId"]);
                    //        val.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    //    }
                    //}
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Document;
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

        public AssetRegisterAttachment Save_ByServiceId(AssetRegisterAttachment Document,int ServiceId, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                ErrorMessage = string.Empty;
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pGuId", Convert.ToString(Document.DocumentGuId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("DocumentId", typeof(int));
                dt.Columns.Add("GuId", typeof(string));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("DocumentNo", typeof(string));
                dt.Columns.Add("DocumentTitle", typeof(string));
                dt.Columns.Add("DocumentDescription", typeof(string));
                dt.Columns.Add("DocumentCategory", typeof(int));
                dt.Columns.Add("DocumentCategoryOthers", typeof(string));
                dt.Columns.Add("DocumentExtension", typeof(string));
                dt.Columns.Add("MajorVersion", typeof(int));
                dt.Columns.Add("MinorVersion", typeof(int));
                dt.Columns.Add("FileType", typeof(int));
                dt.Columns.Add("FilePath", typeof(string));
                dt.Columns.Add("FileName", typeof(string));
                dt.Columns.Add("UploadedDateUTC", typeof(DateTime));
                dt.Columns.Add("ScreenId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Active", typeof(bool));
                dt.Columns.Add("DocumentGuid", typeof(string));

                var deletedId = Document.FileUploadList.Where(y => y.IsDeleted).Select(x => x.DocumentId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildRecords(idstring);
                }

                foreach (var i in Document.FileUploadList.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(i.DocumentId, i.GuId, _UserSession.CustomerId, _UserSession.FacilityId, i.DocumentNo, i.DocumentTitle,
                        i.DocumentDescription, i.DocumentCategory, i.DocumentCategoryOthers, i.DocumentExtension, i.MajorVersion, i.MinorVersion,
                        i.FileType, i.FilePath, i.FileName, i.UploadedDateUTC, i.ScreenId, i.Remarks, _UserSession.UserId, i.Active, i.DocumentGuId);

                }
                DataSetparameters.Add("@pFMDocument", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable_ByServiceID("uspFM_Attachment_Save", parameters, DataSetparameters,ServiceId);
                if (dt1 != null)

                {
                    int k = 0;
                    foreach (DataRow row in dt1.Rows)
                    {
                        Document.FileUploadList[k].DocumentId = Convert.ToInt32(row["DocumentId"]);
                        Document.FileUploadList[k].Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        k = (k + 1);
                    }
                    //foreach (DataRow row in dt1.Rows)
                    //{
                    //    foreach (var val in Document.FileUploadList)
                    //    {
                    //        val.DocumentId = Convert.ToInt32(row["DocumentId"]);
                    //        val.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    //    }
                    //}
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Document;
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

        public AssetRegisterAttachment GetAttachmentDetails(string id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAttachmentDetails), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new AssetRegisterAttachment();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();               
                parameters.Add("@pDocumentGuId", id.ToString());
                
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_Attachment_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    var historyList = (from n in dt.AsEnumerable()
                                       select new FileUploadDetModel
                                       {                                           
                                           FileType = Convert.ToInt32(n["FileType"]),
                                           FileName = Convert.ToString(n["FileName"]),
                                           FilePath = Convert.ToString(n["FilePath"]),
                                           DocumentId = Convert.ToInt32(n["DocumentId"]),
                                           DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                           DocumentExtension = Convert.ToString(n["DocumentExtension"]),                                           
                                           GuId = Convert.ToString(n["GuId"]),
                                           DocumentGuId = id

                                       }).ToList();

                    if (historyList != null && historyList.Count > 0)
                    {
                        obj.FileUploadList = historyList;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAttachmentDetails), Level.Info.ToString());
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

        public void deleteChildRecords(string id)
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
                        cmd.CommandText = "uspFM_Attachment_Delete";
                        cmd.Parameters.AddWithValue("@pDocumentId", id);

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

        public bool Delete(int Id)
        {
            throw new NotImplementedException();
            
        }

        public AssetRegisterAttachment Get(int Id)
        {
            throw new NotImplementedException();
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }
    }
}
