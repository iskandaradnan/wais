using System;

namespace CP.Framework.ReportHelper
{
    public class EventArgsExt : EventArgs
    {
        public EventArgsExt() : base()
        {
        }

        public EventArgsExt(ReportMasterEntity rptMstEntityPara)
        {
            this.rptMstEntity = rptMstEntityPara;
        }

        public EventArgsExt(ReportMasterEntity rptMstEntityPara, ReportParamEntity rptParaEntityPara)
        {
            this.rptMstEntity = rptMstEntityPara;
            this.rptParaEntity = rptParaEntityPara;
        }

        public ReportMasterEntity rptMstEntity { get; set; }

        public ReportParamEntity rptParaEntity { get; set; }
    }
}