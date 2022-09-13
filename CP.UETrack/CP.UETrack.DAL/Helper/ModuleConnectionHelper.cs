using CP.Framework.Common.Logging;
using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using CP.UETrack.Model.Enum;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.Helper
{
   public static class ModuleConnectionHelper
    {
         static  private readonly string _FileName;
         static public  string ConnectionString { get;  set; }
         static readonly UserDetailsModel _UserSession;
         static public string conn;
      

        static ModuleConnectionHelper ()
            {
             _FileName = nameof(ModuleConnectionHelper);
           
        }





      


        public static string GetModuleConnectionString()
        {
            var _UserSession = new SessionHelper().UserSession();
            Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionString), Level.Info.ToString());
            var session = _UserSession.ModuleId;
            try
            {
 
                if (_UserSession !=null)
                {
                    if (_UserSession.ModuleId== (int)MODULE.ICT)
                    {
                        conn = "UETrackICTConnectionString";
                    }
                    else
                    {
                        conn = "UETrackCommonConnectionString";
                    }
                }
                else
                {
                    conn = "UETrackCommonConnectionString";
                }
                ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;
                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionString), Level.Info.ToString());
                return ConnectionString;
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionString), Level.Error.ToString());
                throw ex;
            }
        }

        public static string GetModuleConnectionKey()
        {
            var _UserSession = new SessionHelper().UserSession();
            Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionKey), Level.Info.ToString());
            var session = _UserSession.ModuleId;
            try
            {

                if (_UserSession != null)
                {
                    if (_UserSession.ModuleId == (int)MODULE.ICT)
                    {
                        conn = "UETrackICTConnectionString";
                    }
                    else
                    {
                        conn = "UETrackCommonConnectionString";
                    }
                }
                else
                {
                    conn = "UETrackCommonConnectionString";
                }
                
                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionKey), Level.Info.ToString());
                return conn;
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionKey), Level.Error.ToString());
                throw ex;
            }
        }


        public static string GetModuleConnectionKey( int serviceid)
        {
            
            try
            {
                switch (serviceid)
                {
                    case 6://"ICT"
                        conn = "UETrackICTConnectionString";
                        break;
                    case 1:// "FEMS"
                        conn = "FEMSUETrackCommonConnectionString";
                        break;
                    case 2://"BEMS"
                        conn = "UETrackCommonConnectionString";
                        break;
                    case 7://"FMS"
                        conn = "UETrackConnectionString";
                        break;
                    case 0://"BEMS"
                        conn = "MASTERUETrackCommonConnectionString";
                        break;
                }


                ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;

                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionKey), Level.Info.ToString());
                return ConnectionString;
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModuleConnectionKey), Level.Error.ToString());
                throw ex;
            }
        }
    }
}
