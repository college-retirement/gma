
<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net.Mail" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >

<script runat="server">
    //Date:29/11/2007
//Here the data comes from the case_info i have readed the data from that database and shown to the particular textboxes.
//here you can update the data and that data is stored in the database and also shown in the grid.
//and mail is send to the client, Now client emailaddress has being taken form case_info where they show the name of the client 
   
    protected void Page_Load(object sender, EventArgs e)
    {
        //Session["required"] = "notvalidate";
        if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}  
        string con = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ToString();
        if (Request.Params["ID"] != null)
        {

            if (!IsPostBack)
            {
                Int32 apptid = Convert.ToInt32(Request.QueryString["ID"].ToString());
                SqlConnection sqlconnect = new SqlConnection(con);
                sqlconnect.Open();
                SqlCommand cmd = new SqlCommand("SELECT madison_sysdba.appointments.id,madison_sysdba.appointments.appointment,madison_sysdba.users.name as name,madison_sysdba.locations.id as locationid,madison_sysdba.locations.name as locations,madison_sysdba.appointments.apptstatus ,madison_sysdba.appointments.apptclient,madison_sysdba.appointments.note  FROM madison_sysdba.appointments INNER JOIN madison_sysdba.users on madison_sysdba.users.userid = madison_sysdba.appointments.userid INNER JOIN madison_sysdba.locations ON madison_sysdba.appointments.locationid = madison_sysdba.locations.id where madison_sysdba.appointments.id =" + apptid + "", sqlconnect);
                DataSet ds_sbody = new DataSet();
                SqlDataAdapter dad = new SqlDataAdapter("select * from madison_sysdba.locations", sqlconnect);
                dad.Fill(ds_sbody);
                DropDownList4.DataTextField = "name";
                DropDownList4.DataValueField = "id";
                DropDownList4.DataSource = ds_sbody.Tables[0];
                DropDownList4.DataBind();
                DropDownList4.Items.Insert(0, "Select location");
                try
                {
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.HasRows)
                    {
                        string dt, t,dd;
                        string hour,minute,tt;
                        int dd1 = 0;
                        while (dr.Read())
                        {
                            dt = dr["appointment"].ToString();
                            TextBox2.Text = dr["name"].ToString();
                            dd = dr["locations"].ToString();
                            dd1 = Convert.ToInt32(dr["locationid"]);
                            TextBox4.Text = dr["apptstatus"].ToString();
                            TextBox5.Text = dr["apptclient"].ToString();
                            TextBox6.Text = dr["note"].ToString();
                            t = Convert.ToDateTime(dt).ToShortDateString();
                            Convert.ToDateTime(t);
                            TextBox1.Text= t;
                            t=Convert.ToDateTime(dt).ToShortTimeString();
                            hour = Convert.ToDateTime(t).ToString("h ").Trim();
                            minute = Convert.ToDateTime(t).ToString("mm"); 
                            tt = Convert.ToDateTime(t).ToString("tt").Trim();
                            
                            DropDownList1.SelectedItem.Text = hour.ToString();
                            DropDownList2.SelectedItem.Text = minute.ToString();
                            DropDownList3.Text = tt.ToString();
                            //DropDownList4.SelectedItem.Text = dd.ToString();
                           // Response.Write("" + dd.ToString());    
                            for(int i = 0; i <= DropDownList4.Items.Count - 1; i++)
                            {
                            if(dd.ToString().Trim() == DropDownList4.Items[i].ToString().Trim())
                            {
                                DropDownList4.Items[i].Selected = true;
                                break;
                            }
                            }                        
                      }
                    }
                   
        
                  
                }
                catch (Exception ex)
                {
                    message.Text = ""+ex.Message;
                }
                finally
                {
                    sqlconnect.Close();
                }
            }
        }
        
    }
  
    private void btnupdate_Click(Object obj, EventArgs args)
    {
         string con = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ToString();
         SqlConnection sqlconnect = new SqlConnection(con);
         sqlconnect.Open();
         try
         {
            
             string t = TextBox1.Text + " " + DropDownList1.SelectedValue + ":" + DropDownList2.SelectedValue + " " + DropDownList3.SelectedValue;
             Convert.ToDateTime(t);
               
             Int32 apptid = Convert.ToInt32(Request.QueryString["ID"].ToString());
             string sqlquery = "update madison_sysdba.users set  madison_sysdba.users.name ='" + TextBox2.Text + "' where userid=(select userid from madison_sysdba.appointments where madison_sysdba.appointments.id=" + apptid + ")";
             SqlCommand scmd = new SqlCommand(sqlquery, sqlconnect);
             scmd.ExecuteNonQuery(); //////commented by avinash
             string sqlquery1 = "select id from madison_sysdba.locations where madison_sysdba.locations.name ='" + DropDownList4.SelectedItem.Text+ "'";
             SqlCommand scm = new SqlCommand(sqlquery1, sqlconnect);
             SqlDataReader sdr = scm.ExecuteReader();
             int id =0;
             while (sdr.Read())
             {
                 id = Convert.ToInt32(sdr["id"]);
             }
             sdr.Close();
             Convert.ToInt32(id);
             string sqlquery2 = "update madison_sysdba.appointments set madison_sysdba.appointments.locationid = " + id + ",madison_sysdba.appointments.appointment = '" + t + "',madison_sysdba.appointments.note ='" + TextBox6.Text + "',madison_sysdba.appointments.apptstatus ='" + TextBox4.Text + "',madison_sysdba.appointments.apptclient ='" + TextBox5.Text + "' where madison_sysdba.appointments.id=" + apptid + "";
             SqlCommand scm1 = new SqlCommand(sqlquery2, sqlconnect);
             scm1.ExecuteNonQuery(); /////commented by avinash

             string sqlquery3 = "select madison_sysdba.users.emailaddress from madison_sysdba.users where madison_sysdba.users.userid=" + Session["userid"] + "";
             SqlCommand scmd1 = new SqlCommand(sqlquery3, sqlconnect);
             SqlDataReader sdr1 = scmd1.ExecuteReader();
             string stradmin;
             while (sdr1.Read())
             {
                 Session["stradm"] = sdr1["emailaddress"].ToString();
             }
             sdr1.Close();
             //Date:29/11/2007
             //client name is coming from the mfac_parent_info  according to that i have taken the emailid 
             //In To : clients email address will be there strclient is nothing but the client email which is coming from case_info
             //and str admin is user who has logged in.
             //Response.Write("Clients Email:" +Session["clientemail"].ToString());  
             //////from this onwords code has been added on 30 jan  
             string attach = string.Empty;
             string strs = DropDownList4.SelectedItem.ToString();
             string sqlq = "select sattach from sbody where sbodynum='BodyTextAppointmentEmail" + strs + "'";
             SqlCommand scom = new SqlCommand(sqlq, sqlconnect);
             //dr.Open();
             SqlDataReader dr = scom.ExecuteReader();
             while (dr.Read())
             {
                 attach = dr["sattach"].ToString();
             }
             dr.Close(); 
             string[] name = null;
             string delimStr = ",";
             char[] delimiter = delimStr.ToCharArray();
             int last123 = attach.LastIndexOf(",");
             attach = attach.Remove(last123, 1);
             name = attach.Split(delimiter);
             /*
                char[] delimiter = delimStr.ToCharArray();
                int last = satta.LastIndexOf(",");
                satta = satta.Remove(last, 1);
                name = satta.Split(delimiter);*/
             //foreach (string s in name)
             //{
             //    int last1 = s.LastIndexOf("(");
             //    string s1 = s.Remove(last1);
             //    string path = Server.MapPath("./uploads/" + s1);
             //    msg.Attachments.Add(new Attachment(path));
             //}

             //////upto this has been added on 30 jan
             stradmin = Session["stradm"].ToString();
             string strsub = "Appointment is Altered";
             string strbody = "Thankyou for rescheduling the appointment. Your updated time is "+t;
             string emailFrom = "auto-confirm@college-retirement.com";    
             string strclient = Session["clientemail"].ToString();

             if (strclient.ToString() == "")
             {
                 string strb;
                 MailAddress To_addr = new MailAddress("info@college-retirement.com");
                 MailAddress From_addr = new MailAddress(emailFrom);
                 MailMessage msg = new MailMessage(From_addr, To_addr);
                 msg.Subject = strsub;
                 msg.IsBodyHtml = true;
                 foreach (string s in name)
                 {
                     int last1 = s.LastIndexOf("(");
                     string s1 = s.Remove(last1);
                     string path = Server.MapPath("./uploads/" + s1);
                     msg.Attachments.Add(new Attachment(path));
                 }
                  strb = "There is no email in the database for client [" + Session["clientName"] + "]." +
                  "Please get the email so we can send the " +
                  "client a confirmation email. The appointment is scheduled for " + t + ".  Location = " + DropDownList4.SelectedValue+ ".";

                 msg.Body = strbody;
                 msg.Bcc.Add("avinashpawar@aspirtek.com");
                 SmtpClient smtp_mail = new SmtpClient();
                 smtp_mail.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                 smtp_mail.Host = "localhost";
                 smtp_mail.Send(msg);
                
             }
             else
             {
                 MailAddress To_addr = new MailAddress(strclient);
                 MailAddress From_addr = new MailAddress(stradmin);
                 MailMessage msg = new MailMessage(From_addr, To_addr);
                 foreach (string s in name)
                 {
                     int last1 = s.LastIndexOf("(");
                     string s1 = s.Remove(last1);
                     string path = Server.MapPath("./uploads/" + s1);
                     msg.Attachments.Add(new Attachment(path));
                 }
                 msg.Bcc.Add("avinashpawar@aspirtek.com");
                 msg.Subject = strsub;
                 msg.Body = strbody;
                 SmtpClient smtp_mail = new SmtpClient();
                 smtp_mail.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                 smtp_mail.Host = "localhost";
                 smtp_mail.Send(msg);
             }
         }
         catch (Exception ex)
         {
              message.Text = "" + ex.Message;
         }
        finally
        {
            sqlconnect.Close();
        }
        
    }
