using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.FEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Implementations.FEMS
{
   
    public class FemsEncryptDAL : IFemsEncryptDAL
    {
        private readonly string _FileName = nameof(FemsEncryptDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public FemsEncryptDAL()
        {

        }

        public BlockMstViewModel Get(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                BlockMstViewModel model = new BlockMstViewModel();
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return model;
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
    }
    }
