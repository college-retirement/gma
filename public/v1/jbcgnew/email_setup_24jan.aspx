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
<%@ Import Namespace="System.IO" %>
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
    static Hashtable attach;  //file attachment object
    static Hashtable file_attach; // file name object
    static long file_size = 0;
    static Hashtable sizeOfFile;
    static int sbodyNum_send = 0;

    static DataTable dt_student;

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

            dt_student = new DataTable();
            FillStudentGrid();
            
            FillDDL_Sbody(ddlSbody);
        }
    }
    
    protected void btnSendMail_Click(object sender, EventArgs e)
    {
        ////this is sending mail..................   avinash!!!....
        //try
        //{
        //    string sqlquery = "update madison_sysdba.users set  madison_sysdba.users.name ='" + TextBox2.Text + "' where userid=(select userid from madison_sysdba.appointments where madison_sysdba.appointments.id=" + apptid + ")";
        //    SqlCommand scmd = new SqlCommand(sqlquery, sqlconnect);
        //    scmd.ExecuteNonQuery();

        //}
        try
        {
            
            //Get data from db to check whether exist or not.
            //ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString"].ConnectionString.ToString();
            //SqlDataReader dr;
            //SqlCommand("Select userid from email_template where login='" + Session["dbusername"].ToString() + "'");

            if (file_size <= 5242880)
            {

                string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
                SqlConnection sconnect = new SqlConnection(config);
                sconnect.Open();
                

                ///////////commented///////////
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

                MailAddress To_addr = new MailAddress(TxtTo.Text);
                MailAddress From_addr = new MailAddress(TxtFrom.Text);

                msg = new MailMessage(From_addr, To_addr);
                msg.Subject = TxtSub.Text;
                //msg.CC.Add("meghna@aspirtek.com");
                //msg.BodyEncoding = System.Text.Encoding.UTF8;


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

                msg.Body = str_body;
                msg.IsBodyHtml = true;
                


                //get File names from attach and save them on web server one by one.
                for (int j = 0; j < attach.Count; j++)
                {
 		    FileUpload file1 = new FileUpload();
                    file1.SaveAs(Server.MapPath("./uploads/") + file_attach[j].ToString());
                    msg.Attachments.Add((Attachment)attach[j]);
                }

                SmtpClient smtp_mail = new SmtpClient();
		smtp_mail.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                smtp_mail.Host = "localhost";
                smtp_mail.Send(msg);
                lbl_Email_msg.Text = "Your mail has been sent successfully";
                
            }
            //else
            //{   
            //    lbl_Email_msg.Text = "Your Total file size can not increase more than 5 MB. ";
            //}
            
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
            FileUpload1.SaveAs(Server.MapPath("uploads/" + FileUpload1.FileName));
            
            file_size = file_size + FileUpload1.PostedFile.ContentLength;
            //TxtTotalSize.Text = (float)(file_size / (1024.00)) + " KB";

            decimal di = (decimal)(file_size / (1024.00)) ;
            TxtTotalSize.Text = Decimal.Round(di, 2).ToString() + " KB";
            
            if (file_size > 5242880)
            {
                //give message n subtract newly LAST added file_size from total file_size.
                file_size = file_size - FileUpload1.PostedFile.ContentLength;
                //TxtTotalSize.Text = (float)(file_size / (1024.00)) + " KB";

                decimal di1 = (decimal)(file_size / (1024.00));
                TxtTotalSize.Text = Decimal.Round(di1, 2).ToString() + " KB";
                
                lbl_Email_msg.Text = "Your Total file size can not increase more than 5 MB. ";
            }
            else
            {

                sizeOfFile.Add(attachment_count, FileUpload1.PostedFile.ContentLength);
                //attach.Add(attachment_count, new Attachment(FileUpload1.PostedFile.FileName));
                attach.Add(attachment_count, new Attachment(Server.MapPath("uploads/") + FileUpload1.FileName));

                file_attach.Add(attachment_count, FileUpload1.FileName);
                //txtFileShow.Text += FileUpload1.FileName + "\n";

                decimal di2 = (decimal)(FileUpload1.PostedFile.ContentLength / (1024.00));
                ListBox1.Items.Add(new ListItem(FileUpload1.FileName + "   (" + Decimal.Round(di2, 2).ToString() + " KB)", attachment_count.ToString()));
                attachment_count += 1;
            }
            //Response.Write(FileUpload1.PostedFile.ContentLength);
            //FileUpload1.te
            
        }

    }

    protected void btnRemoveFile_Click(object sender, EventArgs e)
    {
        try
        {
            //Deleting file from WEbserver
            int pos = ListBox1.SelectedIndex;
            File.Delete(Server.MapPath("uploads/" + file_attach[pos].ToString()));

            file_size = file_size - Convert.ToInt32(sizeOfFile[pos]);
            ListBox1.Items.RemoveAt(pos);
            //attach.Remove(pos);
            file_attach.Remove(pos);
            sizeOfFile.Remove(pos);

            decimal di = (decimal)(file_size / (1024.00));
            TxtTotalSize.Text = Decimal.Round(di, 2).ToString() + " KB";
            
        }
        catch (Exception ex)
        { }
    }
    
    protected void lnkMail_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = true;
        pnlAdd.Visible = false;
        pnledit.Visible = false;
        pnldel.Visible = false;
        pnlExport.Visible = false;

        FillDDL_Sbody(ddlSbody);
        
        //keep the Sbody Dropdown as it was for the first time for the user when he/she has entered the text
	if (!IsPostBack)
        {
              ddlSbody.SelectedIndex = sbodyNum_send;
        }
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
        pnlExport.Visible = false;

    }

    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = false;
        pnledit.Visible = true;
        pnldel.Visible = false;
        pnlExport.Visible = false;

        FillDDL_Sbody(DDLedit);

       
    }

    private void FillDDL_Sbody(DropDownList ddltemp)
    {
        string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
        SqlConnection sconnect = new SqlConnection(config);

        try
        {

            ds_sbody = new DataSet();
            SqlDataAdapter dad = new SqlDataAdapter("select * from Sbody ", sconnect);
            dad.Fill(ds_sbody);
            ddltemp.DataTextField = "sbodynum";
            ddltemp.DataValueField = "sbodyid";
            ddltemp.DataSource = ds_sbody.Tables[0];
            ddltemp.DataBind();
            ddltemp.Items.Insert(0, "Select Sbody");
        }
        catch (Exception ex)
        {
        }
    }
    
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = false;
        pnledit.Visible = false;
        pnldel.Visible = true;
        pnlExport.Visible = false;

        FillDDL_Sbody(DDLdelete);
    }

    protected void ddlSbody_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            sbodyNum_send = ddlSbody.SelectedIndex;
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
        catch (Exception ex)
        { }
        
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



    protected void lnkExport_Click(object sender, EventArgs e)
    {
        pnlEmail.Visible = false;
        pnlAdd.Visible = false;
        pnledit.Visible = false;
        pnldel.Visible = false;
        pnlExport.Visible = true;
        
    }


    private void FillStudentGrid()
    {
        try
        {
            //dt_student = new DataTable();
            string str_stud = "SELECT d.col0002 AS 'FirstName', d.col0004 AS 'LastName', e.col0018 AS 'Email', d.col0020 AS 'yearOfGrad', col0089 AS 'StudId' FROM madison_sysdba.mfac_client_data2 as d left join madison_sysdba.mfac_parent_info as e ON e.claimid=d.id where e.col0018 is not null and e.id =1";
            //SELECT col0002 AS 'FirstName', col0004 AS 'LastName', col0014 AS 'Email', col0020 AS 'yearOfGrad', col0089 AS 'StudId' FROM madison_sysdba.mfac_client_data2";
            SqlDataAdapter da_stud = new SqlDataAdapter(str_stud, sqlcon);
            da_stud.Fill(dt_student);
            gvStudent.DataSource = dt_student;
            gvStudent.DataBind();
        }
        catch (Exception ex)
        {
        }
    }

    private void CreateCSVFile(DataTable dt, string str_path)
    {
        try
        {
            StreamWriter sw = new StreamWriter(str_path, false);

            int colCount = dt.Columns.Count;
            for (int i = 0; i < colCount; i++)
            {

                sw.Write(dt.Columns[i]);
                if (i < colCount - 1)
                {
                    sw.Write(",");

                }

            }

            sw.Write(sw.NewLine);
            // Now write all the rows.

            foreach (DataRow dr in dt.Rows)
            {

                for (int i = 0; i < colCount; i++)
                {

                    if (!Convert.IsDBNull(dr[i]))
                    {

                        sw.Write(dr[i].ToString());
                    }

                    if (i < colCount - 1)
                    {

                        sw.Write(",");
                    }

                }
                sw.Write(sw.NewLine);

            }
            sw.Close();

            export_tocsv.Visible = true;

        }
        catch (Exception ex)
        {
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        CreateCSVFile(dt_student, Server.MapPath("./uploads/") + "tempCSV.csv");
    }


    protected void gvStudent_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvStudent.PageIndex = e.NewPageIndex;
        gvStudent.DataSource = dt_student;
        gvStudent.DataBind();
    }

    protected void Button1_Click1(object sender, EventArgs e)
    {
        if (FileUpload2.HasFile)
        {
            //keep the track of file size while uploading.
            FileUpload2.SaveAs(Server.MapPath("uploads/" + FileUpload2.FileName));

            file_size = file_size + FileUpload2.PostedFile.ContentLength;
            //TxtTotalSize.Text = (float)(file_size / (1024.00)) + " KB";

            decimal di = (decimal)(file_size / (1024.00));
           TextBox1.Text = Decimal.Round(di, 2).ToString() + " KB";

            if (file_size > 5242880)
            {
                //give message n subtract newly LAST added file_size from total file_size.
                file_size = file_size - FileUpload2.PostedFile.ContentLength;
                //TxtTotalSize.Text = (float)(file_size / (1024.00)) + " KB";

                decimal di1 = (decimal)(file_size / (1024.00));
                TextBox1.Text = Decimal.Round(di1, 2).ToString() + " KB";

                lbl_Email_msg.Text = "Your Total file size can not increase more than 5 MB. ";
            }
            else
            {
		sizeOfFile.Add(attachment_count, FileUpload1.PostedFile.ContentLength);
                // CreateCSVFile(dt_student, Server.MapPath("./uploads/") + "tempCSV.csv");
                //attach.Add(attachment_count, new Attachment(FileUpload1.PostedFile.FileName));//commented by me
                attach.Add(attachment_count, Server.MapPath("./uploads/") + (FileUpload1.PostedFile.FileName));
                
                file_attach.Add(attachment_count, FileUpload1.FileName);
                //txtFileShow.Text += FileUpload1.FileName + "\n";


                //sizeOfFile.Add(attachment_count, FileUpload2.PostedFile.ContentLength);
                //attach.Add(attachment_count, new Attachment(FileUpload2.PostedFile.FileName));

                //file_attach.Add(attachment_count, FileUpload2.FileName);
                //txtFileShow.Text += FileUpload1.FileName + "\n";

                decimal di2 = (decimal)(FileUpload2.PostedFile.ContentLength / (1024.00));
                ListBox2.Items.Add(new ListItem(FileUpload2.FileName + "   (" + Decimal.Round(di2, 2).ToString() + " KB)", attachment_count.ToString()));
                attachment_count += 1;
            }
            //Response.Write(FileUpload2.PostedFile.ContentLength);
            //FileUpload2.te

        }

    }

    protected void Button2_Click(object sender, EventArgs e)
     {
         try
         {
             //Deleting file from WEbserver
             int pos = ListBox2.SelectedIndex;
             File.Delete(Server.MapPath("uploads/" + file_attach[pos].ToString()));

             file_size = file_size - Convert.ToInt32(sizeOfFile[pos]);
             ListBox2.Items.RemoveAt(pos);
             //attach.Remove(pos);
             file_attach.Remove(pos);
             sizeOfFile.Remove(pos);

             decimal di = (decimal)(file_size / (1024.00));
             TextBox1.Text = Decimal.Round(di, 2).ToString() + " KB";

         }
         catch (Exception ex)
         { }
         
     }
    
 
