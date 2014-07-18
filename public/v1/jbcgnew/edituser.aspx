<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">
	DataSet uData;
	
	//Check session information and Session validity.		
	public void Page_Load() {
		//Response.Write(Page.MapPath("./"));
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["priv_edit_user"].ToString() != "1" ) {
			Response.Redirect("./nopriv.aspx");
		}
		if(!Page.IsPostBack) {
			Session["state"] = "select";		
		}

		if(Request["jumpuser"] != "" && Request["jumpuser"] != null) {
			changeState();			
		}					
	}
	
	
	//Returns an html dropdown of users.
	private string printUserList() {
		string package = "";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM users ORDER BY name";
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";							
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		DataSet data = new DataSet();
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		activeConn.Close();
		try {
			if(data.Tables[0].Rows.Count == 0) {
				message.Text = "** No users found. **";
				return "";
			}else{
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					package += "<option value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + " [" + data.Tables[0].Rows[i]["username"] + "]</option>\n";						
				}
			}
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		return package;
	}

	//Checks the form information and updates the user's information in the database, audits.users.
	private void updateUser(Object obj, EventArgs args) {
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
			Session["state"] = "edit_post_back";
			return;
		}
		//checks to see if the user already exists
		string sql = "SELECT * FROM users WHERE username='" + Request["username"] + "'";
		DataSet data = new DataSet();
		try {
			data = getMssqlData(sql);		
		}catch(Exception e) {
			message.Text = "** Error encountered adding user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;
		}

		try{
			if(data.Tables[0].Rows.Count > 1) {
				message.Text += "** Username has already been taken. **";
				Session["state"] = "edit_post_back";
				return;
			}
		}catch(Exception e) {
			message.Text += "** Username has already been taken. **";
			Session["state"] = "edit_post_back";
			return;				
		}


		sql = "SELECT * FROM users WHERE username='" + Request["username"] + "'";
		data = new DataSet();
		try {
			data = getMssqlData(sql);		
		}catch(Exception e) {
			message.Text = "** Error encountered editing user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;
		}

		try{
			if(data.Tables[0].Rows.Count > 0) {
				message.Text += "** Username has already been taken. **";
				Session["state"] = "edit_post_back";
				return;
			}
		}catch(Exception e) {
			message.Text += "** Username has already been taken. **";
			Session["state"] = "edit_post_back";
			return;				
		}


		if(message.Text != "") {
			Session["state"] = "edit_post_back";
			return;
		}

		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		sql = "SELECT * FROM users WHERE username='" + Request["username"] + "' AND userid <> '" + Request["user"] + "'";
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;				
		}
		data = new DataSet();
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;				
		}
		activeConn.Close();
		try{
			if(data.Tables[0].Rows.Count > 0) {
				message.Text += "** Username has already been taken. **";
				Session["state"] = "edit_post_back";
				return;
			}
		}catch(Exception e) {
			message.Text += "** Username has already been taken. **";
			Session["state"] = "edit_post_back";
			return;				
		}

		sql = "UPDATE users SET active='" + clean(Request["active"]) + "', address='" + clean(Request["address"]) + "', emailaddress='" + clean(Request["emailaddress"]) + "', name='" + clean(Request["name"]) + "', phone='" + clean(Request["phone"]) + "', username='" + clean(Request["username"]) + "', account_type = '" + clean(Request["account_type"]) + "', ";
		DataSet cols = getMssqlData("SELECT TOP 1 * FROM users");		
		string tmp = "";
        string tmp2 = "";
        for (int i = 1; i < cols.Tables[0].Columns.Count; i++)
        {
            tmp = cols.Tables[0].Columns[i].ToString();
            if (tmp.StartsWith("priv"))
            {
                tmp2 = "," + tmp + "='" + Request[tmp] + "'";
            }
        }
        sql += tmp2.Substring(1);
		sql += " WHERE userid='" + Request["user"] + "'";
		activeConn = new SqlConnection(connStr);			
		comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;
		}
		dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;				
		}
		data = new DataSet();
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text += "** Error encountered updating user. **<br>" + e.Message + "<br>" + sql;
			Session["state"] = "edit_post_back";
			return;				
		}
		activeConn.Close();	
		Session["state"] = "edit_post_back";	
		message.Text = "** User information updated successfuly. **";
		return;				
	}

	private string clean(string src){
		return src.Replace("'","''");
	}

	//Returns a DataSet with all the user's current information.	
	private DataSet getUserData() {
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM users WHERE userid='" + Session["user"] + "'";
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		DataSet data = new DataSet();			
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error loading user data. **<br>" + e.Message;
			return data;							
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error loading user data. **<br>" + e.Message;
			return data;			
		}
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error loading user data. **<br>" + e.Message;
			return data;			
		}
		activeConn.Close();
		return data.Copy();
	}

	//If user information is found display it otherwise throw an error.		
	private void changeState(Object obj, EventArgs args) {
		if(Request["user"] != "") {
			Session["user"] = Request["user"];
			uData = getUserData();
			if(uData.Tables[0].Rows[0][0] == "") {
				Session["state"] = "select";
				message.Text = "** No data found for selected user. **";
				return;
			}else{
				Session["state"] = "edit";
				return;				
			}
		}else{
			Session["state"] = "select";
			message.Text = "** No user has been selected. **";
			return;
		}
		return;
	}

	//If user information is found display it otherwise throw an error.		
	private void changeState() {
		if(Request["jumpuser"] != "") {
			Session["user"] = Request["jumpuser"];
			message.Text = Request["text"];
			uData = getUserData();
			if(uData.Tables[0].Rows[0][0] == "") {
				Session["state"] = "select";
				message.Text = "** No data found for selected user. **";
				return;
			}else{
				Session["state"] = "edit";
				return;				
			}
		}else{
			Session["state"] = "select";
			message.Text = "** No user has been selected. **";
			return;
		}
		return;
	}

	//Generic function for accessing MS SQL information.	
	private DataSet getMssqlData(string s) {
		DataSet data = new DataSet();
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		SqlDataAdapter adpt = new SqlDataAdapter(s, connStr);
		try {
			adpt.Fill(data); 
		}catch(Exception e) {
			message.Text += "<center>** There was an error connecting to " + Session["auditserver"] + ". **</center><br>" + e.Message + "<br>";
			throw(e);
		}	     
		return data;
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
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Edit User&nbsp;</font></td>
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
	<td>
<% if(Session["state"] == "select") { %>
			<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
			<tr>
				<td align="right" width="35%"><font class="black">User&nbsp;</font></td>
				<td align="left" width="65%"><select name="user">
				<%= printUserList() %>
				</select></td>
			</tr>
			<tr>
				<td align="center" colspan="2"><asp:button id="userselect" text="Next" runat="server" onClick="changeState" /></td>
			</tr>
			</table>
<% } 
if(Session["state"] == "edit") { %>
			<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
			<tr>
				<td align="right" width="50%"><font class="black">Active</font></td>
				<td width="50%">
				<input type="hidden" name="user" value="<%= Request["user"] %>">
				<select name="active">
				<% if(uData.Tables[0].Rows[0]["active"].ToString() == "1") { %>
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
			<% if(uData.Tables[0].Rows[0]["account_type"].ToString() == "Intern") { %>
				<option value="">SELECT ONE</option>
				<option value="Admin">Admin</option>
				<option selected value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(uData.Tables[0].Rows[0]["account_type"].ToString() == "Admin") { %>
				<option value="">SELECT ONE</option>
				<option selected value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(uData.Tables[0].Rows[0]["account_type"].ToString() == "Representative") { %>
				<option value="">SELECT ONE</option>	
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option selected value="Representative">Representative</option>
				<option value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(uData.Tables[0].Rows[0]["account_type"].ToString() == "Webmaster") { %>
				<option value="">SELECT ONE</option>	
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
				<option selected value="Webmaster">Webmaster</option>
				<option value="Customer">Customer</option>
			<% }else if(uData.Tables[0].Rows[0]["account_type"].ToString() == "Customer") { %>
				<option value="">SELECT ONE</option>	
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
				<td><input type="text" name="name" size="20" maxlength="50" value="<%= uData.Tables[0].Rows[0]["name"].ToString() %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black">Address</font><font class="red">*</font></td>
				<td><input type="text" name="address" size="30" maxlength="50" value="<%= uData.Tables[0].Rows[0]["address"].ToString() %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black" align="right">Phone</font><font class="red">*</font></td>
				<td><input type="text" name="phone" size="10" maxlength="10" value="<%= uData.Tables[0].Rows[0]["phone"].ToString() %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black" align="right">Email Address</font><font class="red">*</font></td>
				<td><input type="text" name="emailaddress" size="30" maxlength="100" value="<%= uData.Tables[0].Rows[0]["emailaddress"].ToString() %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black" align="right">Password</font><font class="red">*</font></td>					
				<td><input type="text" name="password1" size="20" maxlength="50" value="<%= uData.Tables[0].Rows[0]["password"].ToString() %>" disabled>
					<input type="hidden" name="pword1" value="<%= uData.Tables[0].Rows[0][6].ToString() %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black" align="right">Re-Type Password</font><font class="red">*</font></td>					
				<td><input type="text" name="password2" size="20" maxlength="50" value="<%= uData.Tables[0].Rows[0]["password"].ToString() %>" disabled>
					<input type="hidden" name="pword2" value="<%= uData.Tables[0].Rows[0][6].ToString() %>"></td>
			</tr>			
			<tr>
				<td align="right"><font class="black">Username</font><font class="red">*</font></td>					
				<td><input type="text" name="username" size="20" maxlength="50" value="<%= uData.Tables[0].Rows[0]["username"].ToString() %>"></td>
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
			for(int i = 0; i < cols.Tables[0].Columns.Count; i++) {
				tmp = cols.Tables[0].Columns[i].ToString();
				if(tmp.StartsWith("priv")) {
					sht = tmp.Replace("priv_",""); %>
				<tr>					
					<td align="right" width="50%"><font class="black"><%= sht %>:</font></td>					
					<td width="50%"><select name="<%= tmp %>">
					<% if(uData.Tables[0].Rows[0][i].ToString() == "1") { %>
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
				<td align="center" colspan="2"><asp:button id="updatesubmit" text="Update" runat="server" onClick="updateUser"/></td>
			</tr>			
			</table>
<% }
if(Session["state"] == "edit_post_back") { %>
			<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
			<tr>
				<td align="right" width="50%"><font class="black">Active</font></td>
				<td width="50%">
				<input type="hidden" name="user" value="<%= Request["user"] %>">				
				<select name="active">
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
			<% }else if(Request["account_type"] == "Admin") { %>
				<option selected value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
			<% }else if(Request["account_type"] == "Representative") { %>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option selected value="Representative">Representative</option>
			<% }else{ %>
				<option value="">SELECT ONE</option>
				<option value="Admin">Admin</option>
				<option value="Intern">Intern</option>
				<option value="Representative">Representative</option>
			<% } %>
				</select></td>
		</tr>
			<tr>
				<td align="right"><font class="black" align="right">Name</font><font class="red">*</font></td>					
				<td><input type="text" name="name" size="20" maxlength="50" value="<%= Request["name"] %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black">Address</font><font class="red">*</font></td>
				<td><input type="text" name="address" size="40" maxlength="50" value="<%= Request["address"] %>"></td>
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
				<td align="right"><font class="black" align="right">Password</font><font class="red">*</font></td>					
				<td><input type="text" name="password1" size="20" maxlength="50" value="<%= Request["pword1"] %>" disabled>
					<input type="hidden" name="pword1" value="<%= Request["pword1"] %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black" align="right">Re-Type Password</font><font class="red">*</font></td>					
				<td><input type="text" name="password2" size="20" maxlength="50" value="<%= Request["pword2"] %>" disabled>
					<input type="hidden" name="pword2" value="<%= Request["pword2"] %>"></td>
			</tr>
			<tr>
				<td align="right"><font class="black">Username</font><font class="red">*</font></td>					
				<td><input type="text" name="username" size="20" maxlength="50" value="<%= Request["username"] %>"></td>
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
				<td align="center" colspan="2"><asp:button id="updatesubmitpostback" text="Update" runat="server"  onClick="updateUser" /></td>
			</tr>
			</table>
<% } %>
</td></tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>