<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">	
	//gets run every time the screen refreshes on this page
	public void Page_Load() {
		//checks to see if the session is still active when the page loads, tests the userid variable
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		//checks to see if the user has access to this page
		if(Session["priv_add_user"].ToString() != "1" ) {
			Response.Redirect("./nopriv.aspx");
		}
	}
			
	//adds the user to audits.users
	private void addUser(Object obj, EventArgs args) {
		//clears the aspx label control
		message.Text = "";

		//checks required fields
		if(Request["name"] == "") {
			message.Text += "** Name cannot be left blank. **<br>";
		}

		if(Request["address"] == "") {
			message.Text += "** Address cannot be left blank. **<br>";
		}

		if(Request["account_type"] == "") {
			message.Text += "** Account type be left blank. **<br>";
		}

		if(Request["phone"] == "") {
			message.Text += "** Phone cannot be left blank. **<br>";
		}else{
			if(Request["phone"].Length < 10) {
				message.Text += "** Phone number must contain an area code. **<br>";
			}else{
				try{
					long test = Convert.ToInt64(Request["phone"]);
				}catch(Exception e) {
					message.Text += "** Phone number must contain only numbers. **<br>";
				}
			}
		}

		if(Request["username"] == "") {
			message.Text += "** Username cannot be left blank. **<br>";
		}

		if(Request["emailaddress"] == "") {
			message.Text += "** Email address cannot be left blank. **<br>";
		}

		if(Request["password1"] == "") {
			message.Text += "** Password cannot be left blank. **<br>";
		}
	
		if(message.Text != "") {
			return;
		}
		//checks to see if the user already exists
		string sql = "SELECT * FROM users WHERE username='" + Request["username"] + "'";
		DataSet data = new DataSet();
		try {
			data = getMssqlData(sql);		
		}catch(Exception e) {
			message.Text = "** Error encountered (1) adding user. **<br>" + e.Message + "<br>" + sql;
			return;
		}

		try{
			if(data.Tables[0].Rows.Count > 0) {
				message.Text += "** Username has already been taken. **";
				return;
			}
		}catch(Exception e) {
			message.Text += "** Username has already been taken. **";
			return;				
		}


        //sql = "SELECT * FROM applications WHERE username='" + Request["username"] + "'";
        //data = new DataSet();
        //try {
        //    data = getMssqlData(sql);		
        //}catch(Exception e) {
        //    message.Text = "** Error encountered (2) adding user. **<br>" + e.Message + "<br>" + sql;
        //    return;
        //}

        //try{
        //    if(data.Tables[0].Rows.Count > 0) {
        //        message.Text += "** Username has already been taken. **";
        //        return;
        //    }
        //}catch(Exception e) {
        //    message.Text += "** Username has already been taken. **";
        //    return;				
        //}

		if(message.Text != "") {
			return;
		}

		//if username is not taken add user to audits.users
		sql = "INSERT INTO users (account_creation_date, active, address, emailaddress, name, password, phone, username, password_expiration_date, password_set_date, previous_password, account_type, ";
		//uses getMssqlData to query users so that the column names can be accessed
		DataSet cols = getMssqlData("SELECT TOP 1 * FROM users");				
		string tmp = "";
		for(int i = 1; i < cols.Tables[0].Columns.Count; i++) {
			tmp = cols.Tables[0].Columns[i].ToString();
			if(tmp.StartsWith("priv")) {
				if(i != (cols.Tables[0].Columns.Count - 1)) {
					sql += tmp + ", ";
				}else{
					sql += tmp;
				}
			}
		}
        sql = sql.Trim();
        sql = sql.TrimEnd(',');
		sql += ") VALUES('" + System.DateTime.Now.ToShortDateString() + "', '" + clean(Request["active"]) + "', '" + clean(Request["address"]) + "', '" + clean(Request["emailaddress"]) + "', '" + clean(Request["name"]) + "', '" + clean(Request["pword1"]) + "', '" + clean(Request["phone"]) + "', '" + clean(Request["username"]) + "', '" + System.DateTime.Now.ToShortDateString() + "', '" + System.DateTime.Now.ToShortDateString() + "', '" + clean(Request["pword1"]) + "', '" + clean(Request["account_type"]) + "', ";
		for(int i = 1; i < cols.Tables[0].Columns.Count; i++) {
			tmp = cols.Tables[0].Columns[i].ToString();
			if(tmp.StartsWith("priv")) {
				if(i != (cols.Tables[0].Columns.Count - 1)) {
					sql += "'" + Request[tmp] + "', ";
				}else{
					sql += "'" + Request[tmp] + "'";
				}
			}
        }
        sql = sql.Trim();
        sql = sql.TrimEnd(',');
		sql += ")";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
            message.Text = "** Error encountered (3) adding user. **<br>" + e.Message + "<br>" + sql;
			return;							
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
            message.Text = "** Error encountered (4) adding user. **<br>" + e.Message + "<br>" + sql;
			return;
		}
		data = new DataSet();
	
		//fills the dataset with payor information
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
            message.Text = "** Error encountered (5) adding user. **<br>" + e.Message + "<br>" + sql;
			return;
		}
		activeConn.Close();


		//try {
		//	getMssqlData(sql);
		//}catch(Exception e) {
		//	message.Text = "** Error encountered adding user. **<br>" + e.Message + "<br>";
		//}
		message.Text = "** User added successfully. **<br>";
