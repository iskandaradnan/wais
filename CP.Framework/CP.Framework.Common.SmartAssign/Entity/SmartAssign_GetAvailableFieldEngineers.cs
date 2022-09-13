using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.SmartAssign.Entity
{
    public class SmartAssign_GetAvailableFieldEngineers
    {
        public int UserRegistrationId { get; set; }
        public int UserGradeId { get; set; }
        public string UserGrade { get; set; }
        public decimal DistanceInKms { get; set; }

        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public decimal DistanceInRoad { get; set; }
    }
}
