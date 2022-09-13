using System;

namespace CP.Framework.ReportHelper
{
    [Serializable]
    public class ReportFilterCtrlSet
    {
        public ReportFilterCtrlSet()
        {

        }
        public ReportFilterCtrlSet(string ctrlType, string ctrlName, string ctrlText, string ctrlValue, bool isCtrlVisible, bool isCtrlEnabled, bool isCtrlDatePicker)
        {
            this.CtrlType = ctrlType;
            this.CtrlID = ctrlName;
            this.CtrlText = ctrlText;
            this.CtrlValue = ctrlValue;
            this.IsCtrlVisible = isCtrlVisible;
            this.IsCtrlEnabled = isCtrlEnabled;            
            this.IsDatePicker = isCtrlDatePicker;
        }
        public string CtrlType { get; set; }
        public string CtrlID { get; set; }
        public string CtrlText { get; set; }
        public string CtrlValue { get; set; }
        public bool IsCtrlVisible { get; set; }
        public bool IsCtrlEnabled { get; set; }       
        public bool IsDatePicker { get; set; }
    }
}
