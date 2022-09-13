using System;
using System.ComponentModel;

namespace CP.UETrack.Model
{
    public static class Extensions
    {
        public static int GetValue(this AsisLovEnum value)
        {
            return (int) value;
        }

        public static string GetDescription(this AsisLovEnum value)
        {
            var field = value.GetType().GetField(value.ToString());

            var attribute = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute)) as DescriptionAttribute;

            return attribute == null ? value.ToString() : attribute.Description;
        }
    } 
}
