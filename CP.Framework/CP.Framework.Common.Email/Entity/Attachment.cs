namespace CP.Framework.Common.Email
{
    using System;

    public class Attachment
    {
        public int EmailId { get; set; }
	    public string AttachmentName { get; set; }
        public string AttachmentType { get; set; }
        public byte[] Content { get; set; }

    }
}
