using System;

namespace CP.UETrack.Models
{
    [Serializable]
    public class AccessibleServices
    {
        public bool showFEMS { get; set; }
        public bool showBEMS { get; set; }
        public bool showLLS { get; set; }
        public bool showCLS { get; set; }
        public bool showHWMS { get; set; }
        public bool showFMS { get; set; }
        public bool showSP { get; set; }
        //public bool showBI { get; set; }
        public bool showVM { get; set; }
        public bool showQAP { get; set; }
        public bool showHD { get; set; }
        //public bool showCOMM { get; set; }
        public bool showBER { get; set; }
        public bool showGM { get; set; }
        public bool showSR { get; set; }
        public bool showWP { get; set; }
        public bool showUM { get; set; }
        public bool showReports { get; set; }
        public bool showDeductions { get; set; }
        public bool showVRC { get; set; }
        public bool isBPK { get; set; }
        public bool isStateEngr { get; set; }
        public bool showWebPortal { get; set; }
        public bool showWPM { get; set; }
        public bool showEOD { get; set; }
        public bool showHSIP { get; set; }
        public bool showFIN { get; set; }
    }
}
