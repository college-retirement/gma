<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script language="C#" runat="server">
		
	public void Page_Load() {
		//Check to see if the session is still alive otherwise redirect.
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}
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
		//Response.Write(dt.Tables.Count + "");
		return dt;
	}

	private void updateDB(Object sender, EventArgs e) {
		//Response.Write("sssssssssssss" + Request["id"]);
		//if (Request["id"] == null) { return; }

		string[] ids;
		if (Request["id"] != null) {
			ids = Request["id"].Split(','); 
		} else { 
			//Response.Write("DELETE FROM productSet WHERE claimid = '" + Session["id"] + "'");
			getMssqlData("DELETE FROM productSet WHERE claimid = '" + Session["id"] + "'");
			return; 
		}

		string[] j = Request["i"].Split(',');

		DataSet tmp;
		for(int i = 0; i < j.Length; i++) {
//		for(int i = 0; i < ids.Length; i++) {

			if ( in_array(ids, i.ToString())) {

//			tmp = getMssqlData("SELECT * FROM productSet WHERE claimid = '" + Session["id"] + "' AND productid = '" + ids[i] + "'");
			tmp = getMssqlData("SELECT * FROM productSet WHERE claimid = '" + Session["id"] + "' AND productid = '" + i + "'");
			if(tmp.Tables.Count > 0) {
				if(tmp.Tables[0].Rows.Count > 0) {
//					Response.Write("UPDATE productSet SET inpkg='1', fyprem='" + Request["fyprem" + ids[i]] + "' WHERE claimid = '" + Session["id"] + "' AND productid = '" + ids[i] + "'<br>");
//					getMssqlData("UPDATE productSet SET inpkg='1', fyprem='" + Request["fyprem" + ids[i]] + "' WHERE claimid = '" + Session["id"] + "' AND productid = '" + ids[i] + "'");
					//Response.Write("UPDATE productSet SET inpkg='1', payment_received='" + Request["payrec" + i.ToString()] + "',payment_processed='" + Request["payproc" + i.ToString()] + "', fyprem='" + Request["fyprem" + i.ToString()] + "', tarprem='" + Request["tarprem" + i.ToString()] + "', compcomm='" + Request["compcomm" + i.ToString()] + "', exccomm='" + Request["exccomm" + i.ToString()] + "', repcomm='" + Request["repcomm" + i.ToString()] + "', repcommdate='" + Request["repcommdate" + i.ToString()] + "' WHERE claimid = '" + Session["id"] + "' AND productid = '" + i.ToString() + "'");
					getMssqlData("UPDATE productSet SET inpkg='1', payment_received='" + Request["payrec" + i.ToString()] + "',payment_processed='" + Request["payproc" + i.ToString()] + "', fyprem='" + Request["fyprem" + i.ToString()] + "', tarprem='" + Request["tarprem" + i.ToString()] + "', compcomm='" + Request["compcomm" + i.ToString()] + "', exccomm='" + Request["exccomm" + i.ToString()] + "', repcomm='" + Request["repcomm" + i.ToString()] + "', repcommdate='" + Request["repcommdate" + i.ToString()] + "' WHERE claimid = '" + Session["id"] + "' AND productid = '" + i.ToString() + "'");

				}else{
//					Response.Write("INSERT INTO productSet (claimid, productid, inpkg, payment_processed,fyprem) VALUES('" + Session["id"] + "','" + ids[i] + "','1','" + Request["payproc" + ids[i]] + "','" + Request["fyprem" + ids[i]] + "')<br>");
//					getMssqlData("INSERT INTO productSet (claimid, productid, inpkg, payment_processed,fyprem) VALUES('" + Session["id"] + "','" + ids[i] + "','1','" + Request["payproc" + ids[i]] + "','" + Request["fyprem" + ids[i]] + "')");
					//Response.Write("INSERT INTO productSet (claimid, productid, inpkg, payment_processed,fyprem) VALUES('" + Session["id"] + "','" + i.ToString() + "','1','" + Request["payproc" + ids[i]] + "','" + Request["fyprem" + i.ToString()] + "')<br>");
					getMssqlData("INSERT INTO productSet (claimid, productid, inpkg, payment_received, payment_processed, fyprem, tarprem, compcomm, exccomm, repcomm, repcommdate) VALUES('" + Session["id"] + "','" + i.ToString() + "','1','" + Request["payrec" + i.ToString()] + "','" + Request["payproc" + i.ToString()] + "','" + Request["fyprem" + i.ToString()]+ "','" + Request["tarprem" + i.ToString()]+ "','" + Request["compcomm" + i.ToString()]+ "','" + Request["exccomm" + i.ToString()]+ "','" + Request["repcomm" + i.ToString()]+ "','" + Request["repcommdate" + i.ToString()]+ "')");
				}
			}
			
			} else {

				//Response.Write("DELETE FROM productSet WHERE claimid = '" + Session["id"] + "' AND productid = '" + i.ToString() + "'");
				getMssqlData("DELETE FROM productSet WHERE claimid = '" + Session["id"] + "' AND productid = '" + i.ToString() + "'");
			}

		}
	}

	private Boolean in_array(string [] ids, string check) {
		for(int i=0; i < ids.Length; i++) {
			if (ids[i] == check) { return true; }
		}
		return false;
	}

	private void updateDBRep(Object sender, EventArgs e) {
		string sql = "";
		string[] accids = null;
		string[] payids = null;
		try {
			accids = Request["accepted"].Split(',');
			for(int i = 0; i < accids.Length; i++) {
				sql = "UPDATE productSet SET product_accepted = '1' WHERE claimid = '" + Session["id"] + "' AND productid = '" + accids[i] + "'";
				getMssqlData(sql);
			}
		}catch{

		}

		try {
			if(accids != null) {
				sql = "SELECT productid FROM productSet WHERE claimid = '" + Session["id"] + "'";
				DataSet data = getMssqlData(sql);
				bool found = false;
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					found = false;
					for(int j = 0; j < accids.Length; j++) {
						if(accids[j] == data.Tables[0].Rows[i]["productid"].ToString()) {
							found = true;
						}
					}
					if(!found) {
						sql = "UPDATE productSet SET product_accepted = '0' WHERE claimid = '" + Session["id"] + "' AND productid = '" + data.Tables[0].Rows[i]["productid"] + "'";
						getMssqlData(sql);
					}
				}
			}else{
				sql = "UPDATE productSet SET product_accepted = '0' WHERE claimid = '" + Session["id"] + "'";
				getMssqlData(sql);
			}
		}catch{
		}

		try {
			payids = Request["payment"].Split(',');
			for(int i = 0; i < payids.Length; i++) {
				sql = "UPDATE productSet SET payment_received = '1' WHERE claimid = '" + Session["id"] + "' AND productid = '" + payids[i] + "'";
				getMssqlData(sql);
			}
		}catch{

		}

		try {
			if(payids != null) {
				sql = "SELECT productid FROM productSet WHERE claimid = '" + Session["id"] + "'";
				DataSet data = getMssqlData(sql);
				bool found = false;
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					found = false;
					for(int j = 0; j < payids.Length; j++) {
						if(payids[j] == data.Tables[0].Rows[i]["productid"].ToString()) {
							found = true;
						}
					}
					if(!found) {
						sql = "UPDATE productSet SET payment_received = '0' WHERE claimid = '" + Session["id"] + "' AND productid = '" + data.Tables[0].Rows[i]["productid"] + "'";
						getMssqlData(sql);
					}
				}
			}else{
				sql = "UPDATE productSet SET payment_received = '0' WHERE claimid = '" + Session["id"] + "'";
				getMssqlData(sql);
			}
		}catch(Exception ex){
			Response.Write(ex.Message);
		}
	}

	</script>
