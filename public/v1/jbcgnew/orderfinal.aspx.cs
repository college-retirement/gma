using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using nsoftware.IPWorks;
using System.Web.Configuration;
using System.IO;

public partial class orderfinal : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
            string emailBody = String.Empty;
        bool isSent = false;
        try
        {
            htmlmailer1 = new nsoftware.IPWorks.Htmlmailer();
            //email client...
            // this is a for-submit need to send the email onwards
            // first take the submit and convert that into an HTML page
            emailBody = "<h1>Waldor Online Web Order</h1><hr>";

            string fromEmail = WebConfigurationManager.AppSettings.Get("order.FromEmail");
            if (fromEmail == null) fromEmail = "abhaumik@real-ware.com";
            emailBody += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\">";
            // iterate through all lines in the order and add them to the cart...
            
            Hashtable cart = new Hashtable();
            string firstSideFile = null;
            string secondSideFile = null;
            if (Session["cart"] != null)
            {
                cart = (Hashtable)Session["cart"];
            }
            foreach (object style in cart.Keys)
            {
                Hashtable lineitem = (Hashtable)cart[style];
                emailBody += "<tr><td valign=\"top\" align=\"center\" colspan=\"2\"><hr/><strong>Style #";
                emailBody += style;
                emailBody += "</strong></hr></td></tr>";
                foreach (string key in lineitem.Keys)
                {
                    if (!key.StartsWith("FILE") && !key.StartsWith("SHIP"))
                    {
                        emailBody += "<tr><td valign=\"top\" align=\"right\"><strong>";
                        emailBody += key.ToUpper();
                        emailBody += ":</strong></td><td valign=\"top\" align=\"left\">";
                        emailBody += lineitem[key].ToString();
                        emailBody += "</td></tr>\n";
                    }
                    else if (key.StartsWith("FILE"))
                    {
                        if (key.Equals("FILE_FirstSideImprintUpload"))
                        {
                            HttpPostedFile pF = (HttpPostedFile)lineitem[key];
                            string dir = WebConfigurationManager.AppSettings.Get("file.upload.tmpDir");
                            FileInfo fI = new FileInfo(pF.FileName);
                            string fileName = dir + "\\"+ System.Guid.NewGuid().ToString()+"_" + fI.Name;
                            FileStream fs = new FileStream(fileName, FileMode.CreateNew);
                            BinaryWriter w = new BinaryWriter(fs);
                            BinaryReader r = new BinaryReader(pF.InputStream);
                            byte[] data = r.ReadBytes(pF.ContentLength);
                            w.Write(data);
                            w.Close();
                            r.Close();
                            firstSideFile = fileName;
                            
                        }
                        else if (key.Equals("FILE_SecondSideImprintUpload"))
                        {
                            HttpPostedFile pF = (HttpPostedFile)lineitem[key];
                            string dir = WebConfigurationManager.AppSettings.Get("file.upload.tmpDir");
                            FileInfo fI = new FileInfo(pF.FileName);
                            string fileName = dir + "\\" + System.Guid.NewGuid().ToString() + "_" + fI.Name;
                            FileStream fs = new FileStream(fileName, FileMode.CreateNew);
                            BinaryWriter w = new BinaryWriter(fs);
                            BinaryReader r = new BinaryReader(pF.InputStream);
                            byte[] data = r.ReadBytes(pF.ContentLength);
                            w.Write(data);
                            w.Close();
                            r.Close();
                            secondSideFile = fileName;

                        } 

                    }
                    else if (key.StartsWith("SHIP"))
                    {
                        // add the shipment list
                        emailBody += "<tr><td valign=\"top\" align=\"right\"><strong>Shipments</strong></td><td><table>";
                        ArrayList shipmentList = new ArrayList();
                        shipmentList = (ArrayList)lineitem["SHIP_ShipmentList"];
                        int ctr = 1;
                        foreach (Hashtable shipment in shipmentList)
                        {
                            emailBody += "<tr><td colspan=\"2\"><hr/><br/><b>Shipment # " + ctr + "</b><br/><hr/></td></tr>";
                            foreach (string sKey in shipment.Keys)
                            {
                                emailBody += "<tr><td valign=\"top\" align=\"right\">" + sKey + "</td><td valign=\"top\" align=\"left\">";
                                emailBody += shipment[sKey].ToString();
                                emailBody += "</td></tr>";
                            }
                        }
                        emailBody += "</table></td></tr>";
                    }
                }
            }
            emailBody += "</table>";
            // fetch the configuration options from the web.config
            string smtpserver = WebConfigurationManager.AppSettings.Get("order.SMTPServer");
            if (smtpserver == null) smtpserver = "localhost";
            htmlmailer1.MailServer = smtpserver;

            string sendTo = null;
            sendTo = WebConfigurationManager.AppSettings.Get("order.SendTo");
            if (sendTo == null) sendTo = "abhaumik@real-ware.com";
            htmlmailer1.SendTo = sendTo;
            htmlmailer1.Subject = "Waldor Online Web Order";
            htmlmailer1.From = fromEmail;
            //if you wanted basic user authentication:
            string smtpUser = WebConfigurationManager.AppSettings.Get("order.SMTPServer.UserName");;
            string smtpPasswd =WebConfigurationManager.AppSettings.Get("order.SMTPServer.Password");;
            if (smtpUser != null) htmlmailer1.User = smtpUser;
            if (smtpPasswd != null) htmlmailer1.Password = smtpPasswd;

            //set the html part of message
            htmlmailer1.MessageHTML = "<html><body>"+emailBody+"</body></html>";
            //add any attachments:
           // htmlmailer1.AttachmentCount = 0;
            //if (firstSideFile != null) htmlmailer1.AddAttachment(firstSideFile);
            //if (secondSideFile != null) htmlmailer1.AddAttachment(secondSideFile);

           string firstfilename=string.Empty;
            string secondfilename=string.Empty;
            //if (firstSideFile != null)
            if(Session["firstfilename"]!="")
            {
                 firstfilename = Session["firstfilename"].ToString();
                 htmlmailer1.AddAttachment((Server.MapPath(@"WalImages\")+firstfilename));
                string ap = htmlmailer1.Attachments.ToString();
        }
        //if (secondSideFile != null)
            if( Session["secondfilename"]!= "")
        {
            secondfilename = Session["secondfilename"].ToString();
            htmlmailer1.AddAttachment((Server.MapPath(@"WalImages\")+secondfilename));
            string bp = htmlmailer1.Attachments.ToString();
        
        }
        Label1.Text = firstfilename + "&" + secondfilename;
        int c = htmlmailer1.AttachmentCount;
            htmlmailer1.Connect();
            htmlmailer1.Send();
            htmlmailer1.Disconnect();
            isSent = true;
        }
        catch (Exception ex)
        {
            this.ErrorLbl.Text = ex.Message;
        }


    }
}
