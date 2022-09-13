using System;
using System.Web.UI.WebControls;

namespace CP.Framework.ReportHelper
{
    public class LinkButtonExt : LinkButton
    {
        public LinkButtonExt() : base()
        {
        }

        public LinkButtonExt(ReportMasterEntity rptMstEntityPara)
        {
            this.rptMstEntity = rptMstEntityPara;
        }

        public ReportMasterEntity rptMstEntity { get; set; }

        public delegate void OnClickEventHandlerExt(object sender, EventArgsExt eventArgs);
        public event OnClickEventHandlerExt OnCustomClickEvent;

        protected override void OnClick(EventArgs e)
        {
            base.OnClick(e);
            if (this.OnCustomClickEvent != null)
            {
                this.OnCustomClickEvent(this, new EventArgsExt(this.rptMstEntity));
            }
        }

    }
}
