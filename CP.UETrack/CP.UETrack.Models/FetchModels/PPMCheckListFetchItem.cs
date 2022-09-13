using System;

namespace CP.UETrack.Model.FetchModels
{
    public class PPMCheckListFetchItem: FetchPagination
    {
        public int ChecklistItemId { get; set; }  
        public string Name { get; set; }
        public int Order { get; set; }
        public bool IsDeleted { get; set; }

    }
}
