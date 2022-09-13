using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public  class ImageVideoUploadBAL : IImageVideoUploadBAL
    {
        private string _FileName = nameof(ImageVideoUploadBAL);
        IImageVideoUploadDAL _ImageVideoUploadDAL;
        public ImageVideoUploadBAL(IImageVideoUploadDAL ImageVideoUploadDAL)
        {
            _ImageVideoUploadDAL = ImageVideoUploadDAL;
        }

        public ImageVideoUploadModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ImageVideoUploadDAL.Load();
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

        public ImageVideoUploadModel Save(ImageVideoUploadModel ImageVideo)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                ImageVideoUploadModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _ImageVideoUploadDAL.Save(ImageVideo);
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

        public ImageVideoUploadModel GetUploadDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
                var result = _ImageVideoUploadDAL.GetUploadDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = _ImageVideoUploadDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
