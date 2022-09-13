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
    public class AssetRegisterWarrantyProviderTabBAL : IAssetRegisterWarrantyProviderTabBAL
    {
        //private readonly IAssetRegisterWarrantyProviderTabDAL AssetRegisterWarrantyProviderTabDAL;
        private string _FileName = nameof(AssetRegisterWarrantyProviderTabBAL);
        IAssetRegisterWarrantyProviderTabDAL _AssetRegisterWarrantyProviderTabDALL;
        public AssetRegisterWarrantyProviderTabBAL(IAssetRegisterWarrantyProviderTabDAL AssetRegisterWarrantyProviderTabDAL)
        {
            _AssetRegisterWarrantyProviderTabDALL = AssetRegisterWarrantyProviderTabDAL;
        }

        public WarrantyProviderCategoryLov Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetRegisterWarrantyProviderTabDALL.Load();
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

        public AssetRegisterWarrantyProvider Save(AssetRegisterWarrantyProvider warranty, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterWarrantyProvider result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _AssetRegisterWarrantyProviderTabDALL.Save(warranty);
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

        private bool IsValid(AssetRegisterWarrantyProvider warranty, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            foreach (var i in warranty.AssetRegisterWarrantyProviderTabGrid)
            {
                if (string.IsNullOrEmpty(i.ContactNo))
                {
                    ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
                }
                else if (_AssetRegisterWarrantyProviderTabDALL.IsRoleDuplicate(warranty))
                {
                    ErrorMessage = "User Role should be unique";
                }
                else if (_AssetRegisterWarrantyProviderTabDALL.IsRecordModified(warranty))
                {
                    ErrorMessage = "Record Modified. Please Re-Select";
                }
                else
                {
                    isValid = true;
                }
            }
            return isValid;
        }

        public AssetRegisterWarrantyProvider Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterWarrantyProviderTabDALL.Get(Id);
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

        //public bool Delete(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //        //_AssetRegisterWarrantyProviderTabDALL.Delete(Id);
        //        Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
        //        return _AssetRegisterWarrantyProviderTabDALL.Delete(Id);
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
    }
}
