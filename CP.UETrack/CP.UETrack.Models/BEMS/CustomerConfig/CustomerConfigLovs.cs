using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class CustomerConfigLovs
    {
        public List<LovValue> DateFormatValues { get; set; }
        public List<LovValue> CurrencyFormatValues { get; set; }
        public List<LovValue> FMTimeMonth { get; set; }
        public List<LovValue> ThemeColorValues { get; set; }
    }
}