using System;
using System.Web.UI.WebControls;

namespace CP.Framework.ReportHelper
{
    public class TextBoxExt : TextBox
    {
        public TextBoxExt() : base()
        {
        }

        public TextBoxExt(ReportMasterEntity rptMstEntityPara)
        {
            this.rptMstEntity = rptMstEntityPara;
        }

        public ReportMasterEntity rptMstEntity { get; set; }

        public delegate void OnTextChangedEventHandlerExt(object sender, EventArgsExt eventArgs);
        public event OnTextChangedEventHandlerExt OnCustomTextChangedEvent;

        protected override void OnTextChanged(EventArgs e)
        {
            base.OnTextChanged(e);
            if (this.OnCustomTextChangedEvent != null)
            {
                this.OnCustomTextChangedEvent(this, new EventArgsExt(this.rptMstEntity));
            }
        }

    }
}
