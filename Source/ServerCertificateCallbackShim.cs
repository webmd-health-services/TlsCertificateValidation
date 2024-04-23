using System;
using System.Management.Automation;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace TlsCertificateValidation
{
    public static class ServerCertificateCallbackShim
    {
        private static void WriteLine(bool write, string line)
        {
            if( !write )
                return;
            
            Console.WriteLine(line);
        }

        private static bool ConsoleEnabled()
        {
            var enableConsoleOutput =
                Environment.GetEnvironmentVariable("TLSCV_ENABLE_CONSOLE_OUTPUT");
            return !string.IsNullOrEmpty(enableConsoleOutput);
        }

        public static void RegisterScriptBlockValidator(ScriptBlock validator)
        {

            WriteLine(ConsoleEnabled(), "Validator  registered");

            ServicePointManager.ServerCertificateValidationCallback = (
                object sender,
                X509Certificate certificate,
                X509Chain chain,
                SslPolicyErrors sslPolicyErrors
            ) =>
                {
                    var write = ConsoleEnabled();

                    WriteLine(write, "           starting");
                    var result = validator.Invoke( new[] { sender, certificate, chain, sslPolicyErrors } );
                    WriteLine(write, "           completed");

                    if( result.Count == 0 )
                    {
                        WriteLine(write, "           returned   no results");
                        return false;
                    }

                    if( result[0] == null || result[0].BaseObject == null )
                    {
                        WriteLine(write, "           returned   null");
                        return false;
                    }
                    
                    var baseObject = result[0].BaseObject;
                    var msg = "           returned   ([" + baseObject.GetType().FullName + "] " + baseObject.ToString() +
                              ").";
                    WriteLine(write, msg);
                    try
                    {
                        return Convert.ToBoolean(baseObject);
                    }
                    catch( Exception ex )
                    {
                        WriteLine(write, "           failed to return boolean");
                        msg = "Failed to convert ([" + baseObject.GetType().FullName + "] " +
                                  baseObject.ToString() + ") to a boolean. " +
                                  "ServerCertificateValidationCallback script blocks must return a " +
                                  "boolean or a value that is convertable to a boolean.";
                        throw new Exception(msg, ex);
                    }
                };
        }
    }
}
