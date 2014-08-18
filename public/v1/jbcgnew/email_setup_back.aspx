<%@ Page Language="C#" ValidateRequest="false"  %>

<%--<%@ Page Language="C#" Debug="true" %>--%>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>   
<%@ Import Namespace="System.Data.SqlClient" %>   
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Web.UI.WebControls.WebParts" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections" %>
<%--<%@ Import Namespace="TemplateParser" %>
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<script language="C#" runat="server">
    
    //string strCon = ;
    SqlConnection sqlcon = new SqlConnection(ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString());
    DataSet ds_sbody;
    MailMessage msg;
    static int attachment_count = 0;
    static Hashtable attach;
    static Hashtable file_attach;
    static int file_size = 0;
    static Hashtable sizeOfFile;

    public void Page_Load(object sender, EventArgs e)
    {
        //Txtsbody1.Text = " ";
        //string ss2 = "select";
        //DDLselect.Items.Add(ss2);
        
        if (!IsPostBack)
        {
            file_size = 0;
            attach = new Hashtable();
            file_attach = new Hashtable();
            sizeOfFile = new Hashtable();
            
            string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
            SqlConnection sconnect = new SqlConnection(config);
            sconnect.Open();
            string sqlquery = "Select * from email_template where login='" + Session["username"].ToString() + "'";
            SqlCommand scm = new SqlCommand(sqlquery, sconnect);
            SqlDataReader sdread = scm.ExecuteReader();

            if (sdread.HasRows)
            {
                //display data
                sdread.Read();
                int uid = Convert.ToInt32(sdread["userid"]);
                //string str = "select * from email_template";                                         
                //SqlCommand cmd = new SqlCommand(str, sconnect);
                //SqlDataReader dr = cmd.ExecuteReader();

                // while (sdread.Read())
                //{
                //TxtTo.Text = sdread["to_email"].ToString();
                //TxtFrom.Text = sdread["from_email"].ToString();
                //TxtSub.Text = sdread["subject"].ToString();
                //Txtbody.Text = sdread["Body"].ToString();   
                
                                
                
                //}
            }

            FillDDL_Sbody(ddlSbody);
        }
    }

    int blsbody = 0;
    string sbody1 = "";
    string sbody2 = "";
    string sbody3 = "";

    protected void btnsbody1_Click(object sender, EventArgs e)
    {
        //checking from db
        sqlcon.Open();
        SqlCommand cmd = new  SqlCommand("Select sbody1 from email_template where login = " + Session["username"].ToString(), sqlcon);
        SqlDataReader dr = cmd.ExecuteReader();
        dr.Read();
        if (dr.HasRows)
        {
            sbody1 = dr["sbody1"].ToString();
        }
        else
        {
            sbody1 = "Thank you for scheduling your free no-obligation consultation with";
        }
        
        Txtbody.Text = sbody1;
        blsbody = 1;
            

    }

    protected void btnsbody2_Click(object sender, EventArgs e)
    {
        sbody2 = "Use whichever one you can open.  Social Security numbers or other sensitive information can be left blank.";
        Txtbody.Text = sbody2;
        blsbody = 2;
    }

    protected void btnsbody3_Click(object sender, EventArgs e)
    {
        sbody3 = "please contact us at 973-514-2002 at least 48 hours in advance.\nWe look forward to meeting with you! \n\nSincerely,";
        Txtbody.Text = sbody3;
        blsbody = 3;
    }


    protected void btnSendMail_Click(object sender, EventArgs e)
    {
        try
        {
            
            //Get data from db to check whether exist or not.
            //ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString"].ConnectionString.ToString();
            //SqlDataReader dr;
            //SqlCommand("Select userid from email_template where login='" + Session["dbusername"].ToString() + "'");

            if (file_size <= 5000)
            {

                string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
                SqlConnection sconnect = new SqlConnection(config);
                sconnect.Open();
                string sqlquery = "Select userid from email_template where login='" + Session["username"].ToString() + "'";
                SqlCommand scm = new SqlCommand(sqlquery, sconnect);
                SqlDataReader sdread = scm.ExecuteReader();

                if (sdread.HasRows)
                {
                    //get user id of current user
                    sdread.Read();
                    int uid = Convert.ToInt32(sdread["userid"]);
                    sdread.Close();

                    //Update into  db

                    string str = "update email_template set login = '" + Session["username"].ToString() + "',password = '" + Session["password"].ToString() + "',to_email = '" + TxtTo.Text + "',from_email = '" + TxtFrom.Text + "',subject = '" + TxtSub.Text + "',body = '" + Txtbody.Text.Replace("'", "`") + "',attachment = '" + FileUpload1.PostedFile.FileName + "' Where userid=" + uid;
                    //'"+ Convert.ToInt32(txtid.Text)+"')";
                    SqlCommand cmd = new SqlCommand(str, sconnect);
                    cmd.ExecuteNonQuery();

                }
                else
                {
                    //insert into db
                    sdread.Close();
                    string str = "insert into email_template(login,password,to_email,from_email,subject,body,attachment) values('" + Session["username"].ToString() + "','" + Session["password"].ToString() + "','" + TxtTo.Text + "','" + TxtFrom.Text + "','" + TxtSub.Text + "','" + Txtbody.Text.Replace("'", "`") + "','" + FileUpload1.PostedFile.FileName + "')";
                    SqlCommand cmd = new SqlCommand(str, sconnect);
                    cmd.ExecuteNonQuery();

                }

                string Appoint_To = " ";
                string U_name = "";
                string dt = DateTime.Now.Date.ToShortDateString();
                string login = "";
                string pwd = "";

                string str1 = "Select * from madison_sysdba.Users where emailaddress = '" + TxtTo.Text.Trim() + "'";
                SqlCommand cmd1 = new SqlCommand(str1, sconnect);
                SqlDataReader dr_user = cmd1.ExecuteReader();
                if (dr_user.HasRows)
                {
                    dr_user.Read();
                    Appoint_To = dr_user["Name"].ToString();
                    U_name = Appoint_To;
                    login = dr_user["username"].ToString();
                    pwd = dr_user["password"].ToString();

                }


                //Hashtable templateVars = new Hashtable();
                ////templateVars.Add("FirstName", "Alexander");
                ////templateVars.Add("LastName", "Kleshchevnikov");
                //templateVars.Add("Login", Session["username"].ToString());
                //templateVars.Add("Password", Session["password"].ToString());
                //templateVars.Add("Appointent", Appoint_To);


                //Parser parser = new Parser(Server.MapPath("Registration.htm"), templateVars);


                MailAddress To_addr = new MailAddress(TxtTo.Text);
                MailAddress From_addr = new MailAddress(TxtFrom.Text);

                msg = new MailMessage(From_addr, To_addr);
                msg.Subject = TxtSub.Text;
                msg.CC.Add("shubhangi@aspirtek.com");
                //msg.Body = Txtbody.Text;
                msg.BodyEncoding = System.Text.Encoding.UTF8;
                //msg.Body = "<br />Login : " + Session["username"].ToString() + "<br /> Password : " + Session["password"].ToString() + "<br /> " + Txtbody.Text;

                //msg.Body = Txtbody.Text +parser.Parse();

                string htmlstart = "<html><body>";
                string htmlend = "</body></html>";

                string str_body = htmlstart + Txtbody.Text + htmlend;

                if (str_body.Contains("##FirstName##"))
                {
                    str_body = str_body.Replace("##FirstName##", U_name);
                }
                if (str_body.Contains("##Login##"))
                {
                    str_body = str_body.Replace("##Login##", login);
                }
                if (str_body.Contains("##Password##"))
                {
                    str_body = str_body.Replace("##Password##", pwd);
                }
                if (str_body.Contains("##Date##"))
                {
                    str_body = str_body.Replace("##Date##", dt);
                }

                //int s1 = str_body.IndexOf("#", 0);
                //int s2 = str_body.IndexOf("##", s1 + 2);


                msg.Body = str_body;
                //msg.Body = htmlstart + Txtbody.Text + htmlend ;

                //string should be parsed



                //if (blsbody == 1)
                //{
                //    // update into sbody1 and body
                //    msg.Body = sbody1 + parser.Parse();


                //}
                //else if (blsbody == 2)
                //{
                //    // update into sbody2 and body
                //    msg.Body = sbody2 + parser.Parse();
                //}
                //else if (blsbody == 3)
                //{
                //    // update into sbody3 and body
                //    msg.Body = sbody3 + parser.Parse();
                //}

                msg.IsBodyHtml = true;


                //Attachment Procedure

                //if (FileUpload2.HasFile)
                //{
                //    FileUpload2.SaveAs(Server.MapPath("uploads/") + FileUpload2.FileName);
                //    msg.Attachments.Add(new Attachment(Server.MapPath("uploads/") + FileUpload2.FileName));
                //}
                //if (FileUpload3.HasFile)
                //{
                //    FileUpload3.SaveAs(Server.MapPath("uploads/") + FileUpload3.FileName);
                //    msg.Attachments.Add(new Attachment(Server.MapPath("uploads/") + FileUpload3.FileName));
                //}
                //if (FileUpload4.HasFile)
                //{
                //    FileUpload1.SaveAs(Server.MapPath("uploads/") + FileUpload4.FileName);
                //    msg.Attachments.Add(new Attachment(Server.MapPath("uploads/") + FileUpload4.FileName));
                //}
                //if (FileUpload5.HasFile)
                //{
                //    FileUpload1.SaveAs(Server.MapPath("uploads/") + FileUpload5.FileName);
                //    msg.Attachments.Add(new Attachment(Server.MapPath("uploads/") + FileUpload5.FileName));
                //}

                //get File names from attach[] and save them on web server one by one.
                for (int j = 0; j < attach.Count; j++)
                {
                    FileUpload file1 = new FileUpload();
                    file1.SaveAs(Server.MapPath("./uploads/") + file_attach[j].ToString());
                    msg.Attachments.Add((Attachment)attach[j]);

                }


                SmtpClient smtp_mail = new SmtpClient();
                smtp_mail.Send(msg);
                lbl_Email_msg.Text = "Your mail has been sent successfully";
            }
            else
            {   
                lbl_Email_msg.Text = "Your Total file size can not increase more than 5 MB. ";
            }
            
        }
            catch(Exception ex)
             {
                 lbl_Email_msg.Text = "Could not send email: " + ex.Message.ToString();
             }      
    }

    protected void btnSendFile_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {
            //keep the track of file size while uploading.
            //FileUpload1.SaveAs(Server.MapPath("uploads/") + FileUpload1.FileName);
            file_size = file_size + FileUpload1.PostedFile.ContentLength;
            TxtTotalSize.Text = (float)(file_size/1000.00) + " MB";
            
            if (file_size > 5000)
            { 
                //give message
                lbl_Email_msg.Text = "Your Total file size can not increase more than 5 MB. ";
            }
            else
            {

                sizeOfFile.Add(attachment_count, FileUpload1.PostedFile.ContentLength);
                attach.Add(attachment_count, new Attachment(FileUpload1.PostedFile.FileName));

                file_attach.Add(attachment_count, FileUpload1.FileName);
                //txtFileShow.Text += FileUpload1.FileName + "\n";
                ListBox1.Items.Add(new ListItem(FileUpload1.FileName + "   (" + FileUpload1.PostedFile.ContentLength/1000.00 + " MB)" , attachment_count.ToString()));
                attachment_count += 1;
            }
            //FileUpload1.te
            
        }

    }
    
    protected void lnkMail_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = true;
        pnlAdd.Visible = false;
        pnledit.Visible = false;
        pnldel.Visible = false;

        FillDDL_Sbody(ddlSbody);
        
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        //adding to the db.
        
        try
        {
            string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
            SqlConnection sconnect = new SqlConnection(config);
            sconnect.Open();
            string strsbody = lbl_msg.Text + txtid.Text;
            //checking for the same sbodynum into the db.
            SqlCommand com = new SqlCommand("Select sbodynum from Sbody where sbodynum='" + strsbody + "'",sconnect);
            SqlDataReader dr = com.ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                lblsbody.Text = dr["sbodynum"].ToString() + "  " +lblsbody.Text;
                lblsbody.Visible = true;
                dr.Close();
            }
            else
            {
                lblsbody.Visible = false;
                string sbodytext = "<html><body>" + txtsbody.Text + "</body></html>";
                dr.Close();
                
                SqlCommand cmd = new SqlCommand("Insert into Sbody(sbodynum,sbodytext) values('" + strsbody + "','" + sbodytext.Replace("'", "`") + "')", sconnect);
                cmd.ExecuteNonQuery();
                Lbl_add.Text = "Body of your email template has been saved successfully";
            }
        }
        catch(Exception ex)
        {
          
        }
        finally
        {
            //sconnect.Close();
        }
        
    }

    protected void BtnEdit_Click(object sender, EventArgs e)
    {
        //Updating to the db.

        try
        {
            sqlcon.Open();
            string strsbody = DDLedit.SelectedValue.ToString();
            string ss3;
            ss3= "update Sbody set sbodytext= '" + Txtsbody1.Text.Replace("'","`") + "' where sbodynum='" + DDLedit.SelectedItem.Text + "'";
            SqlCommand cmd = new SqlCommand(ss3, sqlcon);
            cmd.ExecuteNonQuery();
            Lbl_edit.Text = "Body of your email template has been edited successfully";
            
        }
        catch (Exception ex)
        {
          
        }
        finally
        {
         //   sconnect.Close();
        }
        
    }

    
    //protected void DDLselect1_SelectedIndexChanged (object sender, EventArgs e)
    //{
            
    //        sqlcon.Open();
    //        string strsbody = DDLselect1.SelectedValue.ToString();
    //        string ss = "select sbodytext from dbo.Sbody where sbodynum='" + strsbody + "'";
    //        SqlDataReader sdr;
    //        SqlCommand cmd1 = new SqlCommand(ss, sqlcon);
    //        sdr = cmd1.ExecuteReader();
    //        while (sdr.Read())
    //        {
    //            string temp = sdr["sbodytext"].ToString();
    //            temp = temp.Replace("`","'");
    //            Txtsbody1.Text = temp;
    //        }
    //        sqlcon.Close();
        
    //}

    //protected void DDLselect_SelectedIndexChanged(object sender, EventArgs e)
    //{

    //    sqlcon.Open();
    //    string strsbody = DDLselect.SelectedValue.ToString();
    //    string ss = "select sbodytext from dbo.Sbody where sbodynum='" + strsbody + "'";
    //    SqlDataReader sdr;
    //    SqlCommand cmd1 = new SqlCommand(ss, sqlcon);
    //    sdr = cmd1.ExecuteReader();
    //    while (sdr.Read())
    //    {
    //        Txtsbody1.Text = sdr["sbodytext"].ToString();
    //    }
    //    sqlcon.Close();

    //}

   protected void Btndelete_Click(object sender, EventArgs e)
    {
        try
        {
            sqlcon.Open();
            int strsbody = Convert.ToInt32(DDLdelete.SelectedValue);
            //string strsbody = DDLselect.SelectedItem.Value.ToString();
            
            string ss4 = "delete Sbody where sbodyid='" + strsbody+"'";
            SqlCommand cmd3 = new SqlCommand(ss4, sqlcon);
            cmd3.ExecuteNonQuery();
            FillDDL_Sbody(DDLdelete);
            Lbl_del.Text = "Body of your email template has been deleted successfully";

        }
        catch (Exception ex)
        {

        }
        finally
        {
            //sconnect.Close();
        }
    }

    protected void lnkAdd_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = true;
        pnledit.Visible = false;
        pnldel.Visible = false; 

    }

    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = false;
        pnledit.Visible = true;
        pnldel.Visible = false;

        FillDDL_Sbody(DDLedit);

       
    }

    private void FillDDL_Sbody(DropDownList ddltemp)
    {
        string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
        SqlConnection sconnect = new SqlConnection(config);
        
        ds_sbody = new DataSet();
        SqlDataAdapter dad = new SqlDataAdapter("select * from Sbody ", sconnect);
        dad.Fill(ds_sbody);
        ddltemp.DataTextField = "sbodynum";
        ddltemp.DataValueField = "sbodyid";
        ddltemp.DataSource = ds_sbody.Tables[0];
        ddltemp.DataBind();
        ddltemp.Items.Insert(0, "Select Sbody");
    }
    
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = false;
        pnledit.Visible = false;
        pnldel.Visible = true;

        FillDDL_Sbody(DDLdelete);
    }

    protected void ddlSbody_SelectedIndexChanged(object sender, EventArgs e)
    {
        sqlcon.Open();
        string strsbody = ddlSbody.SelectedItem.Text.Trim();
        string ss = "select sbodytext from dbo.Sbody where sbodynum='" + strsbody + "'";
        SqlDataReader sdr;
        SqlCommand cmd1 = new SqlCommand(ss, sqlcon);
        sdr = cmd1.ExecuteReader();
        while (sdr.Read())
        {
            Txtbody.Text = sdr["sbodytext"].ToString();
        }
        sqlcon.Close();
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {

    }

    protected void DDLedit_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            sqlcon.Open();
            string strsbody = DDLedit.SelectedValue.ToString();
            if (strsbody != "Select Sbody")
            {
                string ss = "select sbodytext from dbo.Sbody where sbodyid=" + strsbody;
                SqlDataReader sdr;
                SqlCommand cmd1 = new SqlCommand(ss, sqlcon);
                sdr = cmd1.ExecuteReader();
                while (sdr.Read())
                {
                    Txtsbody1.Text = sdr["sbodytext"].ToString();
                }
            }
            sqlcon.Close();
        }
        catch (Exception ex)
        { }
        
    }

    protected void DDLdelete_SelectedIndexChanged(object sender, EventArgs e)
    {
        //sqlcon.Open();
        //string strsbody = DDLdelete.SelectedValue.ToString();
        //string ss = "select sbodytext from dbo.Sbody where sbodyid=" + strsbody;
        //SqlDataReader sdr;
        //SqlCommand cmd1 = new SqlCommand(ss, sqlcon);
        //sdr = cmd1.ExecuteReader();
        //while (sdr.Read())
        //{
        //    Txtsbody1.Text = sdr["sbodytext"].ToString();
        //}
        //sqlcon.Close();
    }

   
    protected void btnRemoveFile_Click(object sender, EventArgs e)
    {
        int pos = ListBox1.SelectedIndex;
        file_size = file_size - Convert.ToInt32( sizeOfFile[pos]);
        ListBox1.Items.RemoveAt(pos);
        attach.Remove(pos);
        file_attach.Remove(pos);
        sizeOfFile.Remove(pos);
        TxtTotalSize.Text = (float)(file_size/1000.00) + " MB";
    }
