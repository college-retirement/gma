<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Timers" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">
	DataSet temp;

	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}

		//string sql = "SELECT notes.*,users.name FROM notes INNER JOIN users on users.userid = notes.createdBy WHERE claimid = '" + Session["id"] + "' AND admin IN ";
		string sql = "SELECT cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Creation Date], notes.note as [Comment],users.name as [Name] FROM notes INNER JOIN users on users.userid = notes.createdBy WHERE claimid = '" + Session["id"] + "' AND NOT note IS NULL AND note <> '' AND admin IN ";
		if(Session["account_type"].ToString().ToLower() == "admin") {
			sql += "('Y','N')";
		}else{
			sql += "('N')";
		}
		sql += " ORDER BY notes.id DESC;";
		temp = getMssqlData(sql);
		dview.DataSource = temp.Tables[0].DefaultView;
		dview.DataBind();

		message.Text = "";
	}

	private string clean(string src){
		return src.Replace("'","''");
	}

	//Generic data access function for querying SQL databases
	private DataSet getMssqlData(string s) {
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];

		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(s, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error encountered adding user. **<br>" + e.Message + "<br>";
			throw(e);
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error encountered adding user. **<br>" + e.Message + "<br>";
			throw(e);
		}
		DataSet data = new DataSet();
	
		//fills the dataset with payor information
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error encountered adding user. **<br>" + e.Message + "<br>";
			throw(e);
		}
		activeConn.Close();

		return data;
	}


	private void addComment(Object o, EventArgs e) {
		if(Request["comm"] == "" || Request["comm"] == null) {
			message.Text = "** No comment entered. **";
			return;
		}

		int id = 1;
		string sql = "SELECT MAX([id]) FROM notes;";
		DataSet tmp = getMssqlData(sql);
		try {
			id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
			id++;
		}catch{
			id = 1;
		}

		sql = "INSERT INTO notes (id,note,claimid,createdBy,createdDate,admin) VALUES(" + id + ",'" + clean(Request["comm"]) + "','" + Session["id"] + "','" + Session["userid"] + "','" + System.DateTime.Now.ToShortDateString() + "','";
		if(Session["account_type"].ToString().ToLower() == "admin") {
			if(Request["admin"] != "" && Request["admin"] != null && Request["admin"].ToLower() == "on") {
				sql += "Y');";
			}else{
				sql += "N');";
			}
		}else{
			sql += "N');";
		}
		getMssqlData(sql);

        sql = "SELECT cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Creation Date], notes.note as [Comment],users.name as [Name] FROM notes INNER JOIN users on users.userid = notes.createdBy WHERE claimid = '" + Session["id"] + "' AND NOT note IS NULL AND note <> '' AND admin IN ";
        if (Session["account_type"].ToString().ToLower() == "admin")
        {
            sql += "('Y','N')";
        }
        else
        {
            sql += "('N')";
        }
        sql += " ORDER BY notes.id DESC;";
        temp = getMssqlData(sql);
        dview.DataSource = temp.Tables[0].DefaultView;
        dview.DataBind();
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<!--#include file="./images/case_review_menu/nav5.aspx"-->
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<!--
<tr class="red">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td><font class="whitesm">Upload Utility&nbsp;</font></td>
		</tr></table>
	</td>
</tr>
-->
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr>
			<td align="center" colspan="2"><font class="black">Comment:</font></td>
		</tr>
		<% if(Session["account_type"].ToString().ToLower() == "admin") { %>
		<tr>
			<td align="center" colspan="2">
				<font class="blacksm">Only viewable by administrators:</font>&nbsp;<input type="checkbox" name="admin">
			</td>
		</tr>
		<% } %>
		<tr>
			<td colspan="2" align="center">
<textarea cols="70" rows="7" name="comm"></textarea>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2"><asp:button id="addcomment" text="Add Comment" runat="server" onClick="addComment"/></td>
		</tr>
		<tr height="15">
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
			<font class="black">Existing Comments:</font>
			</td>
		</tr>
		<tr class="grey">
			<td colspan="2" align="center">
			<%	
				//string html = "";
				if(temp.Tables.Count > 0) {
					if(temp.Tables[0].Rows.Count > 0) { %>
                <asp:DataList Width="100%" ID="dview" runat="server" BorderColor="White" BorderStyle="Solid" BorderWidth="1">
                    <HeaderTemplate>
                        <table bgcolor="white" style="font-family:Arial; font-size:9pt" width="100%" cellpadding="3" cellspacing="0" border="0">
                            <tr bgcolor="#4A3C8C" style="color:#F7F7F7; font-weight:bold;">
                                <td style="border:solid 1px white;">Creation Date</td>
                                <td style="border:solid 1px white;">Comment</td>
                                <td style="border:solid 1px white;">Name</td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                            <tr bgcolor="#f7f7f7">
                                <td style="border-right: solid 1px white;">
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Creation Date") %>'></asp:Label>
                                </td>
                                <td style="border-right: solid 1px white;">
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("Comment") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                </td>
                            </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                            <tr bgcolor="#E7E7FF">
                                <td style="border-right: solid 1px white;">
                                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("Creation Date") %>'></asp:Label>
                                </td>
                                <td style="border-right: solid 1px white;">
                                    <asp:Label ID="Label5" runat="server" Text='<%# Eval("Comment") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label6" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                </td>
                            </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:DataList><br />

			<%		}else{ %>
						<font class="black">The are no comments for this claim.</font>
			<%		}
				}else{ %>
					<font class="black">There are no comments for this claim.</font>
			<%	} %>
			</td>
		</tr>
		</table>
	</td>
</tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>