</script>
	
<head id="Head1" runat="server">
    <title>Email Setup</title>
</head>
<body>
<!-- #include file="./images/admin_menu/nav.aspx" -->  
    <form id="form1" runat="server">
    <div style="text-align:center;">
        
        <div>
            <asp:LinkButton ID="lnkMail" CausesValidation="False" Text="Send an E-mail" runat="server" OnClick="lnkMail_Click" PostBackUrl="~/jbcgnew/email_setup.aspx"></asp:LinkButton>
            <asp:LinkButton ID="lnkAdd" CausesValidation="False" Text="Add a Template" runat="server" OnClick="lnkAdd_Click" PostBackUrl="~/jbcgnew/email_setup.aspx" ></asp:LinkButton>
            <asp:LinkButton ID="lnkEdit" CausesValidation="False" Text="Edit a Template" runat="server" OnClick="lnkEdit_Click" PostBackUrl="~/jbcgnew/email_setup.aspx"></asp:LinkButton>
            <asp:LinkButton ID="lnkDelete" Text="Delete a Template" CausesValidation="False" runat="server" OnClick="lnkDelete_Click" PostBackUrl="~/jbcgnew/email_setup.aspx"></asp:LinkButton>
            <asp:LinkButton ID="lnkExport" Text="Export to CSV" CausesValidation="false" runat="server" OnClick="lnkExport_Click" PostBackUrl="~/jbcgnew/email_setup.aspx" ></asp:LinkButton>
            
        </div>
        <br />
        <br />
        <asp:Panel ID="pnlEmail" runat="server" Height="50px" Style="position: static" Width="650px">
        
            <asp:Label ID="Label1" runat="server" Height="30px" Style="text-align:center;" Text="             Email Template"
            Width="500px" Font-Bold="True" Font-Size="Large"></asp:Label>
            
            <%--<table>
                <tr>
                    <td>
                    </td>
                    <td>
                        
                    </td>
                </tr>
            </table>--%>
            
            <table width="600px">
            <tr>
                <td style="width: 200px;text-align:right;">
                <asp:Label ID="Label2" runat="server" Height="25px" Style="text-align:right;" Text="To : "
                Width="69px"></asp:Label>
                
                </td>
                <td style="text-align:left; width:400px;">
                <asp:TextBox ID="TxtTo" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvTxtTo" runat="server" ControlToValidate="TxtTo" ErrorMessage="Required."></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revTo" runat="server" ControlToValidate="TxtTo"
                        Style="position: static" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Enter Email Address.</asp:RegularExpressionValidator></td>
            </tr>
            <tr>
               <td style="width: 200px;text-align:right;">
                    <asp:Label ID="Label3" runat="server" Height="19px" Style="text-align:right;" Text="From : "
                    Width="66px"></asp:Label>
               </td>
               <td style="text-align:left; width: 400px;">
                    <asp:TextBox ID="TxtFrom" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvTxtFrom" ControlToValidate="TxtFrom" runat="server" ErrorMessage="Required."></asp:RequiredFieldValidator>
                   <asp:RegularExpressionValidator ID="revFrom" runat="server" ControlToValidate="TxtFrom"
                       Style="position: static" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Enter Email Address.</asp:RegularExpressionValidator></td>
            </tr>
            <tr>
                <td style="width: 200px;text-align:right;">
                    <asp:Label ID="Label4" runat="server" Height="13px" Style="text-align:right;" Text="Subject : "
                     Width="64px"></asp:Label>
             </td>
             <td style="width: 400px;text-align:left;">
                    <asp:TextBox ID="TxtSub" runat="server" Style="text-align:left;" Width="176px"></asp:TextBox></td>       
            </tr>
            <tr>
                <td style="width: 200px; height: 24px;text-align:right;">
                    <asp:Label ID="Label7" runat="server" Height="13px" Style="text-align:right;" Text="Select Sbody : "
                    Width="90px"></asp:Label>
                </td>
                <td style="text-align:left; width: 400px; height: 24px;">
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
               <td style="width: 400px;vertical-align:top;text-align:left;">
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
               <td style="height: 24px; width: 400px;text-align:left;">
                      <asp:FileUpload ID="FileUpload1" runat="server" Style="text-align:left;" />
                   <asp:Button ID="btnSendFile" runat="server" Style="position: static" Text="Upload File" OnClick="btnSendFile_Click" Height="20px" /></td>         
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
            <td style="text-align:left; width: 400px;">
                <asp:ListBox ID="ListBox1" runat="server" Style="position: static" Width="216px" Height="120px"></asp:ListBox><asp:Button ID="btnRemoveFile" runat="server" OnClick="btnRemoveFile_Click" Style="position: static"
                    Text="Remove File" Height="20px" Width="80px" /><br />
                Total File size : 
                <asp:TextBox ID="TxtTotalSize" runat="server" Style="position: static" Width="112px" ReadOnly="True"></asp:TextBox>
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
            
            <table>
                <tr>
                    <td style="vertical-align:top;text-align:left;"> 
                    <asp:TextBox ID="lbl_help" runat="server" Text="You have to use the following Variables exactly as they are given to replace with its values. The Variables are : ##FirstName## , ##Login## , ##Password## , ##Date##  etc." ReadOnly="true" TextMode="multiLine" Height="200px" ></asp:TextBox>
                    </td>
                    <td>
                    
                    <table>
                <tr style="text-align:left;width:400px;">
                    <td style="text-align:right;"><asp:Label ID="Label8" runat="Server" Text="Enter Sbody Name :"></asp:Label>
                    </td>
                    <td ><asp:Label ID="lbl_msg" runat="Server" Text="BodyText" Width="64px"></asp:Label>
                        &nbsp;
                    <asp:TextBox ID="txtid" runat="server" Width="152px" Text="" style="position: static"></asp:TextBox></td>
                    
                </tr>
                
            <tr> <td colspan="2">
                &nbsp;
            </td>  </tr> 
           
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
                    <td style="width: 436px" >
                        <asp:DropDownList ID="DDLedit" runat="server" Width="228px" OnSelectedIndexChanged="DDLedit_SelectedIndexChanged" AutoPostBack="True" >
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDDLedit" ControlToValidate="DDLedit" runat="server" ErrorMessage="Select one of the Sbodies to Edit" InitialValue="Select Sbody"></asp:RequiredFieldValidator>    
                    </td>
                    
                </tr>
                 
            <tr> <td style="height: 21px" >
                <asp:Label ID="Label13" runat="server" Text="Attachments"></asp:Label></td> <td style=" text-align:left; height: 21px" >
                    <asp:FileUpload ID="FileUpload2"  runat="server" />
                    &nbsp;
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click1" Text="Upload File"
                        Width="93px" /></td>  </tr> 
                <tr>
                    <td style="height: 40px">
                    </td>
                    <td style="height: 40px; text-align: left">
                        <asp:ListBox ID="ListBox2" runat="server" Width="230px" Height="138px"></asp:ListBox>
                        <asp:Button ID="Button2" runat="server" Text="Remove File" Width="83px" OnClick="Button2_Click" /><br />
                        Total File Size :
                        <asp:TextBox ID="TextBox1" runat="server" Width="125px"></asp:TextBox>
                    </td>
                </tr>
           
            <tr style="text-align:left;width:400px;">
                <td style="vertical-align:top;text-align:right; height: 159px;"><asp:Label ID="Label12" runat="Server" Text="Enter Body Text :"></asp:Label>
                </td>
                <td colspan="1" style="height: 159px; width: 436px;"><asp:TextBox ID="Txtsbody1" runat="server" Width="250px" Text="" TextMode="MultiLine" Height="152px" CausesValidation="True"></asp:TextBox>&nbsp;
                </td>
            </tr>
             <tr> <td colspan="2"></td>  </tr> 
            <tr style="text-align:center;width:400px;">
                <td colspan="3"><asp:Button ID="BtnEdit" runat="server" Text="Submit" OnClick="BtnEdit_Click" />
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
                        <asp:DropDownList ID="DDLdelete" runat="server" Width="238px" OnSelectedIndexChanged="DDLdelete_SelectedIndexChanged" AutoPostBack="True" >
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDDLdelete" ControlToValidate="DDLdelete" runat="server" ErrorMessage="Select one of the Sbodies to Delete" InitialValue="Select Sbody"></asp:RequiredFieldValidator>  
                    </td>
                    
                </tr>
                </table>
            <asp:Button ID="Btndelete" runat="server" OnClick="Btndelete_Click" Style="position: static"
                Text="Delete" Width="63px" />
            <br />
            <br />
            <br />
            <asp:Label ID="Lbl_del" runat="server" Style="position: static" Width="264px"></asp:Label>
            
            </asp:Panel>
            
            
             <asp:Panel ID="pnlExport" runat="server" Visible="false" >
                <div style="text-align:center;">
             
                <asp:GridView ID="gvStudent" runat="server" AutoGenerateColumns="false" AllowPaging="true"  Style="position: static" OnPageIndexChanging="gvStudent_PageIndexChanging">
                <Columns>
                
                    <asp:TemplateField HeaderText="First Name" ItemStyle-HorizontalAlign="Left" >
                        <ItemTemplate>
                            <asp:Label ID="lblFname" runat="Server" Text='<%#Eval("FirstName") %>'></asp:Label>
                        </ItemTemplate>
                        
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Last Name" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <asp:Label ID="lblLname" runat="Server" Text='<%#Eval("LastName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Email" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <asp:Label ID="lblEmail" runat="Server" Text='<%#Eval("Email") %>'></asp:Label>
                        </ItemTemplate>
                       
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Year of Graduation" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:Label ID="lblYear" runat="Server" Text='<%#Eval("yearofGrad") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Student ID" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:Label ID="lblStudid" runat="Server" Text='<%#Eval("StudID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    
                 </Columns>
                </asp:GridView>
        
                <asp:Button ID="btnExport" runat="server" Style="position: static" Text="Export to CSV File" OnClick="btnExport_Click" />
        
                <a href="uploads/tempCSV.csv" runat="server" id="export_tocsv" visible="false" target="_parent">Open CSV File </a>
                </div>
                   
        </asp:Panel>
        
                
        
   </div> 
   
    </form>
    </body>
    
</html>
