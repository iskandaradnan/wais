namespace CP.UETrack.Model.EMail
{
    using System;

    public class EmailAttachment
    {
        public int EmailId { get; set; }
	    public string AttachmentName { get; set; }
        public string AttachmentType { get; set; }
        public byte[] Content { get; set; }

    }
}
