<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Net.Mail" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language="C#" runat="server">
		
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null || Session["mainDataTable"] == null || Session["mainDictTable"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		
		//only runs the following code the first time this page loads
		if(!Page.IsPostBack) {
			Session["state"] = "new";
		}

		return;
	}
	
	private string checkInput(string inputString)
    {
        inputString = inputString.Replace('[', '<');
        inputString = inputString.Replace(']', '>');
        inputString = inputString.Replace(Environment.NewLine, "<BR />");
        return inputString.Replace("'", "''");
    }
    
    public class PasswordGenerator
    {
        private char[] characterArray;
        private Int32 passwordLength = 8;
        Random randNum = new Random();
        public PasswordGenerator()
        {
            characterArray = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".ToCharArray();
        }
        private char GetRandomCharacter()
        {
            return this.characterArray[(int)((this.characterArray.GetUpperBound(0) + 1) * randNum.NextDouble() )];
        }
        public string Generate()
        {
            StringBuilder sb = new StringBuilder();
            sb.Capacity = passwordLength;
            for (int count = 0; count <= passwordLength - 1; count++)
            {
                sb.Append(GetRandomCharacter());
            }
            if ((sb != null))
            {
                return sb.ToString();
            }
            return string.Empty;
        }
    }
    
    private void ExecuteHtmlSendMail(string FromAddress, string ToAddress, string Subject, string BodyText)
    {
        MailMessage mailMsg = new MailMessage();

        mailMsg.From = new MailAddress(FromAddress);
        mailMsg.To.Add(new MailAddress(ToAddress));
        mailMsg.Subject = Subject;
        mailMsg.BodyEncoding = System.Text.Encoding.GetEncoding("utf-8");

        System.Net.Mail.AlternateView plainView = System.Net.Mail.AlternateView.CreateAlternateViewFromString
        (System.Text.RegularExpressions.Regex.Replace(BodyText, @"<(.|\n)*?>", string.Empty), null, "text/plain");
        System.Net.Mail.AlternateView htmlView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(BodyText, null, "text/html");

        mailMsg.AlternateViews.Add(plainView);
        mailMsg.AlternateViews.Add(htmlView);

        // Smtp configuration
        SmtpClient smtp = new SmtpClient();
        smtp.Host = "mail.college-retirement.com";

        smtp.Send(mailMsg);
    }
	
	protected void sendThankYouLetter(int id, string email, string hs, string fname, string lname, string pw)
	{
	    string getTemplateTypeID = "SELECT value FROM CRM_config WHERE setting='autoThankYouLetter_Type'";
	    SqlConnection sCon = new SqlConnection(ConfigurationManager.ConnectionStrings["madisonDB"].ToString());
	    SqlCommand getTypeID = new SqlCommand(getTemplateTypeID,sCon);
	    
	    sCon.Open();
	    string TYL_TYPE_ID = (string)getTypeID.ExecuteScalar();
	    
	    string getTemplateID = "SELECT activeTemplateID FROM CRM_TemplateTypes WHERE typeID='" + TYL_TYPE_ID + "'";
	    SqlCommand getTID = new SqlCommand(getTemplateID,sCon);
	    
	    int TYL_TID = (int)getTID.ExecuteScalar();
	    
	    string getTemplateInfo = "SELECT templateSubject, templateBody FROM CRM_Templates WHERE templateID='" + TYL_TID.ToString() + "'";
	    SqlCommand getTemplate = new SqlCommand(getTemplateInfo,sCon);
	    SqlDataReader reader = getTemplate.ExecuteReader();
	    DataTable dt = new DataTable();
	    dt.Load(reader);
	    reader.Close();
	    sCon.Close();
	    
	    string HTMLBody = dt.Rows[0]["templateBody"].ToString();
	    string emailSubject = dt.Rows[0]["templateSubject"].ToString();
	    
	    HTMLBody = HTMLBody.Replace("##FirstName##",fname);
	    HTMLBody = HTMLBody.Replace("##LastName##",lname);
	    HTMLBody = HTMLBody.Replace("##HighSchoolName##",hs);
	    HTMLBody = HTMLBody.Replace("##EmailAddress##",email);
	    HTMLBody = HTMLBody.Replace("##Password##",pw);
	    
        message.Text += "<br />'Thank You' Letter Sent";
	    
	    ExecuteHtmlSendMail("auto-greeter@college-retirement.com", email, emailSubject, HTMLBody);
	    	    
	}
	
	protected void createAccount(int id)
	{
        PasswordGenerator pwgen = new PasswordGenerator();
        string randomPW = pwgen.Generate();
        
        string getUserInfo = "SELECT col0018 as emailaddress, col0018 as username, col0002 as firstname, col0004 as lastname FROM mfac_parent_info WHERE claimid='" + id.ToString() + "' and id=1";
        string getUserInfo2 = "SELECT col0013 as phone, col0020 as usergradyear, col0018 as highschool FROM mfac_client_data2 WHERE id='" + id.ToString() + "'";
        
        SqlConnection sCon = new SqlConnection(ConfigurationManager.ConnectionStrings["madisonDB"].ToString());
        SqlCommand getUI1 = new SqlCommand(getUserInfo,sCon);
        SqlCommand getUI2 = new SqlCommand(getUserInfo2,sCon);
        SqlDataReader reader = null;
        DataTable dt1 = new DataTable();        
        DataTable dt2 = new DataTable();
        
        sCon.Open();
        reader = getUI1.ExecuteReader();
        dt1.Load(reader);
        reader.Close();
        reader = getUI2.ExecuteReader();
        dt2.Load(reader);
        reader.Close();
        
        string email = dt1.Rows[0]["emailaddress"].ToString();
        if(email == null || email == "")
        {
            sCon.Close();
            return;
        }
        
        string highschool = dt2.Rows[0]["highschool"].ToString();
        string fname = dt1.Rows[0]["firstname"].ToString();
        string lname = dt1.Rows[0]["lastname"].ToString();
        
        string newUserStr = "INSERT INTO users (random,parentOrStudent,lastEmailSent,account_creation_date, active, emailaddress, name, password, phone, username, password_expiration_date, password_set_date, account_type, usergradyear, usercase) VALUES ('" + pwgen.Generate() + "','Parent','" + DateTime.Now.ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','1','" + dt1.Rows[0]["emailaddress"].ToString() + "','" + dt1.Rows[0]["firstname"].ToString() + " " + dt1.Rows[0]["lastname"].ToString() + "','" + randomPW + "','" + dt2.Rows[0]["phone"].ToString() + "','" + dt1.Rows[0]["username"].ToString() + "','" + System.DateTime.Now.AddMonths(3).ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','Customer','" + dt2.Rows[0]["usergradyear"].ToString() + "','" + id.ToString() + "')";
        SqlCommand sCmd = new SqlCommand(newUserStr,sCon);
        sCmd.ExecuteNonQuery();
        sCon.Close();
        message.Text += "<br />User Account Created";
        sendThankYouLetter(id, email, highschool, fname, lname, randomPW);
	}
		
	private void addLead(Object obj, EventArgs args) {
	
		Session["state"] = "old";
		message.Text = "";
		string sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section = '6' AND number <= 44 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp,true);
		int id = 1;		

		if(message.Text == "") {
			try {
				//if(id.ToString() == Request["id"] || tmp.Tables[0].Rows[0][0].ToString() == "") {
				
				sql = "INSERT INTO " + Session["mainDataTable"] + " ([userid],[transactionBy],[transactionDate],[status]) VALUES(null," + Session["userid"] + ",'" + System.DateTime.Now.ToShortDateString() + "','New Lead');";
				getMssqlData(sql);

				sql = "SELECT MAX(id) FROM " + Session["mainDataTable"] + ";";
				tmp = getMssqlData(sql);
				try {
					id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
					//id++;	
				}catch{
					id = 1;	
				}

				Session["id"] = id.ToString();

				updateSection(6);
				updateLog(id.ToString(), "New Lead");
				message.Text = "*New lead stored successfully.*";
				//}else{
				//	message.Text = "*Lead has already been entered.*";
				//}
				Session["state"] = "new";
				Session["id"] = null;
				
	            if (Request["TYL"].ToString() == "Yes") createAccount(id);
			}catch(Exception e){
				//Response.Write(e.Message);
				message.Text = "*Could not store new lead.*<br>" + e.Message + "<br>" + e.StackTrace;
			}
		}
	}
    	</script>
        <script type="text/javascript">
        function setf()
        {
            var x = document.getElementsByName('col0609');
            x[0].focus();
        }
        </script>
  	</head>