</script>
	
<head runat="server">
    <title>Email Setup</title>
</head>
<body>
<!-- #include file="./images/admin_menu/nav.aspx" -->  
    <form id="form1" runat="server">
    <div style="text-align:center;">
        
        <div>
            <asp:LinkButton ID="lnkMail" CausesValidation="False" Text="Send an E-mail" runat="server" OnClick="lnkMail_Click" PostBackUrl="~/jbcg/email_setup.aspx"></asp:LinkButton>
            <asp:LinkButton ID="lnkAdd" CausesValidation="False" Text="Add a Template" runat="server" OnClick="lnkAdd_Click" PostBackUrl="~/jbcg/email_setup.aspx" ></asp:LinkButton>
            <asp:LinkButton ID="lnkEdit" CausesValidation="False" Text="Edit a Template" runat="server" OnClick="lnkEdit_Click" PostBackUrl="~/jbcg/email_setup.aspx"></asp:LinkButton>
            <asp:LinkButton ID="lnkDelete" Text="Delete a Template" CausesValidation="False" runat="server" OnClick="lnkDelete_Click" PostBackUrl="~/jbcg/email_setup.aspx"></asp:LinkButton>
            
        </div>
        <br />
        <br />
        <asp:Panel ID="pnlEmail" runat="server" Height="50px" Style="position: static" Width="500px">
        
            <asp:Label ID="Label1" runat="server" Height="30px" Style="text-align:center;" Text="             Email Template"
            Width="344px" Font-Bold="True" Font-Size="Large"></asp:Label>
            <table>
            <tr>
            <td style="width: 200px;text-align:right;">
            <asp:Label ID="Label2" runat="server" Height="25px" Style="text-align:right;" Text="To : "
            Width="69px"></asp:Label>
            
            </td>
            <td style="text-align:left; width: 364px;">
            <asp:TextBox ID="TxtTo" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvTxtTo" runat="server" ControlToValidate="TxtTo" ErrorMessage="Required."></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revTo" runat="server" ControlToValidate="TxtTo"
                    Style="position: static" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Enter Email Address.</asp:RegularExpressionValidator></td>
        </tr>
        <tr>
               <td style="width: 200px;text-align:right;">
                    <asp:Label ID="Label3" runat="server" Height="19px" Style="text-align:right;" Text="From : "
                    Width="66px"></asp:Label>
               </td>
               <td style="text-align:left; width: 364px;">
                    <asp:TextBox ID="TxtFrom" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvTxtFrom" ControlToValidate="TxtFrom" runat="server" ErrorMessage="Required."></asp:RequiredFieldValidator>
                   <asp:RegularExpressionValidator ID="revFrom" runat="server" ControlToValidate="TxtFrom"
                       Style="position: static" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Enter Email Address.</asp:RegularExpressionValidator></td>
        </tr>
        <tr>
             <td style="width: 200px;text-align:right;">
                    <asp:Label ID="Label4" runat="server" Height="13px" Style="text-align:right;" Text="Subject : "
                     Width="64px"></asp:Label>
             </td>
             <td style="width: 364px;text-align:left;">
                    <asp:TextBox ID="TxtSub" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox></td>       
        </tr>
        <tr>
             <td style="width: 200px; height: 24px;text-align:right;">
                <asp:Label ID="Label7" runat="server" Height="13px" Style="text-align:right;" Text="Select Sbody : "
                 Width="90px"></asp:Label>
             </td>
             <td style="text-align:left; width: 364px; height: 24px;">
                <asp:DropDownList ID="ddlSbody" runat="Server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlSbody_SelectedIndexChanged" >
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvddlSbody" ControlToValidate="ddlSbody" InitialValue="Select Sbody" runat="server" ErrorMessage="Required."></asp:RequiredFieldValidator>
             </td> 
                        
        </tr>
        
        <tr>
               <td style="width: 200px;vertical-align:top;text-align:right;">
               <asp:Label ID="Label5" runat="server" Height="23px" Style="text-align:right;" Text="Body : "
               Width="65px"></asp:Label>
               </td>
               <td style="width: 364px;vertical-align:top;text-align:left;">
               <asp:TextBox ID="Txtbody" runat="server" Style="text-align:left;" TextMode="MultiLine" Height="120px" Width="272px"></asp:TextBox></td>
        </tr>
       <%-- <tr>
            <td style="text-align:right;vertical-align:top;">
                <asp:LinkButton ID="lnkAttachment" runat="server" Text="Attach files here" OnClick="lnkAttachment_Click"></asp:LinkButton>
            </td>
            <td style="text-align:left;">
                <asp:TextBox ID="txtAttachments" runat="server" Text="" ReadOnly="true" TextMode="MultiLine" Width="272px"></asp:TextBox>
            </td>
                
        </tr>--%>
        <tr>
               <td style="width: 200px; height: 24px;text-align:right;">
                   <asp:Label ID="Label6" runat="server" Height="23px" Style="text-align:right;" Text="Attachments : " Width="90px"></asp:Label>
                   &nbsp;</td>
               <td style="height: 24px; width: 364px;text-align:left;">
                      <asp:FileUpload ID="FileUpload1" runat="server" Style="text-align:left;" />
                   <asp:Button ID="btnSendFile" runat="server" Style="position: static" Text="Add File" OnClick="btnSendFile_Click" Height="20px" /></td>         
        </tr>
        <%--<tr>
            <td></td>
            <td style="text-align:left; width: 348px;">  
                <asp:FileUpload ID="FileUpload2" runat="server" Style="text-align:left;" />
            </td>
        </tr>
          <tr>
            <td></td>
            <td style="text-align:left; width: 348px;">  
                <asp:FileUpload ID="FileUpload3" runat="server" Style="text-align:left;" />
            </td>
        </tr>
          <tr>
            <td></td>
            <td style="text-align:left; width: 348px;">  
                <asp:FileUpload ID="FileUpload4" runat="server" Style="text-align:left;" />
            </td>
        </tr>
          <tr>
            <td></td>
            <td style="text-align:left; width: 348px;">  
                <asp:FileUpload ID="FileUpload5" runat="server" Style="text-align:left;" />
            </td>
        </tr>--%>
        <tr>
            <td></td>
            <td style="text-align:left; width: 364px;">
                <asp:ListBox ID="ListBox1" runat="server" Style="position: static" Width="216px" Height="120px"></asp:ListBox><asp:Button ID="btnRemoveFile" runat="server" OnClick="btnRemoveFile_Click" Style="position: static"
                    Text="Remove File" Height="20px" Width="80px" /><br />
                Total File size : 
                <asp:TextBox ID="TxtTotalSize" runat="server" Style="position: static" Width="80px" ReadOnly="True"></asp:TextBox>
                </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnSendMail" runat="server" Style="text-align:center; position: static;" Text="Send Mail" Height="24px" Width="72px" OnClick="btnSendMail_Click" />
            <%--<asp:Button ID="Button3" runat="server" Style="text-align:center; position: static;" Text="Preview" Height="32px" Width="72px" OnClick="btnPreview_Click" Visible="False" />--%>
            </td>
        </tr>
        
     </table>
            
             <br />
       
       <div style="color:red;">
       <asp:Label ID="LblSbodyError" runat="server" Visible="false" Style="text-align:right; position: static;"></asp:Label>
       <asp:Label ID="lbl_Email_msg"  runat="Server" ></asp:Label>
       </div>      
        </asp:Panel>
        <br />
        
        <asp:Panel ID="pnlAdd" Visible="false" runat="Server" Width="600px" >
            
            <table >
                <tr style="text-align:left;width:400px;">
                    <td style="text-align:right;"><asp:Label ID="Label8" runat="Server" Text="Enter Sbody Name :"></asp:Label>
                    </td>
                    <td ><asp:Label ID="lbl_msg" runat="Server" Text="BodyText" Width="40px"></asp:Label>
                    <asp:TextBox ID="txtid" runat="server" Width="152px" Text="" style="position: static"></asp:TextBox>&nbsp;
                    </td>
                    
                </tr>
                
            <tr> <td colspan="2"></td>  </tr> 
           
            <tr style="text-align:left;width:400px;">
                <td style="vertical-align:top;text-align:right;"><asp:Label ID="Label9" runat="Server" Text="Enter Body Text :"></asp:Label>
                </td>
                <td colspan="1">
                <asp:TextBox ID="txtsbody" runat="server" Width="250px" Text="" TextMode="MultiLine" Height="184px"></asp:TextBox>
                
                
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblsbody" Visible="false" runat="Server" Text="Sbody Name already exist !" ForeColor="Red"></asp:Label>
                </td>
            </tr>
             <tr> <td colspan="2"></td>  </tr> 
            <tr style="text-align:center;width:400px;">
                <td colspan="3"><asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" />
                </td>
            </tr>

            </table>
            <br />
            <br />
            <asp:Label ID="Lbl_add" runat="server" Style="position: static" Width="232px"></asp:Label></asp:Panel>
        
        
        
        <asp:Panel ID="pnledit" Visible="false" runat="Server" Width="600px" >
            
            <table >
                <tr style="text-align:left;width:400px;">
                    <td style="text-align:right;">
                    <asp:Label ID="Label10" runat="Server" Text="Select Sbody Name :"></asp:Label>
                    </td>
                    <td >
                        <asp:DropDownList ID="DDLedit" runat="server" Width="128px" OnSelectedIndexChanged="DDLedit_SelectedIndexChanged" AutoPostBack="True" >
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDDLedit" ControlToValidate="DDLedit" runat="server" ErrorMessage="Select one of the Sbodies to Edit" InitialValue="Select Sbody"></asp:RequiredFieldValidator>    
                    </td>
                    
                </tr>
                 
            <tr> <td colspan="2"></td>  </tr> 
           
            <tr style="text-align:left;width:400px;">
                <td style="vertical-align:top;text-align:right; height: 159px;"><asp:Label ID="Label12" runat="Server" Text="Enter Body Text :"></asp:Label>
                </td>
                <td colspan="1" style="height: 159px"><asp:TextBox ID="Txtsbody1" runat="server" Width="250px" Text="" TextMode="MultiLine" Height="152px" CausesValidation="True"></asp:TextBox>&nbsp;
                </td>
            </tr>
             <tr> <td colspan="2"></td>  </tr> 
            <tr style="text-align:center;width:400px;">
                <td colspan="3"><asp:Button ID="BtnEdit" runat="server" Text="Edit" OnClick="BtnEdit_Click" />
                </td>
            </tr>

            </table>
            <br />
            <br />
            <asp:Label ID="Lbl_edit" runat="server" Style="position: static" Width="328px"></asp:Label></asp:Panel>
        
        <asp:Panel ID="pnldel" Visible="False" runat="Server" Width="600px" >
            
            <table >
                <tr style="text-align:left;width:400px;">
                    <td style="text-align:right;">
                    <asp:Label ID="Label11" runat="Server" Text="Select Sbody Name :"></asp:Label>
                    </td>
                    <td >
                        <asp:DropDownList ID="DDLdelete" runat="server" Width="128px" OnSelectedIndexChanged="DDLdelete_SelectedIndexChanged" AutoPostBack="True" >
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDDLdelete" ControlToValidate="DDLdelete" runat="server" ErrorMessage="Select one of the Sbodies to Delete" InitialValue="Select Sbody"></asp:RequiredFieldValidator>  
                    </td>
                    
                </tr>
                </table>
            <asp:Button ID="Btndelete" runat="server" OnClick="Btndelete_Click" Style="position: static"
                Text="Delete" />
            <br />
            <br />
            <br />
            <asp:Label ID="Lbl_del" runat="server" Style="position: static" Width="264px"></asp:Label></asp:Panel>
        
                
        
   </div> 
   
    </form>
    </body>
    
</html>
