using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class ReportParameters
    {
        public int ParamId { get; set; }
        public string ReportKeyId { get; set; }
        public int LevelKeyId { get; set; }
        public int ParamKeyId { get; set; }
        public string ParentSpName { get; set; }
        public string ReportParamName { get; set; }
        public string ReportParamValue { get; set; }
        public Nullable<bool> HasDefaultValue { get; set; }
        public Nullable<bool> HasSessionValue { get; set; }
        public string SessionProperty { get; set; }
        public Nullable<bool> IsVisible { get; set; }
        public Nullable<bool> IsEnabled { get; set; }
        public Nullable<bool> IsDatePicker { get; set; }
        public Nullable<bool> IsDateTimePicker { get; set; }
        public Nullable<bool> IsMultiParam { get; set; }
        public string MultiParamDataSorceSp { get; set; }
        public string MultiParamValueField { get; set; }
        public string MultiParamLabelField { get; set; }
        public Nullable<bool> IsMultiParamHasCondition { get; set; }
        public Nullable<bool> HasCascading { get; set; }
        public string CascadingDataSorceSp { get; set; }
        public Nullable<bool> IsValueFieldAsCascading { get; set; }
        public string ReportParamNameToCascading { get; set; }
        public List<ReportMultiParameters> ReportMultiParameters { get; set; }
    }
}
