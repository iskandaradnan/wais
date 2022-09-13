using System;
using System.Web.UI.WebControls;

namespace CP.Framework.ReportHelper
{
    public class DropDownListExt : DropDownList
    {
        public DropDownListExt(ReportMasterEntity rptMstEntity)
        {
            this.rptMstEntity = rptMstEntity;
        }

        public DropDownListExt(ReportMasterEntity rptMstEntity, ReportParamEntity rptParaEntityPara)
        {
            this.rptMstEntity = rptMstEntity;
            this.rptParaEntity = rptParaEntityPara;
        }

        public ReportMasterEntity rptMstEntity { get; set; }
        public ReportParamEntity rptParaEntity { get; set; }

        public delegate void OnSelectedIndexChangedEventHandlerExt(object sender, EventArgsExt eventArgs);
        public event OnSelectedIndexChangedEventHandlerExt OnCustomSelectedIndexChangedEvent;

        protected override void OnSelectedIndexChanged(EventArgs e)
        {
            base.OnSelectedIndexChanged(e);
            if (this.OnCustomSelectedIndexChangedEvent != null)
            {
                this.OnCustomSelectedIndexChangedEvent(this, new EventArgsExt(this.rptMstEntity, this.rptParaEntity));
            }
        }
    }
}