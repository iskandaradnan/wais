using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;


namespace UETrack.Application.Web.Helpers
{
    public class FileUploadHelper
    {
        public static List<FileUploadDetModel> FileUpload(List<FileUploadDetModel> upload)
        {
            foreach (var val in upload)
            {
                if (val.DocumentId == 0 || val.DocumentId == null)
                {
                   // New Guid Creation

                   var guid = Guid.NewGuid().ToString();
                    val.GuId = guid;
                    
                }
                if (!string.IsNullOrEmpty(val.contentAsBase64String))
                {
                    val.FileName = val.GuId + "." + val.ContentType;
                    val.FilePath = val.FileName;                    
                }
            }
            return upload;
        }


        public  static void FileUploadCreate(List<FileUploadDetModel> fileAttach)
        {

            //  var path = Server.MapPath(Request.ApplicationPath) + @"Attachments";

            var path = System.Web.Hosting.HostingEnvironment.MapPath("~/Attachments");

           // var path = ConfigurationManager.AppSettings["FileUpload"];
            try
            {
                foreach (var val in fileAttach)
                {
                    if (!string.IsNullOrEmpty(val.contentAsBase64String))
                    {
                        var fullPath = System.IO.Path.Combine(path, val.FilePath);
                        
                        string[] files = System.IO.Directory.GetFiles(path, val.GuId + ".*");
                        foreach (string f in files)
                        {
                            System.IO.File.Delete(f);
                        }
                        var bytes = Convert.FromBase64String(val.contentAsBase64String);
                        using (FileStream file = File.Create(fullPath))
                        {
                            // fileAttach.FilePath = fullPath;
                            file.Write(bytes, 0, bytes.Length);
                            file.Close();
                        }                        
                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        //********************** Asset Register Accessories Tab *****************************

        public static List<AssetRegisterAccessoriesDetModel> FileUploadAccessories(List<AssetRegisterAccessoriesDetModel> upload)
        {
            foreach (var val in upload)
            {
                if (((val.AccessoriesId == 0 || val.AccessoriesId == null) || (val.DocumentTitle == "" || val.DocumentTitle == null)) && (val.ContentType != null || val.ContentType != ""))

                {
                    // New Guid Creation

                    var guid = Guid.NewGuid().ToString();
                    val.GuId = guid;

                }
                if (!string.IsNullOrEmpty(val.ContentAsBase64String))
                {
                    val.FileName = val.GuId + "." + val.ContentType;
                    val.FilePath = val.FileName;
                }
            }
            return upload;
        }

        public static void FileUploadCreateAccessories(List<AssetRegisterAccessoriesDetModel> fileAttach)
        {

            //  var path = Server.MapPath(Request.ApplicationPath) + @"Attachments";

            var path = System.Web.Hosting.HostingEnvironment.MapPath("~/Attachments");

            // var path = ConfigurationManager.AppSettings["FileUpload"];
            try
            {
                foreach (var val in fileAttach)
                {
                    if (!string.IsNullOrEmpty(val.ContentAsBase64String))
                    {
                        var fullPath = System.IO.Path.Combine(path, val.FilePath);

                        string[] files = System.IO.Directory.GetFiles(path, val.GuId + ".*");
                        foreach (string f in files)
                        {
                            System.IO.File.Delete(f);
                        }
                        var bytes = Convert.FromBase64String(val.ContentAsBase64String);
                        using (FileStream file = File.Create(fullPath))
                        {
                            // fileAttach.FilePath = fullPath;
                            file.Write(bytes, 0, bytes.Length);
                            file.Close();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

    }
}