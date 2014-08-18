<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
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
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() != "admin") {
			Response.Redirect("./nopriv.aspx");
		}
		message.Text = "";
		Session["state"] = "first";

		/*
		if(Request["repair"] == "on") {
			getMssqlData("ALTER TABLE mfac_family_info ADD uid INT IDENTITY");
			string sql = "SELECT claimid FROM mfac_family_info GROUP BY claimid ORDER BY claimid ASC";
			DataSet claimids = getMssqlData(sql);

			bool oneFound = false;
			int oneCount = 0;

			bool twoFound = false;
			int twoCount = 0;

			bool threeFound = false;
			int threeCount = 0;

			bool fourFound = false;
			int fourCount = 0;

			bool fiveFound = false;
			int fiveCount = 0;

			bool sixFound = false;
			int sixCount = 0;

			//soduku

			message.Text += "Found " + claimids.Tables[0].Rows.Count + " claimid's<br>\n";
			for(int i = 0; i < claimids.Tables[0].Rows.Count; i++) {
				sql = "SELECT * FROM mfac_family_info WHERE claimid = '" + claimids.Tables[0].Rows[i]["claimid"] + "' ORDER BY [ID] ASC";
				DataSet rowInfo = getMssqlData(sql);

				oneFound = false;
				oneCount = 0;
				twoFound = false;
				twoCount = 0;
				threeFound = false;
				threeCount = 0;
				fourFound = false;
				fourCount = 0;
				fiveFound = false;
				fiveCount = 0;
				sixFound = false;
				sixCount = 0;

				for(int j = 0; j < rowInfo.Tables[0].Rows.Count; j++) {
					DataRow drow = rowInfo.Tables[0].Rows[j];
					if(drow["id"].ToString() == "1") {
						oneFound = true;
						oneCount++;
					}else if(drow["id"].ToString() == "2") {
						twoFound = true;
						twoCount++;
					}else if(drow["id"].ToString() == "3") {
						threeFound = true;
						threeCount++;
					}else if(drow["id"].ToString() == "4") {
						fourFound = true;
						fourCount++;
					}else if(drow["id"].ToString() == "5") {
						fiveFound = true;
						fiveCount++;
					}else if(drow["id"].ToString() == "6") {
						sixFound = true;
						sixCount++;
					}
				}
				//message.Text += oneFound + " " + oneCount + " " + twoFound + " " + twoCount + "<br>\n";
				if(rowInfo.Tables[0].Rows.Count == 6) {
					if(sixFound == false && oneCount == 2 && oneFound == true) {
						//delete duplicate row one insert a row six
						if(rowInfo.Tables[0].Rows[0]["id"].ToString() == "1" && rowInfo.Tables[0].Rows[1]["id"].ToString() == "1") {
							if(rowInfo.Tables[0].Rows[0]["col0001"].ToString() == rowInfo.Tables[0].Rows[1]["col0001"].ToString() ) {
								//delete one row 1
								getMssqlData("DELETE FROM mfac_family_info WHERE [UID] = " + rowInfo.Tables[0].Rows[0]["uid"]);

								//insert a row six
								getMssqlData("INSERT INTO mfac_family_info (id,claimid) VALUES(6," + claimids.Tables[0].Rows[i]["claimid"].ToString() + ")");
							}
						}
					}
				}else if(rowInfo.Tables[0].Rows.Count == 7) {
					//delete duplicate row one
					if(sixFound == true && oneCount == 2 && oneFound == true) {
						//delete duplicate row one insert a row six
						if(rowInfo.Tables[0].Rows[0]["id"].ToString() == "1" && rowInfo.Tables[0].Rows[1]["id"].ToString() == "1") {
							if(rowInfo.Tables[0].Rows[0]["col0001"].ToString() == rowInfo.Tables[0].Rows[1]["col0001"].ToString() ) {
								//delete one row 1
								getMssqlData("DELETE FROM mfac_family_info WHERE [UID] = " + rowInfo.Tables[0].Rows[0]["uid"]);
							}
						}
					}
				}
			}
			getMssqlData("ALTER TABLE mfac_family_info DROP COLUMN uid");
		}
		*/
		
	}

	//If file exists delete it.
	private bool cycleFile(string doc) {
		//if it exists delete it
		if(System.IO.File.Exists(doc)) {
			try {
				System.IO.File.Delete(doc);
			}catch(Exception e) {
				message.Text += "<center>** The document " + doc + " is open in another window. Or is being used by another user. **</center><br>" + e.Message + "<br>";
				return false;
			}
		}
		return true;
	}

	//Generic data access function for querying SQL databases
	private DataSet getMssqlData(string s) {
		//Response.Write(s);
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
			//throw(e);
		}
		return dt;
	}

	private string selectBox(DataSet tmp, string target) {
		string html = "";
		bool found = false;
		string test = "" + target;
		test = test.Trim();
		for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {
			if(tmp.Tables[0].Rows[i]["id"].ToString() == test) {
				found = true;
				html += "<option selected value=\"" + tmp.Tables[0].Rows[i]["id"] + "\">" + tmp.Tables[0].Rows[i]["client_name"] + "</option>\n";
			}else{
				html += "<option value=\"" + tmp.Tables[0].Rows[i]["id"] + "\">" + tmp.Tables[0].Rows[i]["client_name"] + "</option>\n";
			}
		}
		if(found == false) {
			return "<option selected value=\"\">SELECT ONE</option>\n" + html;
		}else{
			return "<option value=\"\">SELECT ONE</option>\n" + html;
		}
	}

	private void genPresentationSeed(Object sender, EventArgs evnt) {
		string sql = "";
		DataSet cData = null;
		DataSet colleges = null;
		DataSet parents = null;
		DataSet family = null;
		DataSet tmp = null;
		System.IO.StreamWriter csvFile = null;

		if((Request["id"] == null || Request["id"] == "") && (Request["all"] == null || Request["all"] == "") ) {
			message.Text = "** A case must be selected. **<br>";
			return;
		}

		try {
			sql = "SELECT [id],userid,col0002,col0004,col0017,col0019,col0020,col0079,col0081,col0177,col0180,col0181,col0182";
			sql += ",col0201,col0203,col0205,col0208,col0210,col0212,col0215,col0217,col0219,col0222,col0224,col0226,col0229,col0231,col0233,col0236,col0237,col0238,col0239,col0240,col0241,col0243";
			sql += ",col0244,col0245,col0246,col0247,col0248,col0250,col0264,col0266,col0269,col0270,col0271,col0272,col0273,col0274,col0276,col0277,col0278,col0279,col0280,col0281,col0283,col0284,col0285,col0286,col0287,col0288,col0290";
			sql += ",col0291,col0292,col0293,col0294,col0295,col0297,col0299,col0301,col0304,col0306,col0308,col0311,col0312,col0313,col0314,col0315,col0316,col0318,col0324,col0326,col0329,col0331,col0333,col0336,col0338,col0340,col0343,col0344,col0345,col0346,col0347,col0348,col0350,col0351";
			sql += ",col0352,col0353,col0354,col0355,col0357,col0359,col0361,col0364,col0366,col0368,col0371,col0372,col0373,col0374,col0375,col0376,col0378,col0379,col0380,col0381,col0382,col0383";
			sql += ",col0384,col0385,col0389,col0390,col0391,col0393,col0394,col0395,col0397,col0398,col0399,col0400,col0401,col0402,col0443,col0444,col0446,col0447,col0449,col0450,col0452,col0453,col0454,col0455,col0456,col0457,col0458,col0459,col0386 FROM [" + Session["mainDataTable"] + "] WHERE status = 'Payment Authorized'";
			//sql = "SELECT * FROM [" + Session["mainDataTable"] + "] WHERE status = 'Payment Authorized'";
			if(Request["all"] != "on") {
				sql +=  " AND [id] = " + Request["id"] + ";";
			}
			//string guid = Guid.NewGuid().ToString();
            csvFile = new System.IO.StreamWriter(@"\hshome\madison\college-retirement.com\jbcgnew\temp\ps_" + Session["username"] + ".csv", false);
			
			cData = getMssqlData(sql);
			if(cData.Tables.Count == 0) {
				message.Text = "* No 'Payment Authorized' cases found. *";
				return;
			}else{
				if(cData.Tables[0].Rows.Count == 0) {
					message.Text = "* No 'Payment Authorized' cases found. *";
					return;
				}
			}
			for(int i = 0; i < cData.Tables[0].Rows.Count; i++) {

				for(int j = 0; j < cData.Tables[0].Columns.Count; j++) {
					if(cData.Tables[0].Columns[j].ToString().IndexOf("col") != -1) {
						sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE src_column = '" + cData.Tables[0].Columns[j] + "' AND input_field = 'Y';";
						tmp = getMssqlData(sql);
						string oCol = tmp.Tables[0].Rows[0]["col"].ToString();
						if(tmp.Tables[0].Rows[0]["col"].ToString() != "1") {
							sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE number = " + tmp.Tables[0].Rows[0]["number"] + " AND section = " + tmp.Tables[0].Rows[0]["section"] + " AND col = 1;";
							tmp = getMssqlData(sql);
							//Response.Write(tmp.Tables[0].Rows[0]["name"] + "");
							int test = Convert.ToInt32(tmp.Tables[0].Rows[0]["number"].ToString());
							if(test < 220 && test > 223) {
								if(oCol == "2") {
									csvFile.Write("\"Parents " + tmp.Tables[0].Rows[0]["name"] + "\"");
								}else{
									csvFile.Write("\"Non-College " + tmp.Tables[0].Rows[0]["name"] + "\"");
								}
							}else{
								csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
							}
						}else {
							//Response.Write(tmp.Tables[0].Rows[0]["name"] + "");
							csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
						}
						if( i < (cData.Tables[0].Columns.Count - 1) ) {
							csvFile.Write(",");
						}
					}else if(cData.Tables[0].Columns[j].ToString().ToLower() == "id" || cData.Tables[0].Columns[j].ToString().ToLower() == "userid") {
						csvFile.Write("\"" + cData.Tables[0].Columns[j] + "\"");				
						//Response.Write(cData.Tables[0].Columns[j] + "");
						if( i < (cData.Tables[0].Columns.Count - 1) ) {
							csvFile.Write(",");
						}
					}
				}
				csvFile.Write("\r\n");

				for(int j = 0; j < cData.Tables[0].Columns.Count; j++) {
					csvFile.Write("\"" + cData.Tables[0].Rows[i][j] + "\"");
					
					if(j < (cData.Tables[0].Columns.Count - 1)) {
						csvFile.Write(",");				
					}
				}
				csvFile.Write("\r\n");

				colleges = getMssqlData("SELECT col0001 FROM [" + Session["mainChoiceTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[i]["id"] + ";");
				//Response.Write("SELECT col0001 FROM [" + Session["mainChoiceTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[0]["id"] + ";");
				for(int j = 0; j < colleges.Tables[0].Rows.Count; j++) {
					sql = "SELECT name,number,section,col,src_id FROM [" + Session["mainDictTable"] + "] WHERE src_column = '" + colleges.Tables[0].Columns[0] + "' AND src_table = '" + Session["mainChoiceTable"] + "' AND src_id = " + (j + 1) + " AND col = 2;";
					tmp = getMssqlData(sql);
					csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "" + (j+1) + "\"");
					if( j < (colleges.Tables[0].Rows.Count - 1)) {
						csvFile.Write(",");
					}
				}
				csvFile.Write("\r\n");

				for(int j = 0; j < colleges.Tables[0].Rows.Count; j++) {
					csvFile.Write("\"" + colleges.Tables[0].Rows[j][0] + "\"");
					if( j < (colleges.Tables[0].Rows.Count - 1)) {
						csvFile.Write(",");
					}
				}
				csvFile.Write("\r\n");

				parents = getMssqlData("SELECT TOP 2 [id],col0001,col0002,col0003,col0004,col0005,col0006,col0007,col0008,col0009,col0010,col0011,col0012,col0013,col0014,col0015,col0016,col0017,col0018,col0019,col0020,col0021,col0022,col0023,col0024,col0025,col0026,col0027,col0028,col0029,col0030,col0031,col0032,col0033,col0034,col0035,col0036,col0037,col0038,col0039,col0040,col0041,col0042,col0043,col0044,col0045,col0046,col0047,col0048,col0049,col0050,col0051,col0052,col0053,col0054,col0055,col0056,col0057,col0058,col0059,col0060,col0061,col0062,col0063,col0064,col0065,col0066,col0067 FROM [" + Session["mainParentTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[i]["id"] + " AND [ID] IN (1,2);");
				for(int j = 0; j < parents.Tables[0].Columns.Count; j++) {
					if(parents.Tables[0].Columns[j].ToString().IndexOf("col") != -1) {
						sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE src_table = '" + Session["mainParentTable"] + "' AND src_column = '" + parents.Tables[0].Columns[j] + "' AND src_id = '1';";
						tmp = getMssqlData(sql);
						if(tmp.Tables[0].Rows.Count > 0) {
							if(tmp.Tables[0].Rows[0]["col"].ToString() != "1") {
								sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE number = " + tmp.Tables[0].Rows[0]["number"] + " AND section = " + tmp.Tables[0].Rows[0]["section"] + " AND col = 1;";
								tmp = getMssqlData(sql);
								csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
							}else{
								csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
							}
							if((j - 1) < parents.Tables[0].Columns.Count) {
								csvFile.Write(",");
							}
						}
					}else{
						csvFile.Write("\"" + parents.Tables[0].Columns[j] + "\"");
						if((j - 1) < parents.Tables[0].Columns.Count) {
							csvFile.Write(",");
						}
					}
				}
				csvFile.Write("\r\n");

				for(int j = 0; j < parents.Tables[0].Rows.Count; j++) {
					for(int z = 0; z < parents.Tables[0].Columns.Count; z++) {
						if((z - 1) < parents.Tables[0].Columns.Count) {
							csvFile.Write("\"" + parents.Tables[0].Rows[j][z] + "\",");
						}else{
							csvFile.Write("\"" + parents.Tables[0].Rows[j][z] + "\"");
						}
					}
					csvFile.Write("\r\n");
				}

				family = getMssqlData("SELECT * FROM [" + Session["mainFamilyTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[i]["id"] + ";");
				for(int j = 0; j < family.Tables[0].Columns.Count; j++) {
					if(family.Tables[0].Columns[j].ToString().IndexOf("col") != -1) {
						sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE src_table = '" + Session["mainFamilyTable"] + "' AND src_column = '" + family.Tables[0].Columns[j] + "' AND src_id = '1';";
						tmp = getMssqlData(sql);
						if(tmp.Tables[0].Rows.Count > 0) {
							if(tmp.Tables[0].Rows[0]["col"].ToString() != "1") {
								sql = "SELECT name,number,section,col FROM [" + Session["mainDictTable"] + "] WHERE number = " + tmp.Tables[0].Rows[0]["number"] + " AND section = " + tmp.Tables[0].Rows[0]["section"] + " AND col = 1;";
								tmp = getMssqlData(sql);
								csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
							}else{
								csvFile.Write("\"" + tmp.Tables[0].Rows[0]["name"] + "\"");
							}
							if((j - 1) < family.Tables[0].Columns.Count) {
								csvFile.Write(",");
							}
						}
					}else{
						csvFile.Write("\"" + family.Tables[0].Columns[j] + "\"");
						if((j - 1) < family.Tables[0].Columns.Count) {
							csvFile.Write(",");
						}
					}
				}
				csvFile.Write("\r\n");

				for(int j = 0; j < family.Tables[0].Rows.Count; j++) {
					for(int z = 0; z < family.Tables[0].Columns.Count; z++) {
						if((z - 1) < family.Tables[0].Columns.Count) {
							csvFile.Write("\"" + family.Tables[0].Rows[j][z] + "\",");
						}else{
							csvFile.Write("\"" + family.Tables[0].Rows[j][z] + "\"");
						}
					}
					csvFile.Write("\r\n");
				}

			}
			csvFile.Flush();
			csvFile.Close();
			Session["state"] = "listlinks";
		}catch(Exception e){
			message.Text += e.Message + "<br>" + e.StackTrace;
			if(csvFile != null) {
				csvFile.Close();
			}
			return;
		}

/*
		try {				
			for(int i = 0; i < cData.Tables[0].Rows.Count; i++) {
				for(int j = 0; j < cData.Tables[0].Columns.Count; j++) {
					if(cData.Tables[0].Columns[j].ToString().IndexOf("col") != -1 || cData.Tables[0].Columns[i].ToString().ToLower() == "id") {
						csvFile.Write("\"" + cData.Tables[0].Rows[i][j] + "\",");
					}
				}

				//colleges = getMssqlData("SELECT TOP 12 col0001 FROM [" + Session["mainChoiceTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[i]["id"] + ";");
				for(int j = 0; j < colleges.Tables[0].Rows.Count; j++) {
					csvFile.Write("\"" + colleges.Tables[0].Rows[j][0] + "\",");
				}

				//parents = getMssqlData("SELECT TOP 2 col0060,col0059,col0058,col0057,col0056,col0055,col0054,col0053,col0049,col0048,col0047,col0046,col0045,col0044,col0043,col0042,col0041,col0040,col0039 FROM [" + Session["mainParentTable"] + "] WHERE claimid = " + cData.Tables[0].Rows[i]["id"] + ";");
				for(int j = 0; j < parents.Tables[0].Rows.Count; j++) {
					for(int z = 0; z < parents.Tables[0].Columns.Count; z++) {
						if((z - 1) < parents.Tables[0].Columns.Count) {
							csvFile.Write("\"" + parents.Tables[0].Rows[j][z] + "\",");
						}else{
							csvFile.Write("\"" + parents.Tables[0].Rows[j][z] + "\"");
						}
					}
				}
				csvFile.Write("\r\n");
			}
			csvFile.Flush();
			csvFile.Close();


		}catch(Exception e){
			message.Text += "<br>" + e.Message + "<br>" + e.StackTrace;
			if(csvFile != null) {
				csvFile.Close();
			}
		}
*/
	}

	//Gets the filename from a given path.
	public string getFileFromPath(string path) {
		string[] tmp; 
		string file = "";
		tmp = path.ToString().Split('\\');
		file = tmp[(tmp.Length - 1)];
		return file;
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">

<% if(Session["account_type"].ToString() == "Admin") { %>
	<!--#include file="./images/admin_menu/nav4.aspx"-->
<% } %>



<table border="1" cellpadding="2" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Generate Presentation Seed&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr>
<% if(Session["state"].ToString() == "first") { %>
	<tr>
	<td>
	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
	<tr>
		<td align="center" colspan="2"><select name="id">
			<%= selectBox(getMssqlData("SELECT a.[id], a.[col0004] + ',' + a.[col0002] AS [client_name] FROM [" + Session["mainDataTable"] + "] AS a INNER JOIN [" + Session["mainParentTable"] + "] AS b ON b.[claimid] = a.[ID] AND b.[ID] = 1 WHERE status = 'Payment Authorized' ORDER BY a.col0004 ASC;"), Request["id"]) %>
		</select>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2">
		<font class="blacksm">Generate All Matches</font>&nbsp;<input type="checkbox" name="all">
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2"><asp:button id="genSeed" text="Generate Seed" runat="server" onClick="genPresentationSeed"/></td>
	</tr>
	</table>
<% }else if(Session["state"].ToString() == "listlinks") { %>
	<tr class="grey">
	<td>
	<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr bgcolor="#4A3C8C"><td align="left" width="65%"><font class="whitesm">File Name</font></td><td align="left" width="35%"><font class="whitesm">Download</font></td></tr>
			<%
				string[] files;
                files = System.IO.Directory.GetFiles(@"\hshome\madison\college-retirement.com\jbcgnew\temp", "ps_*" + Session["username"].ToString() + "*.csv");
				
				//files = System.IO.Directory.GetFiles(@"D:\root\madison\madisonfinancialaid.com\www\jbcgNew\temp\", "ps_*" + Session["username"].ToString() + "*.csv");
				if(files.Length > 0) {
					string[] container;
					for(int i = 0; i < files.Length; i++) {
						container = files[i].Split('\\'); 
						if(i % 2 == 0) {%>
							<tr bgcolor="#E7E7FF">
						<% }else{ %>
							<tr bgcolor="#FFFFFF">
						<% } %>
						<td><font class="blacksm"><%= container[(container.Length - 1)] %></font></td>		
						<td><a href="<%= Session["docroot"] %><%= getFileFromPath(files[i]) %>">open</a></td></tr>
			<%	}
				}
			%>
		</td>
	</tr>
	</table>
<% } %>
	</td>
</tr></table>
</form>

<!--#include file="./footer.aspx"-->
</body></html>