<body onload="setf()" text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/intern_menu/nav.aspx"-->
<form method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr>
		</table>
	</td>
</tr><tr>
	<td align="center">
	<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
	<tr>
		<td colspan="3" align="center">
			<asp:Button id="addtop" runat="server" text="Add Lead" onClick="addLead" />
            </td>
	</tr>
    <tr>
	    <td width="10%">
		    &nbsp;
	    </td>
	    <td align="left" width="40%">
		    <font class="redsm">Confirmation Option:</font>&nbsp;
		    <font class="blacksm">Send 'Thank You' Message?</font>
	    </td>
	    <td align="left" width="40%">
	        <select name="TYL" id="TYL">
	            <option selected="selected" value="Yes">Yes</option>
	            <option value="No">No</option>
	        </select>
	    </td>
    </tr>
<% if(Session["state"].ToString() == "old") { %>	
	<%= printForm(6, "web", 1, 27) %>
<% }else if(Session["state"].ToString() == "new") { %>

	
	<%
		/*
		string sql = "SELECT MAX(id) FROM " + Session["mainDataTable"] + ";";
		DataSet tmp = getMssqlData(sql);
		int id = 1;
		try {
			id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
			id++;	
		}catch{
			id = 1;	
		}
		*/
	%>
	<%= printForm(6, "null", 1, 27) %>
<% } %>
	<tr>
		<td colspan="3" align="center">
			<asp:Button id="add" runat="server" text="Add Lead" onClick="addLead" />
		</td>
	</tr>
	</table>

	</td>
</tr>
</table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>