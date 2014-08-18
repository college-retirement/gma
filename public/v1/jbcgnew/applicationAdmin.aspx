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
	DataSet temp;

	//gets run every time the screen refreshes on this page
	public void Page_Load() {
		message.Text = "";

		//checks to see if the session is still active when the page loads, tests the userid variable
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		//checks to see if the user has access to this page
		if(Session["priv_application_admin"].ToString() != "1" ) {
			Response.Redirect("./nopriv.aspx");
		}

		/*
		if(Request["accept"] != null && Request["accept"] != "") {
			int tmp = 0;
			string sql = "SELECT * FROM applications WHERE [id] = '" + Request["id"] + "';";
			DataSet data = getMssqlData(sql);
			sql = "INSERT INTO users (address,emailaddress,name,password,phone,username,account_creation_date,active,password_expiration_date,password_set_date)";
			sql += " VALUES('" + data.Tables[0].Rows[0]["address"] + "','" + data.Tables[0].Rows[0]["emailaddress"] + "','" + data.Tables[0].Rows[0]["name"] + "','" + data.Tables[0].Rows[0]["password"] + "','" + data.Tables[0].Rows[0]["phone"] + "','" + data.Tables[0].Rows[0]["username"] + "','" + System.DateTime.Now + "','0','" + System.DateTime.Now + "','" + System.DateTime.Now + "')";
			getMssqlData(sql);
			sql = "DELETE FROM applications WHERE [id] = '" + Request["id"] + "';";
			getMssqlData(sql);

			sql = "SELECT MAX(id) as mx FROM users";
			DataSet temp = getMssqlData(sql);

			message.Text += "The application has been accepted.  <br>You must go to the edit user page to activate the user's account and assign permissions.<br>";
			Response.Redirect("./edituser.aspx?jumpuser=" + temp.Tables[0].Rows[0]["mx"]);
			Session["
		}
	
		if(Request["decline"] != null && Request["decline"] != "") {
			string sql = "DELETE FROM applications WHERE [id] = '" + Request["id"] + "';";
			getMssqlData(sql);
			message.Text += "The application has been successfuly deleted.<br>";
		}
		*/

		if(!Page.IsPostBack) {
			string sql = "SELECT id as [ID],name as [Name],username [Username],phone [Phone Number] FROM applications;";
			temp = getMssqlData(sql);
			applications.DataSource = temp.Tables[0].DefaultView;
			applications.DataBind();
		}
	}

	private void manageApplication(Object sender, DataGridCommandEventArgs e) {
		Button b = (Button) e.CommandSource;
		//Response.Write(b.Text);
		string sql = "";
		if(b.Text == "Accept") {
			sql = "SELECT * FROM applications WHERE [id] = '" + e.Item.Cells[2].Text.Trim() + "';";
			DataSet data = getMssqlData(sql);
			sql = "INSERT INTO users (address,emailaddress,name,password,phone,username,account_creation_date,active,password_expiration_date,password_set_date)";
			sql += " VALUES('" + data.Tables[0].Rows[0]["address"] + "','" + data.Tables[0].Rows[0]["emailaddress"] + "','" + data.Tables[0].Rows[0]["name"] + "','" + data.Tables[0].Rows[0]["password"] + "','" + data.Tables[0].Rows[0]["phone"] + "','" + data.Tables[0].Rows[0]["username"] + "','" + System.DateTime.Now + "','0','" + System.DateTime.Now + "','" + System.DateTime.Now + "')";
			getMssqlData(sql);
			sql = "DELETE FROM applications WHERE [id] = '" + e.Item.Cells[2].Text.Trim() + "';";
			getMssqlData(sql);

			sql = "SELECT MAX(userid) as mx FROM users";
			data = getMssqlData(sql);

			message.Text += "The application has been accepted.  <br>You must go to the edit user page to activate the user's account and assign permissions.<br>";
			Response.Redirect("./edituser.aspx?jumpuser=" + data.Tables[0].Rows[0]["mx"] + "&text=The application has been accepted.  You must activate the account and assign permissions.");

			//message.Text += "The application has been accepted.  <br>You must go to the edit user page to activate the user's account and assign permissions.<br>";
			//Session["assign"] = e.Item.Cells[2].Text.Trim();
		}else if(b.Text == "Decline") {
			sql = "DELETE FROM applications WHERE [id] = '" + e.Item.Cells[2].Text.Trim() + "';";
			getMssqlData(sql);
			message.Text += "The application has been successfuly deleted.<br>";
			//Session["astate"] = "reassign";
			//Session["reassign"] = e.Item.Cells[2].Text.Trim();
		}
		sql = "SELECT id as [ID],name as [Name],username [Username],phone [Phone Number] FROM applications;";
		temp = getMssqlData(sql);
		applications.DataSource = temp.Tables[0].DefaultView;
		applications.DataBind();
	}
	
	/*
	private string printApplicationTable() {
		string sql = "SELECT name,username,phone,id FROM applications;";
		DataSet data = getMssqlData(sql);
		string html = "<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
		if(data.Tables.Count > 0) {
			if(data.Tables[0].Rows.Count > 0) {
				html += "<tr>\n";
				for(int i = 0; i < data.Tables[0].Columns.Count; i++) {
					if(data.Tables[0].Columns[i].ToString() != "id") {
						html += "<td>" + data.Tables[0].Columns[i].ToString() + "</td>";
					}
				}
				html += "<td>&nbsp;</td></tr>\n";
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					html += "<tr>\n";
					for(int j = 0; j < data.Tables[0].Columns.Count; j++) {
						if(data.Tables[0].Columns[j].ToString() != "id") {
							html += "<td>" + data.Tables[0].Rows[i][data.Tables[0].Columns[j].ToString()] + "</td>";
						}
					}
					html += "<td><form method=post><input type=\"hidden\" name=\"id\" value=\"" + data.Tables[0].Rows[i]["id"] + "\"><input runat=\"server\" type=\"submit\" name=\"accept\" value=\"Accept\">&nbsp;<input type=\"submit\" name=\"decline\" value=\"Decline\"></form></td>\n";
					html += "</tr>\n";
				}
				return html;
			}else{
				return "There are no open applications.<br>";
			}
		}else{
			return "There are no open applications.<br>";
		}
	}

	private void handleApplication(Object sender, EventArgs e) {
		Response.Write("handleAplication");
	}
	*/

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
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Application Admin&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>

		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>


				<% if(temp.Tables.Count > 0) {
					if(temp.Tables[0].Rows.Count > 0) { %>
						<tr>
							<td align="center"><font class="black">Open Applications</td>
						</tr>

					<tr>

					<td class="grey" align="center">
					<ASP:Datagrid 
						id="applications" 
						runat="server" 
						allowsorting="true" 
						AllowPaging="true" 
						PageSize="25" 
						PagerStyle-Visible="true" 
						HeaderStyle-BackColor="Blue" 
						HeaderStyle-ForeColor="White" 
						BorderColor="#000000" 
						BorderStyle="None" 
						BorderWidth="1px" 
						BackColor="White" 
						CellPadding="3"
						width="100%"
						OnEditCommand="manageApplication"
						Font-Size = "9pt"
						Font-Name = "Arial"
						>
						<columns>
							<asp:editcommandcolumn buttontype="PushButton" edittext="Accept"/>
							<asp:editcommandcolumn buttontype="PushButton" edittext="Decline"/>
						</columns>

						<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
						<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
						<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
						<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
						<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
					</asp:datagrid>
					<% }else{ %>
						<td class="grey" align="center">
						<font class="black">There are no open applications to view.</font>
					<% } %>
				<% }else{ %>
					<td class="grey" align="center">
					<font class="black">There are no open applications to view.</font>
				<% } %>
			</td>
		</tr>
		</table>
	</td>
</tr>



</table>
</form>

<!--#include file="./footer.aspx"-->

</body></html>