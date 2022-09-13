using CP.UETrack.Model.BER;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.Common
{
    public interface IReportLoadLovBAL
    {
        ReportLoadLovModel Load(string screenName);
    }
}
