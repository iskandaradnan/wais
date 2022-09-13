using System;
using System.Text;
using System.Security.Cryptography;
using System.IO;

namespace CP.Framework.Security.Cryptography
{
    public static class CryptoProvider
    {
        const int SALT_BYTE_SIZE = 44;
        const int IntPasswordIterations = 4;
        const string StrHashAlgorithm = "SHA512";
        const string StrVector = "@ZBXc3D4e5F6s7H8@YB2iQD4D5k6g7LP";
        const string StrSaltValue = "Admin@Ch@ngep0nd";
        const string StrPassPhrase = "Ch@ngep0ndPWD!";

        #region Rijndael

        /// <summary>
        /// Encrypt String
        /// </summary>
        /// <param name="strText"></param>
        /// <returns></returns>
        public static string EncryptString(string strText)
        {
            string functionReturnValue = null;
            try
            {
                byte[] byteVectors = null;
                byte[] cipherTextBytes = null;
                byte[] saltValueBytes = null;
                string cipherText = null;
                RijndaelManaged symmetricKey;
                PasswordDeriveBytes password;
                byte[] keyBytes = null;
                const int keySize = 256;
                byteVectors = Encoding.ASCII.GetBytes(StrVector);
                saltValueBytes = Encoding.ASCII.GetBytes(StrSaltValue);
                byte[] plainTextBytes = null;
                if (strText == null)
                {
                    throw new ArgumentNullException(strText);
                }
                plainTextBytes = Encoding.UTF8.GetBytes(strText);

                password = new PasswordDeriveBytes(StrPassPhrase, saltValueBytes, StrHashAlgorithm, IntPasswordIterations);

                keyBytes = password.GetBytes(keySize / 8);
                using (symmetricKey = new RijndaelManaged())
                {
                    symmetricKey.BlockSize = 256;
                    symmetricKey.Mode = CipherMode.CBC;

                    using (ICryptoTransform encryptor = symmetricKey.CreateEncryptor(keyBytes, byteVectors))
                    {
                        using (MemoryStream memoryStream = new MemoryStream())
                        {
                            using (CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                            {
                                cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
                                cryptoStream.FlushFinalBlock();
                                cipherTextBytes = memoryStream.ToArray();
                            }
                        }
                    }

                    cipherText = Convert.ToBase64String(cipherTextBytes);
                    functionReturnValue = cipherText;
                }

            }
            catch (Exception)
            {
                throw;
            }
            return functionReturnValue;
        }

        /// <summary>
        /// Decrypt String
        /// </summary>
        /// <param name="strText"></param>
        /// <returns></returns>
        public static string DecryptString(string strText)
        {
            string functionReturnValue = null;

            try
            {
                string strDecryptText = null;
                const int keySize = 256;
                byte[] initVectorBytes = null;
                byte[] cipherTextBytes = null;
                PasswordDeriveBytes password;
                byte[] keyBytes = null;
                RijndaelManaged symmetricKey;
                ICryptoTransform decryptor;
                MemoryStream memoryStream;
                byte[] saltValueBytes = null;
                byte[] plainTextBytes = null;
                var decryptedByteCount = 0;
                initVectorBytes = Encoding.ASCII.GetBytes(StrVector);
                saltValueBytes = Encoding.ASCII.GetBytes(StrSaltValue);
                if (strText == null)
                {
                    throw new ArgumentNullException(strText);
                }
                cipherTextBytes = Convert.FromBase64String(strText.Replace(" ", "+"));
                password = new PasswordDeriveBytes(StrPassPhrase, saltValueBytes, StrHashAlgorithm, IntPasswordIterations);

                keyBytes = password.GetBytes(keySize / 8);
                using (symmetricKey = new RijndaelManaged())
                {
                    symmetricKey.BlockSize = 256;
                    symmetricKey.Mode = CipherMode.CBC;
                    decryptor = symmetricKey.CreateDecryptor(keyBytes, initVectorBytes);
                    using (memoryStream = new MemoryStream(cipherTextBytes))
                    {
                        using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
                        {

                            plainTextBytes = new byte[cipherTextBytes.Length + 1];
                            decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);

                            strDecryptText = Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
                            functionReturnValue = strDecryptText;
                        }
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
            return functionReturnValue;

        }

        /// <summary>
        /// Create Hash Value
        /// </summary>
        /// <param name="OriginalString"></param>
        /// <returns></returns>
        public static string CreateHashValue(String OriginalString)
        {
            var saltValueBytes = Encoding.ASCII.GetBytes(StrSaltValue);
            var EncryptedPwd = EncryptString(OriginalString);
            return Convert.ToBase64String(new Rfc2898DeriveBytes(EncryptedPwd, saltValueBytes, IntPasswordIterations).GetBytes(SALT_BYTE_SIZE));
        }

        /// <summary>
        /// Compare Hash Value
        /// </summary>
        /// <param name="OriginalString"></param>
        /// <param name="dbHashValue"></param>
        /// <returns></returns>
        public static bool CompareHashValue(string OriginalString, string dbHashValue)
        {
            return (CreateHashValue(OriginalString) == dbHashValue);
        }
        #endregion


    }
}
