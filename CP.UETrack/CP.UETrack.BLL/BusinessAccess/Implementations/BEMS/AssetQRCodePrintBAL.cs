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
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class AssetQRCodePrintBAL : IAssetQRCodePrintBAL
    {
        private string _FileName = nameof(AssetQRCodePrintBAL);
        IAssetQRCodePrintDAL _AssetQRCodePrintDAL;

        public AssetQRCodePrintBAL(IAssetQRCodePrintDAL AssetQRCodePrintDAL)
        {
            _AssetQRCodePrintDAL = AssetQRCodePrintDAL;
        }

        public AssetQRCodePrintModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetQRCodePrintDAL.Load();
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

        public AssetQRCodePrintModel Save(AssetQRCodePrintModel AssetQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                AssetQRCodePrintModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _AssetQRCodePrintDAL.Save(AssetQR);
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

        public AssetQRCodePrintModel Get(AssetQRCodePrintModel AssetQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetQRCodePrintDAL.Get(AssetQR);
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

        public AssetQRCodePrintModel GetModal(AssetQRCodePrintModel AssetQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
                var result = _AssetQRCodePrintDAL.GetModal(AssetQR);
                Log4NetLogger.LogExit(_FileName, nameof(GetModal), Level.Info.ToString());
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

        
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _AssetQRCodePrintDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
                var result = _AssetQRCodePrintDAL.Delete(Id);
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
