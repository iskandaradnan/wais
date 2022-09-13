
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class CustomerConfig
    {
        public List<ConfigValues> ConfigurationValues {get;set;}
    }

    public class ConfigValues
    {
        public int ConfigValueId { get; set; }
        public int CustomerId { get; set; }
        public int ConfigKeyId { get; set; }
        public int ConfigKeyLovId { get; set; }
        public int UserId { get; set; }        
        
    }
}