</script>

<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
    <link href="../../../global.css" rel="stylesheet" type="text/css">
</head>
<body text="#000000" bgColor="#ffffff" >
<!--#include file="./images/login_menu/login.aspx"-->
<form id="Form1" method="post" runat="server">
<table border="1" cellpadding="0" cellspacing="0" align="left"  style="vertical-align :top"  width="450" >
<tr>
	<td align="center" style="width: 410px">
		<table border="0" cellpadding="4" cellspacing="0" align="center" style="vertical-align :top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
	</tr>
	<tr>
	<td style="width: 410px">
        <table align="center" border="0">
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Appointment Date" Font-Names="arial" Font-Size="9pt"></asp:Label>
                </td>
                <td style="font-weight: bold; font-size: 9pt; font-family: Arial">
                
                   <asp:TextBox ID="TextBox1" runat="server" Font-Names="arial" Font-Size="9pt"></asp:TextBox> MM/DD/YYYY
                   
                </td>
              <tr>
              <td>
              <asp:Label ID="Label7" runat="server" Text="Appointment Time" Font-Names="arial" Font-Size="9pt"></asp:Label>
              </td>
              <td>
             <asp:DropDownList ID="DropDownList1" runat="server">
            <asp:ListItem>1</asp:ListItem>
            <asp:ListItem>2</asp:ListItem>
            <asp:ListItem>3</asp:ListItem>
            <asp:ListItem>4</asp:ListItem>
            <asp:ListItem>5</asp:ListItem>
            <asp:ListItem>6</asp:ListItem>
            <asp:ListItem>7</asp:ListItem>
            <asp:ListItem>8</asp:ListItem>
            <asp:ListItem>9</asp:ListItem>
            <asp:ListItem>10</asp:ListItem>
            <asp:ListItem>11</asp:ListItem>
            <asp:ListItem>12</asp:ListItem>
            </asp:DropDownList>
         <asp:DropDownList ID="DropDownList2" runat="server">
            <asp:ListItem>00</asp:ListItem>
            <asp:ListItem>15</asp:ListItem>
            <asp:ListItem>30</asp:ListItem>
            <asp:ListItem>45</asp:ListItem>
           </asp:DropDownList>
           <asp:DropDownList ID="DropDownList3" runat="server">
            <asp:ListItem>AM</asp:ListItem>
            <asp:ListItem>PM</asp:ListItem>
             </asp:DropDownList>
              </td>
            </tr>
            <tr>
                <td>
                <asp:Label ID="Label2" runat="server" Text="Name" Font-Names="arial" Font-Size="9pt"></asp:Label>
                </td>
                <td>
                <asp:TextBox ID="TextBox2" runat="server" Font-Names="arial" Font-Size="9pt"></asp:TextBox>
                </td>
                
            </tr>
            <tr>
                <td>
                <asp:Label ID="Label3" runat="server" Text="Location" Font-Names="arial" Font-Size="9pt"></asp:Label>
                </td>
                <td>
                 <asp:DropDownList ID="DropDownList4" runat="server" AutoPostBack="True">
                  </asp:DropDownList>
                </td>
               
            </tr>
            <tr>
            <td>
            <asp:Label ID="Label4" runat="server" Text="Status" Font-Names="arial" Font-Size="9pt"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="TextBox4" runat="server" Font-Names="arial" Font-Size="9pt"></asp:TextBox>
            </td>
            </tr>
            <tr>
            <td>
            <asp:Label ID="Label5" runat="server" Text="Client" Font-Names="arial" Font-Size="9pt"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="TextBox5" runat="server" Font-Names="arial" Font-Size="9pt"></asp:TextBox>
            </td>
            </tr>
            <tr>
            <td>
            <asp:Label ID="Label6" runat="server" Text="Appointment Notes" Font-Names="arial" Font-Size="9pt"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="TextBox6" runat="server" Font-Names="arial" Font-Size="9pt"></asp:TextBox>
            </td>
            </tr>
            <tr>
            <td>
                <asp:Button ID="btnupdate" runat="server" Text="Update" OnClick="btnupdate_Click" Font-Names="arial" Font-Size="9pt" /> 
            </td>
            <td>
                <asp:Button ID="btnclose" runat="server" Text="Close" OnClientClick ="javascript:self.close();window.opener.document.forms(0).submit();" Font-Names="arial" Font-Size="9pt"/>
            </td>
            </tr>
        </table>
	
	</td>
	</tr>
	</table> 
</form>

</body>
</html>