<body>
<form runat="server">
<!--#include file="./images/case_review_menu/nav3.aspx"-->

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Sales Summary&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr class="grey">

			<td align="center">
			<% if(Session["account_type"].ToString().ToLower() == "admin") { %>

				<table cellspacing="0" cellpadding="3" align="center" bordercolor="Black" border="1" bgcolor="White" width="100%">
				<tr bgcolor="#4A3C8C">
					<td><font class="white">Product Name</font></td>
					<td align=center><font class="white">In Pkg.</font></td>
					<td align=center><font class="white">Pay Rec.</font></td>
					<td align=center><font class="white">Pay Proc.</font></td>
					<td align=center><font class="white">Y1 Prem.</font></td>
					<td align=center><font class="white">Tar Prem.</font></td>
					<td align=center><font class="white">MFAC Comm.</font></td>
					<td align=center><font class="white">Exc. Comm.</font></td>
					<td align=center><font class="white">Rep. Comm.</font></td>
					<td align=center><font class="white">Rep. Date</font></td>

				</tr>
				<% 
				string sql = "";
				DataSet tmp = getMssqlData("SELECT * FROM products");
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {

					sql = "SELECT * FROM productSet WHERE productid = '" + tmp.Tables[0].Rows[i]["id"] + "' AND claimid = '" + Session["id"] + "'";
					DataSet data = getMssqlData(sql);

					String fyprem 	= "";
					string tarprem 	= "";
					string compcomm 	= "";
					string repcomm	= "";
					string exccomm	= "";
					string repcommdate = "";
					string inpkgch 	= "";
					string payprocch	= "";
					string payrecch	= "";

					if (data.Tables[0].Rows.Count > 0) {
						fyprem = (String) data.Tables[0].Rows[0]["fyprem"].ToString();
						tarprem = (string) data.Tables[0].Rows[0]["tarprem"].ToString();
						compcomm = (string) data.Tables[0].Rows[0]["compcomm"].ToString();
						repcomm = (string) data.Tables[0].Rows[0]["repcomm"].ToString();
						exccomm = (string) data.Tables[0].Rows[0]["exccomm"].ToString();
						repcommdate = (string) data.Tables[0].Rows[0]["repcommdate"].ToString();
						if (data.Tables[0].Rows[0]["inpkg"].ToString() == "1") { inpkgch = "checked"; }
						if (data.Tables[0].Rows[0]["payment_received"].ToString() == "1") { payrecch = "checked"; }
						if (data.Tables[0].Rows[0]["payment_processed"].ToString() == "1") { payprocch = "checked"; }
					}

					if(i%2 == 0) { %>
						<tr bgcolor="#E7E7FF">
				<% 	}else{ %>
						<tr bgcolor="#F7F7F7">
				<%	} %>					
						<td><input type=hidden name=i value="<%= tmp.Tables[0].Rows[i]["id"] %>"><a style="text-decoration: none" target=new href="<%= tmp.Tables[0].Rows[i]["productURL"] %>"><font class="black"><%= tmp.Tables[0].Rows[i]["productName"] + " " + tmp.Tables[0].Rows[i]["productCode"] %></font></a></td>
						<td align=center><input type="checkbox" name="id" value="<%= tmp.Tables[0].Rows[i]["id"] %>" <%= inpkgch %>></td>
						<td align=center><input type="checkbox" name=payrec<%= tmp.Tables[0].Rows[i]["id"] %> value="1" <%= payrecch %>></td>
						<td align=center><input type="checkbox" name=payproc<%= tmp.Tables[0].Rows[i]["id"] %> value="1" <%= payprocch %>></td>
						<td align=center><input name=fyprem<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=4 value="<%= fyprem %>"></td>
						<td align=center><input name=tarprem<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=4 value="<%= tarprem %>"></td>
						<td align=center><input name=compcomm<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=4 value="<%= compcomm %>"></td>
						<td align=center><input name=exccomm<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=4 value="<%= exccomm %>"></td>
						<td align=center><input name=repcomm<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=4 value="<%= repcomm %>"></td>
						<td align=center><input name=repcommdate<%= tmp.Tables[0].Rows[i]["id"] %> type=text size=8 maxlength=10 maxsize=10 value="<%= repcommdate %>"></td>

					</tr>
				<% } %>
				</table>

				</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<font class="red">NOTE: Only products included in package are retained - removing a product will erase commission info.</font>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignProduct" runat="server" text="Update" onClick="updateDB" />
					</td>
				</tr>
			<% }else if(Session["account_type"].ToString().ToLower() == "representative") { %>
				<% DataSet tmp = getMssqlData("SELECT productset.*, products.*,products.id as pid FROM productset INNER JOIN products ON productid = products.id WHERE claimid = '" + Session["id"] + "'");
				if(tmp.Tables[0].Rows.Count > 0) { %>
					<table cellspacing="0" cellpadding="3" align="center" bordercolor="Black" border="1" bgcolor="White" width="100%">
					<tr bgcolor="#4A3C8C">
						<td><font class="white">Product Name</font></td>
						<td><font class="white">Y1 Premium</font></td>
						<td><font class="white">Product Accepted</font></td>
						<td><font class="white">Payment Received</font></td>
					</tr>
				<%	for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {
						if(i%2 == 0) { %>
							<tr bgcolor="#E7E7FF">
				<% 		}else{ %>
							<tr bgcolor="#F7F7F7">
				<%		} %>					

						<% DataSet data = getMssqlData("SELECT * FROM productSet WHERE productid = '" + tmp.Tables[0].Rows[i]["pid"] + "' AND claimid = '" + Session["id"] + "'"); %>

						<td><a style="text-decoration: none" target=new href="<%= tmp.Tables[0].Rows[i]["productURL"] %>"><font class="black"><%= tmp.Tables[0].Rows[i]["productName"] + " " + tmp.Tables[0].Rows[i]["productCode"] %></font></a></td>
						<td><font class="black"><%= data.Tables[0].Rows[0]["fyprem"].ToString() %></font>&nbsp;</td>

						<td>

							<% if(data.Tables.Count > 0) {
								if(data.Tables[0].Rows.Count > 0) { 
									//Response.Write("ssssssssssssssssss" + data.Tables[0].Rows[0]["product_accepted"].ToString());
									if(data.Tables[0].Rows[0]["product_accepted"].ToString() == "1") { %>
										<input type="checkbox" name="accepted" value="<%= tmp.Tables[0].Rows[i]["pid"] %>" checked>
								<%	}else{ %>
										<input type="checkbox" name="accepted" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
								<%	}
								}else{ %>
									<input type="checkbox" name="accepted" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
							<% 	}
							}else{ %>
								<input type="checkbox" name="accepted" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
							<% } %>
						</td>
						<td>
						<%
							//data = getMssqlData("SELECT * FROM productSet WHERE productid = '" + tmp.Tables[0].Rows[i]["pid"] + "' AND claimid = '" + Session["id"] + "'"); %>
							<% if(data.Tables.Count > 0) {
								if(data.Tables[0].Rows.Count > 0) {
									if(data.Tables[0].Rows[0]["payment_received"].ToString() == "1") { %>
										<input type="checkbox" name="payment" value="<%= tmp.Tables[0].Rows[i]["pid"] %>" checked>
								<%	}else{ %>
										<input type="checkbox" name="payment" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
								<%	}
								}else{ %>
									<input type="checkbox" name="payment" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
							<% 	}
							}else{ %>
								<input type="checkbox" name="payment" value="<%= tmp.Tables[0].Rows[i]["pid"] %>">
							<% } %>
						</td>
					</tr>
				<% } %>
				</table>

				</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="relateProduct" runat="server" text="Update" onClick="updateDBRep" />
					</td>
				</tr>
				<% }else{ %>
					<font class="black">There are no products assigned to this case.</font>
				<% } %>
<% } %>
		</table>
	</td>
</tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>