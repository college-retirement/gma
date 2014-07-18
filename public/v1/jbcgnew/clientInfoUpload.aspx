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

		temp = getMssqlData("SELECT tstamp as [Time Stamp], filename as [File Name], filesize as [Size], username as [Uploaded By], description as [Description] FROM clientuploadlog WHERE claimid='" + Session["id"] + "' ORDER BY tstamp ASC");
		if(!Page.IsPostBack) {
			dataView.DataSource = temp.Tables[0].DefaultView;
			dataView.DataBind();
		}
		message.Text = "";
		checkDirs();
	}

	public string getFileFromPath(string path) {
		string[] tmp; 
		string file = "";
		tmp = path.ToString().Split('\\');
		file = tmp[(tmp.Length - 1)];
		return file;
	}

	public void checkDirs() {
		System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info");
	}


	//Generic data access function for querying SQL databases
	private DataSet getMssqlData(string s) {
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];

		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(s, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error encountered querying the database. **<br>" + e.Message + "<br>";
			throw(e);
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error encountered querying the database. **<br>" + e.Message + "<br>";
			throw(e);
		}
		DataSet data = new DataSet();
	
		//fills the dataset with payor information
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error encountered querying the database. **<br>" + e.Message + "<br>";
			throw(e);
		}
		activeConn.Close();

		return data;
	}

	private void UploadFile(Object obj, EventArgs args) {
		string file;
		string sql = "";
		// System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"]);
		System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Session["id"]);
		if(file1.PostedFile != null && file1.PostedFile.FileName != "") {
			file = file1.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				//file1.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + file);
				file1.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "\\" + file);

				//if(Request["payauth"] != "" && Request["payauth"] != null && Request["payauth"].ToLower() == "on") {
				//	getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file1','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file1.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','Payment Authorization')");
				//}else{
					getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file1','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file1.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','" + Request["desc1"] + "')");
				//}
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file1.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
			//if(Request["payauth"] != "" && Request["payauth"] != null && Request["payauth"].ToLower() == "on") {
			//	sql = "UPDATE mfac_client_data SET status = 'Payment Authorized', payment_authorizationBy = '" + Session["userid"] + "', payment_authorizationDate = '" + System.DateTime.Now.ToShortDateString() + "' WHERE id='" + Session["id"] + "';";
			//	getMssqlData(sql);	
			//	message.Text += "**Case status set to AUTHORIZED.**";
			//}
		}
		//else{
		//	if(Request["payauth"] != "" && Request["payauth"] != null && Request["payauth"].ToLower() == "on") {
		//		sql = "UPDATE mfac_client_data SET status = 'Payment Authorized', payment_authorizationBy = '" + Session["userid"] + "', payment_authorizationDate = '" + System.DateTime.Now.ToShortDateString() + "' WHERE id='" + Session["id"] + "';";
		//		getMssqlData(sql);
		//		message.Text = "**Case status set to AUTHORIZED.**";	
		//	}
		//}
		if(file2.PostedFile != null && file2.PostedFile.FileName != "") {
			file = file2.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				//System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Request["client"]);
				// file2.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + file);
				file2.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "\\" + file);

				getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file2','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file2.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','" + Request["desc2"] + "')");
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file2.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}

		}
		if(file3.PostedFile != null && file3.PostedFile.FileName != "") {
			file = file3.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				//System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Request["client"]);
				// file3.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + file);
				file3.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "\\" + file);

				file = getFileFromPath(file);
				getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file3','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file3.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','" + Request["desc3"] + "')");
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file3.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
		}
		if(file4.PostedFile != null && file4.PostedFile.FileName != "") {
			file = file4.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				//System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Request["client"]);
				file4.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + file);
				file4.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "\\" + file);

				file = getFileFromPath(file);
				getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file4','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file4.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','" + Request["desc4"] + "')");
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file4.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
		}
		if(file5.PostedFile != null && file5.PostedFile.FileName != "") {
			file = file5.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				//System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "client_info\\" + Request["client"]);
				// file5.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + file);
				file5.PostedFile.SaveAs(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "\\" + file);
				file = getFileFromPath(file);
				getMssqlData("INSERT INTO clientuploadlog (slot, tstamp, filename, filesize, username, claimid, description) VALUES('file5','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file5.PostedFile.ContentLength + " bytes','" + Session["username"] + "_" + Request["client"] + "','" + Session["id"] + "','" + Request["desc5"] + "')");
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file5.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
		}

		temp = getMssqlData("SELECT tstamp as [Time Stamp], filename as [File Name], filesize as [Size], username as [Uploaded By], description as [Description] FROM clientuploadlog WHERE claimid='" + Session["id"] + "' ORDER BY tstamp ASC");
		dataView.DataSource = temp.Tables[0].DefaultView;
		dataView.DataBind();				
		return;		
	}

	private void download(Object sender, DataGridCommandEventArgs e) {
		//Response.Write(Session["userrootdir"].ToString() + "client_info\\" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "\\" + e.Item.Cells[2].Text.Trim());
		//Response.Redirect(Session["serverroot"].ToString() + "userfolders/client_info/" + Session["id"] + "_" + Session["client_last_name"] + "_" + Session["client_first_name"] + "/" + e.Item.Cells[2].Text.Trim());
		Response.Redirect(Session["serverroot"].ToString() + "userfolders/client_info/" + Session["id"] + "/" + e.Item.Cells[2].Text.Trim());
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<!--#include file="./images/case_review_menu/nav7.aspx"-->
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<!--
<tr class="red">
	<td>
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
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
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center" colspan="4">
			<%
				//temp = getMssqlData("SELECT [id],client_last_name,client_first_name FROM mfac_client_data2 WHERE id='" + Session["id"] + "';");
				temp = getMssqlData("SELECT [id] FROM mfac_client_data2 WHERE id='" + Session["id"] + "';");
				// hidden fields
				// temp.Tables[0].Rows[0]["id"] + "_" + temp.Tables[0].Rows[0]["client_last_name"] + "_" + temp.Tables[0].Rows[0]["client_first_name"] 
			%>
				<input type="hidden" name="client" value="<%= temp.Tables[0].Rows[0]["id"] %>">
				<font class="black">Upload Files:</font>
			</td>
		</tr>
		<tr>
			<td align="right"><font class="blacksm">File 1:</font></td>
			<td><input type="file" id="file1" name="file1" size="35" runat="server"></td>
			<td><font class="blacksm">Description</font></td>
			<td><input type="text" name="desc1" size="30" maxlength="50"></td>
		</tr>
		<!--
		<tr>
			<td colspan="2" align="right"><font class="black">Check if payment has been authorized.</font></td>
			<td colspan="2"><input type="checkbox" name="payauth"></td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		-->
		<tr>
			<td align="right"><font class="blacksm">File 2:</font></td>
			<td><input type="file" id="file2" name="file2" size="35" runat="server"></td>
			<td><font class="blacksm">Description</font></td>
			<td><input type="text" name="desc2" size="30" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"><font class="blacksm">File 3:</font></td>
			<td><input type="file" id="file3" name="file3" size="35" runat="server"></td>
			<td><font class="blacksm">Description</font></td>
			<td><input type="text" name="desc3" size="30" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"><font class="blacksm">File 4:</font></td>
			<td><input type="file" id="file4" name="file4" size="35" runat="server"></td>
			<td><font class="blacksm">Description</font></td>
			<td><input type="text" name="desc4" size="30" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right"><font class="blacksm">File 5:</font></td>
			<td><input type="file" id="file5" name="file5" size="35" runat="server"></td>
			<td><font class="blacksm">Description</font></td>
			<td><input type="text" name="desc5" size="30" maxlength="50"></td>
		</tr>
		<tr>
			<td align="center" colspan="4"><asp:button id="uploadsubmit" text="Upload" runat="server" onClick="UploadFile"/></td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center"><font class="black">Upload History:</font></td>
		</tr>
		<tr>
			<td colspan="4" class="grey" align="center" width="90%">
		<% 
			temp = getMssqlData("SELECT tstamp as [Time Stamp], filename as [File Name], filesize as [Size], username as [Uploaded By], description as [Description] FROM clientuploadlog WHERE claimid='" + Session["id"] + "' ORDER BY tstamp ASC");
			if(temp.Tables.Count > 0) {
				if(temp.Tables[0].Rows.Count > 0) {
					//dataView.DataSource = temp.Tables[0].DefaultView;
					//dataView.DataBind();
				%>

				<ASP:Datagrid 
				id="dataView" 
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
				width = "100%"
				Font-Size = "9pt"
				Font-Name = "Arial"
				OnEditCommand="download"
				>
				<columns>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Download"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>

			<%	}else{ %>
					<font class="black">There are no logged uploads.</font>
				 <% }
			}else { %>
				<font class="black">There are no logged uploads.</font>
			<% } %>

			</font></td>
		</tr>
		</table>
	</td>
</tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>