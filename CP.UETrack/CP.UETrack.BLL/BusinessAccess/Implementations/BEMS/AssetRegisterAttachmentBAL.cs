using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public class AssetRegisterAttachmentBAL : IAssetRegisterAttachmentBAL
    {
        private string _FileName = nameof(AssetRegisterAttachmentBAL);
        IAssetregisterAttachmentDAL _AssetRegisterAttachmentDAL;
        public AssetRegisterAttachmentBAL(IAssetregisterAttachmentDAL AssetRegisterAttachmentDAL)
        {
            _AssetRegisterAttachmentDAL = AssetRegisterAttachmentDAL;
        }

        public FileTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetRegisterAttachmentDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public AssetRegisterAttachment Save(AssetRegisterAttachment Document, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterAttachment result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _AssetRegisterAttachmentDAL.Save(Document, out ErrorMessage);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public AssetRegisterAttachment GetAttachmentDetails(string id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAttachmentDetails), Level.Info.ToString());
                var result = _AssetRegisterAttachmentDAL.GetAttachmentDetails(id);
                Log4NetLogger.LogExit(_FileName, nameof(GetAttachmentDetails), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public AssetRegisterAttachment Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterAttachmentDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterAttachmentDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
                
    }
}
