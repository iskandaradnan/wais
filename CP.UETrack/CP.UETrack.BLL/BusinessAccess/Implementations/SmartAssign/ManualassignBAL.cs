using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.UM
{

    public class ManualassignBAL : IManualassignBAL
    {
        #region Ctor/init
        private readonly IManualassignDAL _ManualassignDAL;
        private readonly static string fileName = nameof(ManualassignBAL);
        public ManualassignBAL(IManualassignDAL dal)
        {
            _ManualassignDAL = dal;

        }
        #endregion
        public ManualassignLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _ManualassignDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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

        public ManualassignViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ManualassignDAL.Get(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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



    

  


   

   




   
       
        public ManualassignViewModel Save(ManualassignViewModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ManualassignViewModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ManualassignDAL.Save(obj);
                //}
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        private static bool IsValid(ManualassignViewModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (/*string.IsNullOrEmpty(model.AssetTypeCode)*/ model.WorkOrderId == 0 || model.WorkOrderId == null)

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            //else if (_assetClassificationDAL.IsClassificationCodeDuplicate(model))
            //{
            //    ErrorMessage = "Asset Classication Code should be unique";
            //}
            //else if (_assetClassificationDAL.IsRecordModified(model))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }

    }
}



