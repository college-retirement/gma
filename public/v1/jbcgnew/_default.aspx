<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="../../../browse.css" type="text/css" rel="stylesheet">
	<link href="../../../global.css" rel="stylesheet" type="text/css">
	<script language="C#" runat="server">
		
		public void Page_Load() {
			//only runs the following code the first time this page loads
			if(!Page.IsPostBack) {
				setSession();
				return;
			}
			return;
//Response.Write("DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"]);
		}
		
		//Generic data access function for querying SQL databases
		private DataSet getMssqlData(string s) {
			//string connStr = "NETWORK LIBRARY=" + Session["library"] + ";DATA SOURCE=" + Session["server"] + ";User ID=" + Session["dbuserid"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
			string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
			//string connStr = "server=" + Session["auditserver"] + ";uid=" + Session["auditusername"] + ";pwd=" + Session["auditpassword"] + ";database=" + Session["auditdatabase"] + ";";
		//	Response.Write(connStr);
//Response.End();
Session["currcon"]=connStr;
//////////ADDED CODE TO PREVENT SQL INJECTION
            		SqlConnection connection = new SqlConnection(connStr);
            		SqlCommand cmd = new SqlCommand(s, connection);
            		cmd.Parameters.Add("@username", SqlDbType.VarChar, 50).Value = Request["username"];
            		cmd.Parameters.Add("@password", SqlDbType.VarChar, 50).Value = Request["password"];

            		SqlDataAdapter adpt = new SqlDataAdapter(cmd);
			//SqlDataAdapter adpt = new SqlDataAdapter(s, connStr);
			DataSet dt = new DataSet();
			try {
				adpt.Fill(dt);

			}catch(Exception e) {
				message.Text += "<center>** There was an error accessing " + Session["dbserver"] + ". **</center><br>" + e.Message + "<br>";
				throw(e);
			}
			return dt;
		}

		private void setSession() {
			//empties out the session
			Session.Clear();

			//this password is used on the add user tool
			Session["defaultpassword"] = "123";

			//location of audits database and connection information
			Session["dbserver"] = "rw-sql-01.real-ware.com";
            Session["dbusername"] = "madison_sysdba";
			Session["dbpassword"] = "madf1n8id";
            Session["database"] = "madison_madisonfinancialaid";
			Session["dbtimeout"] = "300";
			Session["library"] = "DBMSSOCN";

			//Response.Write(Session["dbserver"] + "<br>");
			//Response.Write(Session["dbusername"] + "<br>");
			//Response.Write(Session["dbpassword"] + "<br>");
			//Response.Write(Session["database"] + "<br>");
			//Response.Write(Session["dbtimeout"] + "<br>");
			//Response.Write(Session["library"] + "<br>");

			Session["ipaddress"] = "www.madisonfinancialaid.com";
            Session["home"] = @"http://" + Session["ipaddress"];
			Session["serverroot"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/Default.aspx";
			Session["docroot"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/temp/";
			Session["imagedir"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/images/";
			Session["userrootdir"] = @"D:\root\madison\madisonfinancialaid.com\www\jbcg\userfolders\";

			Session["passwordexpired"] = "0";
			Session["mainDataTable"] = "mfac_client_data2";
			Session["mainDictTable"] = "mfac_data_dictionary";
			Session["mainLogTable"] = "mfac_status_log";
			Session["mainChoiceTable"] = "mfac_college_choice";
			Session["mainParentTable"] = "mfac_parent_info";
			Session["mainFamilyTable"] = "mfac_family_info";
			Session.Timeout = 300;
		}

		private void loginSubmit(Object obj, EventArgs args) {
			//check form fields
			if(Session["dbserver"] == "" || Session["dbserver"] == null) {
				setSession();
			}
			message.Text = "";
			if(Request["username"] == "" || Request["password"] == "") {
				message.Text = "** Username and password required. **";
				return;
			}

			//check if the user exists and is active STRING SQL MODIFIED TO PREVENT SQL INJECTION ATTACK
			//string sql = "SELECT * FROM users WHERE username='" + Request["username"] + "' AND password='" + Request["password"] + "' AND active='1'";
            		string sql = "SELECT * FROM users WHERE username=@username AND password=@password AND active='1'";

			//Response.Write(sql);
			DataSet data = new DataSet();
			data = getMssqlData(sql);

			try{
				if(data.Tables[0].Rows.Count == 0) {
					message.Text = "** Invalid username or password **";
					return;
				}else{
					processUserInfo(data);
					return;
				}
			}catch(Exception e) {
				message.Text = "** Invalid username or password **";
				return;				
			}
			return;
		}

		//load all the users information from audits.users, checks to see if the user's password has expired
		private void processUserInfo(DataSet uData) {
			try {
				for(int i = 0; i < uData.Tables[0].Columns.Count; i++) {
					Session[uData.Tables[0].Columns[i].ColumnName] = uData.Tables[0].Rows[0][i];
				}
			}catch(Exception e) {
				message.Text = "** Error loading user settings. **";
				return;
			}
	
			//if expired redirect to the password update page, set a session flag so the user is then 
			//redirected to the home page upon completion of a password update
			if(Convert.ToDateTime(Session["password_expiration_date"]) <= System.DateTime.Now) {
				Session["passwordexpired"] = "1";
				Response.Redirect("./passwordupdate.aspx");
				return;
			}else{

				//otherwise redirect home
				if(Session["account_type"].ToString().ToLower() == "admin"){
					Response.Redirect("./assign_leads.aspx");
				}else if(Session["account_type"].ToString().ToLower() == "intern"){
					Response.Redirect("./add_lead.aspx");
				}else if(Session["account_type"].ToString().ToLower() == "representative"){
					Response.Redirect("./new_leads.aspx");
				}
				//Response.Redirect("./home.aspx");
				return;			
			}
			return;
		}
    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout" onload="document.getElementById('login').focus()">
<!--#include file="./images/login_menu/login.aspx"-->
<form method="post" runat="server">
<br /><br />
<table border="1" cellpadding="1" cellspacing="0" align="center" border="0" >
  <tr><td>
  <table border="0" cellpadding="4" cellspacing="4" align="center" valign="middle" width="100%">
    <tr><td align="center"><div id="listCrumbar" class="breadcrumb">
      <font size="4">CRS LOGIN</font>
    </div></td></tr>
    <tr><td align="right">Username: </td> 
      <td><input type="text" size="20" name="username" id="login" maxlength="20"></td> </tr>
    <tr> <td></td> <td align="left">  </td>   </tr> 
    <tr> <td align="right">Password: </td> 
      <td> <input type="password" size="20" name="password" maxlength="20"></td></tr>
      <tr> <td></td> <td align="left">  </td> </tr>   
    <tr> <td></td> <td align="left"> <asp:Button id="Button1" runat="server" text="Login" onClick="loginSubmit" /></td> </tr>      
    <tr> <td colspan="2" align="center"> <a href="./forgotpass.aspx" class="black">Forgot your password ?</a></td> </tr>        
    <tr > <td colspan="2" align="center"> <a href="./application.aspx" class="black">Click here for an account application.</a></td> </tr>        
  </table></td></tr>
</table>
<!--
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td align="left"><font class="white">MFAC Advisor Login</font></td>
		</tr></table>
	</td>
</tr>
 <tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/></font></td>
		</tr></table>
	</td>
</tr> 
</table>
-->



</form>
<br /><br />
<!--#include file="./footer.aspx"-->
</body>
</html>