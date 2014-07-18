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
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		if(Session["priv_upload"].ToString() != "1") {
			Response.Redirect("./nopriv.aspx");
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
		System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "global_download");
		System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + Session["username"].ToString());
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

	private void UploadFile(Object obj, EventArgs args) {
		string file;
		if(file1.PostedFile != null && file1.PostedFile.FileName != "") {
			file = file1.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				file1.PostedFile.SaveAs(Session["userrootdir"].ToString() + Session["username"].ToString() + "\\" + file);

				//if(Request["java"] == "on") {
				//	file1.PostedFile.SaveAs(@"C:\inetpub\wwwroot\pharmdur\" + file);
				//}else{				
					//if(file.Length == 23) {
					//	if(file.Substring((file.Length - 3), 3) == "zip") {
					//		file1.PostedFile.SaveAs(Session["userrootdir"].ToString() + "field_audits\\" + file);
					//		string fp = Session["userrootdir"].ToString() + "field_audits\\" + file;
					//		getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file1','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file1.PostedFile.ContentLength + " bytes','" + Session["username"] + "','audit')");
					//	}else{
					//		getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file1','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file1.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
					//	}
					//}else{
						getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file1','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file1.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
					//}
				//}
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file1.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
		}
		if(file2.PostedFile != null && file2.PostedFile.FileName != "") {
			file = file2.PostedFile.FileName;
			try {
				// strip leading path from full filename
				string regstr = @"^.*\\";
				file = Regex.Replace(file,regstr,"");
				file2.PostedFile.SaveAs(Session["userrootdir"].ToString() + Session["username"].ToString() + "\\" + file);

				//if(Request["java"] == "on") {
					file2.PostedFile.SaveAs(@"C:\inetpub\wwwroot\pharmdur\" + file);
				//}else{
				//	if(file.Length == 23) {
				//		if(file.Substring((file.Length - 3), 3) == "zip") {
				//			file2.PostedFile.SaveAs(Session["userrootdir"].ToString() + "field_audits\\" + file);
				//			getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file2','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file2.PostedFile.ContentLength + " bytes','" + Session["username"] + "','audit')");
				//		}else{
				//			getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file2','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file2.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
				//		}
				//	}else{
						getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file2','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file2.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
				//	}
				//}
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
				file3.PostedFile.SaveAs(Session["userrootdir"].ToString() + Session["username"].ToString() + "\\" + file);
				file = getFileFromPath(file);

				//if(Request["java"] == "on") {
				//	file3.PostedFile.SaveAs(@"C:\inetpub\wwwroot\pharmdur\" + file);
				//}else{
				//	if(file.Length == 23) {
				//		if(file.Substring((file.Length - 3), 3) == "zip") {
				//			file3.PostedFile.SaveAs(Session["userrootdir"].ToString() + "field_audits\\" + file);
				//			getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file3','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file3.PostedFile.ContentLength + " bytes','" + Session["username"] + "','audit')");
				//		}else{
				//			getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file3','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file3.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
				//		}
				//	}else{
						getMssqlData("INSERT INTO uploadlog (slot, tstamp, filename, filesize, username, type) VALUES('file3','" + System.DateTime.Now + "','" + getFileFromPath(file) + "','" + file3.PostedFile.ContentLength + " bytes','" + Session["username"] + "','other')");
				//	}
				//}
				message.Text += "** File <b>" + file + "</b> uploaded succesfully " + "(" + file3.PostedFile.ContentLength + " bytes). **<br>";
			}catch(Exception exc) {
				message.Text += "** An error occured while attempting to upload " + file + " **<br>" + exc.Message + "<br>";
			}
		}				
		return;		
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">

<% if(Session["account_type"].ToString() == "Intern") { %>
	<!--#include file="./images/intern_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Representative") { %>
	<!--#include file="./images/rep_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Admin") { %>
	<!--#include file="./images/admin_menu/nav4.aspx"-->
<% } %>



<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Upload Utility&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="right"><font class="redsm">File 1:</font></td>
			<td><input type="file" id="file1" name="file1" size="40" runat="server"></td>
		</tr>
		<tr>
			<td align="right"><font class="redsm">File 2:</font></td>
			<td><input type="file" id="file2" name="file2" size="40" runat="server"></td>
		</tr>
		<tr>
			<td align="right"><font class="redsm">File 3:</font></td>
			<td><input type="file" id="file3" name="file3" size="40" runat="server"></td>
		</tr>
		<tr>
			<td align="center" colspan="2"><asp:button id="uploadsubmit" text="Upload" runat="server" onClick="UploadFile"/></td>
		</tr>
		</table>
	</td>
</tr></table>
</form>

<!--#include file="./footer.aspx"-->
</body></html>