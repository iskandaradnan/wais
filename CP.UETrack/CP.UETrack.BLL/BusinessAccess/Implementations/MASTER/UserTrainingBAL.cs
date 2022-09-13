using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.MASTER;
using CP.UETrack.DAL.DataAccess.Contracts.MASTER;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.UserTraining;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.MASTER
{
    public class UserTrainingBAL : IUserTrainingBAL
    {
        private string _FileName = nameof(UserTrainingBAL);
        IUserTrainingDAL _UserTrainingDAL;
        public UserTrainingBAL(IUserTrainingDAL UserTrainingDAL)
        {
            _UserTrainingDAL = UserTrainingDAL;
        }

        public UserTrainingDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserTrainingDAL.Load();
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
        public UserTrainingCompletion Save(UserTrainingCompletion usertraining, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                UserTrainingCompletion result = null;

                //if (IsValid(usertraining, out ErrorMessage))
                //{
                    result = _UserTrainingDAL.Save(usertraining, out ErrorMessage);
               // }

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
        //private bool IsValid(UserTrainingCompletion usertraining, out string ErrorMessage)
        //{
        //    ErrorMessage = string.Empty;
        //    var isValid = false;
        //    foreach (var i in usertraining.UserTrainingGridData)
        //    {
        //        if (i.ServiceId == 0 || i.CategorySystemId == 0)
        //        {
        //            ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
        //        }

        //        //else if (_EODTypeCodeMappingDAL.IsRoleDuplicate(EODTypeCodeMapping))
        //        //{
        //        //    ErrorMessage = "User Role should be unique";
        //        //}
        //        //else if (_EODTypeCodeMappingDAL.IsRecordModified(EODTypeCodeMapping))
        //        //{
        //        //    ErrorMessage = "Record Modified. Please Re-Select";
        //        //}
        //        else
        //        {
        //            isValid = true;
        //        }
        //    }
        //    return isValid;
        //}

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _UserTrainingDAL.GetAll(pageFilter);
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

        public UserTrainingCompletion Get(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UserTrainingDAL.Get(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _UserTrainingDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        public TrainingFeedback SaveFeedback(TrainingFeedback feedback, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveFeedback), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TrainingFeedback result = null;

                //if (IsValid(usertraining, out ErrorMessage))
                //{
                result = _UserTrainingDAL.SaveFeedback(feedback, out ErrorMessage);
                // }

                Log4NetLogger.LogExit(_FileName, nameof(SaveFeedback), Level.Info.ToString());
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

        public TrainingFeedback GetFeedback(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetFeedback), Level.Info.ToString());
                var result = _UserTrainingDAL.GetFeedback(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetFeedback), Level.Info.ToString());
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
    }
}