/*		try {
			System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString());
			System.IO.Directory.CreateDirectory(Session["userrootdir"] + Request["username"]);
			System.IO.Directory.CreateDirectory(Session["userrootdir"] + Request["username"] + @"\download");
			message.Text += "** User's download folder created successfully. **<br>";
		}catch(Exception e){
			message.Text += "** Could not create user's download folder. **<br>" + e.Message;
		} */
	}

	private string clean(string src){
		return src.Replace("'","''");
	}

	//Generic data access function for querying SQL databases
	private DataSet getMssqlData(string s) {
		//string connStr = "NETWORK LIBRARY=" + Session["library"] + ";DATA SOURCE=" + Session["server"] + ";User ID=" + Session["dbuserid"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		//string connStr = "server=" + Session["auditserver"] + ";uid=" + Session["auditusername"] + ";pwd=" + Session["auditpassword"] + ";database=" + Session["auditdatabase"] + ";";
		//Response.Write(connStr);

		SqlDataAdapter adpt = new SqlDataAdapter(s, connStr);
		DataSet dt = new DataSet();
		try {
			adpt.Fill(dt);
		}catch(Exception e) {
			message.Text += "<center>** There was an error accessing " + Session["dbserver"] + ". **</center><br>" + e.Message + "<br>";
			throw(e);
		}
		return dt;
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<% if(Session["account_type"].ToString() == "Intern") { %>
	<!--#include file="./images/intern_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Representative") { %>
	<!--#include file="./images/rep_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Admin") { %>
	<!--#include file="./images/admin_menu/nav3.aspx"-->
<% } %>

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Add User&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">

		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td width="50%" align="right"><font class="black">Active</font></td>
			<td width="50%" ><select name="active">
			<% if(Request["active"] == "1") { %>
				<option selected value="1">Y</option>
				<option value="0">N</option>				
			<% }else{ %>
				<option value="1">Y</option>			
				<option selected value="0">N</option>
			<% } %>
				</select></td>
		</tr>
		<tr>
			<td align="right"><font class="black">Account Type</font><font class="red">*</font></td>
			<td><select name="account_type">
			<% if(Request["account_type"] == "Intern") { %>
				<option value="Admin">Admin</option>
				<option selected value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(Request["account_type"] == "Admin") { %>
				<option selected value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(Request["account_type"] == "Representative") { %>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option selected value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(Request["account_type"] == "Webmaster") { %>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option selected value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(Request["account_type"] == "Customer") { %>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option selected value="Customer">Customer</option>
			<% }else{ %>
				<option value="">SELECT ONE</option>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% } %>
				</select></td>
		</tr>
		<tr>
			<td align="right"><font class="black" align="right">Name</font><font class="red">*</font></td>					
			<td><input type="text" name="name" size="20" maxlength="50" value="<%= Request["name"] %>"></td>
		</tr>
		<tr>
			<td align="right"><font class="black">Address</font><font class="red">*</font></td>
			<td><input type="text" name="address" size="40" maxlength="255" value="<%= Request["address"] %>"></td>
		</tr>
		<tr>
			<td align="right"><font class="black" align="right">Phone</font><font class="red">*</font></td>					
			<td><input type="text" name="phone" size="10" maxlength="10" value="<%= Request["phone"] %>"></td>
		</tr>
		<tr>
			<td align="right"><font class="black" align="right">Email Address</font><font class="red">*</font></td>
			<td><input type="text" name="emailaddress" size="30" maxlength="100" value="<%= Request["emailaddress"] %>"></td>
		</tr>
		<tr>
			<td align="right"><font class="black">Username</font><font class="red">*</font></td>					
			<td><input type="text" name="username" size="20" maxlength="50" value="<%= Request["username"] %>"></td>
		</tr>
		<tr><td colspan="2" align="center"><font class="red">** Users will be prompted to change their password upon logging in. **</font></td></tr>
		<tr>
			<td align="right"><font class="black" align="right">Password</font><font class="red">*</font></td>					
			<td><input type="text" name="password1" size="20" maxlength="50" value="<%= Session["defaultpassword"] %>" disabled>
				<input type="hidden" name="pword1" value="<%= Session["defaultpassword"] %>"></td>
		</tr>
		<tr>
			<td align="right"><font class="black" align="right">Re-Type Password</font><font class="red">*</font></td>					
			<td><input type="text" name="password2" size="20" maxlength="50" value="<%= Session["defaultpassword"] %>" disabled>
				<input type="hidden" name="pword2" value="<%= Session["defaultpassword"] %>"></td>
		</tr>
		</table>
	</td>
<tr class="grey">
	<td>
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">User Privs&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
<tr>
	<td>
			<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<%	//uses getMssqlData to query users so that the column names can be accessed
			DataSet cols = getMssqlData("SELECT TOP 1 * FROM users"); %>				
		<%	string tmp = "";
			string sht = "";

			//uses the first row in audits.users to get column names and prints out an empty list of columns
			//sets the proper selected option tag based on the last post
			for(int i = 0; i < cols.Tables[0].Columns.Count; i++) {
				tmp = cols.Tables[0].Columns[i].ToString();
				if(tmp.StartsWith("priv")) {
					sht = tmp.Replace("priv_",""); %>
				<tr>					
					<td align="right" width="50%"><font class="black"><%= sht %>:</font></td>					
					<td width="50%"><select name="<%= tmp %>">
					<% if(Request[tmp] == "1") { %>
						<option selected value="1">Y</option>
						<option value="0">N</option>				
					<% }else{ %>
						<option value="1">Y</option>			
						<option selected value="0">N</option>
					<% } %>
						</select>
						</td>
				</tr>
		<%		}
			} %>
		<tr>
			<td colspan="2" align="center"><asp:button id="insertsubmit" text="Add" runat="server" onClick="addUser" /></td>
		</tr>
		</table>
	</td>
</tr>
</table>

<!--#include file="./footer.aspx"-->
</form></body></html>