using System;
using System.IO;
using System.Web;

namespace CP.UETrack.Application.Web.Helper
{
    public static class FileConversionHelper
    {
        public static byte[] ConvertFileToStream(HttpPostedFile file) {
       
            var fileStream = file.InputStream;
            var fileSize = file.ContentLength;
            var fileRecieved = new byte[fileSize];
            fileStream.Read(fileRecieved, 0, fileSize);

            return fileRecieved;
        }

        public static string ConvertStreamToFile(string fileExtn)
        {
            try
            {
                var fileBytes = new byte[] { };

                if(!string.IsNullOrEmpty(fileExtn) && fileExtn.Contains("/"))
                {
                    fileExtn= fileExtn.Substring(fileExtn.IndexOf("/", StringComparison.Ordinal) + 1);
                } 
                else
                {
                    fileExtn = "png";
                }
                var filename = "Humanresorcefile." + fileExtn;

                var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "images\\ReceivedFiles");
                var fullFilePath = Path.Combine(filePath, filename);

                if (!Directory.Exists(filePath))
                {
                    Directory.CreateDirectory(filePath);
                }                

                using (Stream file = File.OpenWrite(fullFilePath))
                {
                    file.Write(fileBytes, 0, fileBytes.Length);
                }
                return filename;
            }
            catch (Exception)
            {
                throw;
            }            
        }

        #region Converting Image to Byte

        public static byte[] ReadImage(string p_postedImageFileName)
        {
            var p_fileType = new string[] { ".gif", ".png", ".jpeg", ".jpg" };
            var isValidFileType = false;
            try
            {
                var file = new FileInfo("E:\\Asis\\MockDev\\CP.UETrack\\CP.UETrack.Web\\images\\" + p_postedImageFileName);

                foreach (string strExtensionType in p_fileType)
                {
                    if (strExtensionType == file.Extension)
                    {
                        isValidFileType = true;
                        break;
                    }
                }
                var filename = "E:\\Asis\\MockDev\\CP.UETrack\\CP.UETrack.Web\\images\\" + p_postedImageFileName;
                if (isValidFileType)
                {
                    using (var fs = new FileStream(filename, FileMode.Open, FileAccess.Read))
                    {
                        using (var br = new BinaryReader(fs))
                        {
                            var image = br.ReadBytes((int)fs.Length);

                            br.Close();

                            fs.Close();

                            return image;
                        }
                    }
                }
                return null;
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Converting Byte to Image

        public static string ConvertbyteArrayToImage(byte[] byteArrayIn)
        {
            System.Drawing.Image newImage;

            var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "images\\ReceivedFiles");
            var fullFilePath = Path.Combine(filePath, "ReceivedImage.gif");

            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }

            var strFileName = fullFilePath;
            if (byteArrayIn != null)
            {
                using (MemoryStream stream = new MemoryStream(byteArrayIn))
                {
                    newImage = System.Drawing.Image.FromStream(stream);

                    newImage.Save(strFileName);
                }                               
            }
            return strFileName;
        }

        #endregion

        #region Getting Temporary Folder Name

        private static string GetTempFolderName()
        {
            var strTempFolderName = Environment.GetFolderPath(Environment.SpecialFolder.InternetCache) + @"\";

            if (Directory.Exists(strTempFolderName))
            {
                return strTempFolderName;
            }
            else
            {
                Directory.CreateDirectory(strTempFolderName);
                return strTempFolderName;
            }
        }

        #endregion


        //protected void Button1_Click(object sender, EventArgs e)
        //{
        //    postedImage = this.imgUpload.PostedFile;
        //    byteImageData = ReadImage(postedImage.FileName, new string[] { ".gif", ".jpg", ".bmp" });
        //}

        //protected void Button2_Click(object sender, EventArgs e)
        //{
        //    byteArrayToImage(byteImageData);
        //}
   
}
}