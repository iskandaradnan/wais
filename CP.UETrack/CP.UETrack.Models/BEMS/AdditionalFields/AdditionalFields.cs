
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class AdditionalFieldsConfig
    {
        public List<AdditionalFields> additionalFields { get; set; }
    }
    public class AdditionalFields
    {
        public int AddFieldConfigId { get; set; }
        public int CustomerId { get; set; }
        public int ScreenNameLovId { get; set; }
        public int FieldTypeLovId { get; set; }
        public string FieldName { get; set; }
        public string Name { get; set; }
        public string DropDownValues { get; set; }
        public int RequiredLovId { get; set; }
        public int? PatternLovId { get; set; }
        public int? MaxLength { get; set; }
        public string PatternValue { get; set; }
        public string IsRequired { get; set; }
        public bool IsUsed { get; set; }
        public bool IsDeleted { get; set; }
    }
}