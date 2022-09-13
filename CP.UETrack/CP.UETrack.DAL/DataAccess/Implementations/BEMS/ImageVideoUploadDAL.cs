using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class ImageVideoUploadDAL : IImageVideoUploadDAL
    {

        private readonly string _FileName = nameof(ImageVideoUploadDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        
        public ImageVideoUploadModel Load()
        {
            throw new NotImplementedException();
        }

        public ImageVideoUploadModel Save(ImageVideoUploadModel ImageVideo)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pGuId", Convert.ToString(ImageVideo.DocumentGuId));
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
                dt.Columns.Add("DocumentGuId",typeof(string));

               // var imagevideo = ImageVideo.ImageVideoUploadListData.Where(x => x.contentAsBase64String != "" && x.contentAsBase64String != null && x.DocumentId >= 0);

                foreach (var i in ImageVideo.ImageVideoUploadListData.Where(x=> !((string.IsNullOrEmpty(x.Remarks)) && (string.IsNullOrEmpty(x.contentAsBase64String)) && x.DocumentId == 0)))
                {
                    //if ((!string.IsNullOrEmpty(i.contentAsBase64String)) && i.DocumentId != 0)
                    //{                   
                        dt.Rows.Add(i.DocumentId, i.GuId, _UserSession.CustomerId, _UserSession.FacilityId, i.DocumentNo, i.DocumentTitle, i.DocumentDescription,
                            i.DocumentCategory, i.DocumentCategoryOthers, i.DocumentExtension, i.MajorVersion, i.MinorVersion, i.FileType, i.FilePath, i.FileName,
                            i.UploadedDateUTC, i.ScreenId, i.Remarks, _UserSession.UserId, i.Active, i.DocumentGuId);
                   // }
                }
                DataSetparameters.Add("@pFMDocument", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngAssetAttachment_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in ImageVideo.ImageVideoUploadListData)

                        {
                            val.DocumentId = Convert.ToInt32(row["DocumentId"]);
                            val.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return ImageVideo;
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

        public ImageVideoUploadModel GetUploadDetails(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ImageVideoUploadModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();                
                parameters.Add("@pDocumentGuId", Id.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetAttachment_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    var historyList = (from n in dt.AsEnumerable()
                                       select new FileUploadDetModel
                                       {                                           
                                           FileName = Convert.ToString(n["FileName"]),
                                           FilePath = Convert.ToString(n["FilePath"]),
                                           DocumentId = Convert.ToInt32(n["DocumentId"]),
                                           DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                           DocumentExtension = Convert.ToString(n["DocumentExtension"]),                                           
                                           GuId = Convert.ToString(n["GuId"]),
                                           Remarks=Convert.ToString(n["Remarks"]),
                                           DocumentGuId = Id

                                       }).ToList();


                    if (historyList != null && historyList.Count > 0)
                    {
                        obj.ImageVideoUploadListData = historyList;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
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
                parameters.Add("@pDocumentId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_Attachment_Delete", parameters, DataSetparameters);
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
    }
}
