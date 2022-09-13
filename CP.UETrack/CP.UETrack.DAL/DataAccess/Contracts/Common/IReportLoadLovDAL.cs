using CP.UETrack.Model.BER;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.Common
{
   public interface IReportLoadLovDAL
    {
        ReportLoadLovModel Load(string screenName);
    }
}
