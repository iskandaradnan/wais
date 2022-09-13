using System;
using System.Web.UI.WebControls;

namespace CP.Framework.ReportHelper
{
    public class ButtonExt : Button
    {
        public ButtonExt() : base()
        {
        }

        public ButtonExt(ReportMasterEntity rptMstEntityPara)
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
