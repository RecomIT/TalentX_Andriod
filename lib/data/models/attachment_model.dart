class AttachmentModel{
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;
  String attachmentURL;
  AttachmentModel({this.attachmentName,this.attachmentPath,this.attachmentContent,this.attachmentExtention,this.attachmentURL});
}