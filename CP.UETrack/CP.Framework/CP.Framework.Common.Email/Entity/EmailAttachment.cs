namespace CP.Framework.Common.Email
{
    class EmailAttachment
    {
        public int EmailAttachmentId { get; set; }
        public int EmailQueueId { get; set; }
        public string AttachmentName { get; set; }
        public string AttachmentType { get; set; }
        public byte[] Content { get; set; }
    }
}
