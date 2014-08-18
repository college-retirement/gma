<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Web.Mail" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">
	private DataSet data;

	//gets run every time the screen refreshes on this page
	public void Page_Load() {
		message.Text = "";
		//checks to see if the session is still active when the page loads, tests the userid variable
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		//checks to see if the user has access to this page
		if( ! (Session["account_type"].ToString().ToLower() == "admin" || Session["account_type"].ToString().ToLower() == "representative") ) {
			Response.Redirect("./nopriv.aspx");
		}

		if(!Page.IsPostBack) {		
			Session["state"] = "section1db";
		}

		if(Request["sqlgen"] == "on") {
			//dumpSqlGen();
			return;
		}
		//Session["id"] = "1";
	}

	public void checkSection1Web(Object o, EventArgs e) {
		Button b = (Button) o;
		bool required = true;
		if(b.Text == "Update Section") {
			required = false;
		}
		string sql = "SELECT * FROM [" + Session["mainDictTable"] + "] WHERE section = '1' AND number <= 44 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		
		checkDataSimple(tmp, required);
		if(Session["state"].ToString() == "section1db") {
			Session["state"] = "section1web";
		}
		if(message.Text == "") {
			updateSection(1);			
			Session["student_last_name"] = Request["col0004"];
			Session["student_first_name"] = Request["col0002"];
			Session["home_phone"] = Request["col0013"];
			message.Text = "Update sucessful !";
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section1db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				Session["state"] = "section2db";
			}
		}
	}

	public void checkSection2Web(Object o, EventArgs e) {
		Button b = (Button) o;
		bool required = true;
		if(b.Text == "Update Section") {
			required = false;
		}
		string sql = "SELECT * FROM [" + Session["mainDictTable"] + "] WHERE section = '2' AND number between 45 AND 58 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp, required);
		if(Session["state"].ToString() == "section2db") {
			Session["state"] = "section2web";
		}
		if(message.Text == "") {
			updateSection(2);
			message.Text = "Update sucessful !";
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section1db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				Session["state"] = "section3db";
			}
		}
	}

	public void checkSection3Web(Object o, EventArgs e) {
		Button b = (Button) o;
		bool required = true;
		if(b.Text == "Update Section") {
			required = false;
		}
		string sql = "SELECT * FROM [" + Session["mainDictTable"] + "] WHERE section = '3' AND number between 59 AND 137 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp, required);
		if(Session["state"].ToString() == "section3db") {
			Session["state"] = "section3web";
		}
		if(message.Text == "") {
			updateSection(3);
			Session["client_last_name"] = Request["col0093"];
			Session["client_first_name"] = Request["col0091"];
			Session["parent_email_address"] = Request["col0107"];
			message.Text = "Update sucessful !";
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section2db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				Session["state"] = "section4db";
			}
		}
	}

	public void checkSection4Web(Object o, EventArgs e) {
		Button b = (Button) o;
		bool required = true;
		if(b.Text == "Update Section") {
			required = false;
		}
		string sql = "SELECT * FROM [" + Session["mainDictTable"] + "] WHERE section = '4' AND number between 138 AND 244 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp, required);
		if(Session["state"].ToString() == "section4db") {
			Session["state"] = "section4web";
		}
		if(message.Text == "") {
			updateSection(4);
			message.Text = "Update sucessful !";
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section3db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				Session["state"] = "section5db";
			}
		}
	}

	public void checkSection5Web(Object o, EventArgs e) {
		Button b = (Button) o;
		bool required = true;
		if(b.Text == "Update Section") {
			required = false;
		}
		string sql = "SELECT * FROM [" + Session["mainDictTable"] + "] WHERE section = '5' AND number between 244.1 AND 310 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp, required);
		if(Session["state"].ToString() == "section5db") {
			Session["state"] = "section5web";
		}
		if(message.Text == "") {
			updateSection(5);
			message.Text = "Update sucessful !";
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section4db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				Session["state"] = "section6db";
			}
		}
	}

	public void checkSection6Web(Object o, EventArgs e) {
		Button b = (Button) o;

		string sql = "SELECT userid, transactionBy FROM [" + Session["mainDataTable"] + "] WHERE id = '" + Session["id"] + "' AND status IN ('Assigned','Payment Authorized','Scheduled')";
		//Response.Write(sql);
		DataSet tmp = getMssqlData(sql);
		if(tmp.Tables.Count > 0) {
			if(tmp.Tables[0].Rows.Count > 0) {
				if(tmp.Tables[0].Rows[0]["userid"].ToString() != null && tmp.Tables[0].Rows[0]["userid"].ToString() != "") {

					sql = "UPDATE [" + Session["mainDataTable"] + "] SET pendingccc='" + Request["pendingccc"] + "', pendingcf='" + Request["pendingcf"] + "' WHERE id='" + Session["id"] + "';"; 
					getMssqlData(sql);

					if(Request["plan"] != "" && Request["plan_amount"] != "" && Request["amount_collected"] != "") {
						sql = "UPDATE [" + Session["mainDataTable"] + "] SET status = 'Payment Authorized', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "' WHERE id='" + Session["id"] + "';";
						getMssqlData(sql);

						sql = "SELECT * FROM planSet WHERE claimid = '" + Session["id"] + "'";
						tmp = getMssqlData(sql);
						if(tmp.Tables.Count > 0) {
							if(tmp.Tables[0].Rows.Count > 0) {
								sql = "UPDATE planSet SET planid = '" + Request["plan"] + "', plan_amount = " + Request["plan_amount"].Replace(",","") + ", amount_collected = " + Request["amount_collected"].Replace(",","") + ", payment_type = '" + Request["type"] + "' WHERE id = '" + tmp.Tables[0].Rows[0]["id"] + "'";
								getMssqlData(sql);
								message.Text = "The status of the case has been changed to 'Payment Authorized'.";
							}else{
								sql = "INSERT INTO planSet (claimid,planid,plan_amount,amount_collected,payment_type) VALUES('" + Session["id"] + "','" + Request["plan"] + "'," + Request["plan_amount"].Replace(",","") + "," + Request["amount_collected"].Replace(",","") + ",'" + Request["type"] + "');";
								getMssqlData(sql);
								message.Text = "The status of the case has been changed to 'Payment Authorized'.";
							}
						}else{
							sql = "INSERT INTO planSet (claimid,planid,plan_amount,amount_collected,payment_type) VALUES('" + Session["id"] + "','" + Request["plan"] + "'," + Request["plan_amount"].Replace(",","") + "," + Request["amount_collected"].Replace(",","") + ",'" + Request["type"] + "');";
							getMssqlData(sql);
							message.Text = "The status of the case has been changed to 'Payment Authorized'.";
						}


						string strTo = "info@madisonfinancialaid.com";
						string strFrom = "webapp@madisonfinancialaid.com";
						string strSubject = "MFAC Payment Authorization Notification";
						string msg = "\n\n";
						msg += "Student Name: " + Session["student_last_name"] + "," + Session["student_first_name"] + "\n";
						msg += "Parent Name: " + Session["client_last_name"] + "," + Session["client_first_name"] + "\n";
						msg += "Phone Number: " + Session["home_phone"] + "\n";
						msg += "Claim ID: " + Session["id"] + "\n";
						msg += "Email: " + Session["parent_email_address"] + "\n";
						try {
							SmtpMail.Send(strFrom, strTo, strSubject, msg);
						}catch(Exception ex) {
							message.Text += ex.Message;
							message.Text += ex.StackTrace;
							message.Text += "<br>**Notification email failed.**";
						}
						try {
							SmtpMail.Send(strFrom, "nziering@madisonfinancialaid.com", strSubject, msg);
							//SmtpMail.Send(strFrom, "jensen@jbcg.net", strSubject, msg);
						}catch(Exception ex) {
							message.Text += ex.Message;
							message.Text += ex.StackTrace;
							message.Text += "<br>**Notification email failed.**";
						}
					}
				}else{
					message.Text = "This status of the case cannot be changed to 'Payment Authorized' because it has not been assigned yet.";
				}
			}else{
				message.Text = "This status of the case cannot be changed to 'Payment Authorized' because it has not been assigned yet.";
			}
		}else{
			message.Text = "This status of the case cannot be changed to 'Payment Authorized' because it has not been assigned yet.";
		}


		if(message.Text == "") {
			//updateSection(tmp);
			if(b.ID.ToString().ToLower().IndexOf("prev") != -1) {
				Session["state"] = "section5db";
			}else if(b.ID.ToString().ToLower().IndexOf("next") != -1) {
				//Session["state"] = "section6db";
			}
		}
	}


	private void linkButtonCase(Object o, EventArgs e) {
		LinkButton b = (LinkButton) o;
		//Response.Write(b.ID.ToString().ToLower());
		//return;		

		if(b.ID.ToString().IndexOf("1") != -1 && b.ID.ToString().IndexOf("10") == -1) {
			Session["state"] = "section1db";
		}else if(b.ID.ToString().IndexOf("2") != -1) {
			Session["state"] = "section2db";
		}else if(b.ID.ToString().IndexOf("3") != -1) {
			Session["state"] = "section3db";
		}else if(b.ID.ToString().IndexOf("4") != -1) {
			Session["state"] = "section4db";
		}else if(b.ID.ToString().IndexOf("5") != -1) {
			Session["state"] = "section5db";
		}else if(b.ID.ToString().IndexOf("6") != -1) {
			Session["state"] = "section6db";
		}
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<!--#include file="./images/case_review_menu/nav1.aspx"-->

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<!--
<tr class="grey">
	<td>
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Manage Client Data&nbsp;</font></td>
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
<% if(Session["state"].ToString() == "section1web" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="onewebsection1" class="red" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onewebsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onewebsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onewebsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onewebsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onewebsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update1topweb" text="Update Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"></td>
			<td align="right">
				<asp:button id="next1topweb" text="Next Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<%= printForm(1, "web", 0.1 ,43) %>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="2">
			<font class="black">44.&nbsp;Student's College Selections</font>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">

			<table border="0" cellpadding="2" cellspacing="0" align="center" width="80%">
			<% 
				DataSet tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number = '44' AND section = '1' ORDER BY row ASC, col ASC;"); 
				DataSet data = getMssqlData("SELECT * FROM mfac_college_choice WHERE claimid = " + Session["id"] + ";");
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					%>
						<td>
					<%
						if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<font class="black"><%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}
						if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
							string test = "";
							try {
								test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
							}catch{
								test = "";
							}
					%>		
							<%= printInputField(tmp.Tables[0].Rows[i], test) %>
					<%
						}
					%>
						</td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "4") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update1bottomweb" text="Update Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"></td>
			<td align="right">
				<asp:button id="next1bottomweb" text="Next Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section1db" && Request["sqlgen"] != "on") { %>		
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="onedbsection1" class="red" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onedbsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onedbsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onedbsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onedbsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="onedbsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update1topdb" text="Update Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="right">
				<asp:button id="next1topdb" text="Next Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<%= printForm(1, "db", 0, 43) %>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="2">
			<font class="black">44.&nbsp;Student's College Selections</font>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">

			<table border="0" cellpadding="2" cellspacing="0" align="center" width="80%">
			<% 
				DataSet tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number = '44' AND section = '1' ORDER BY row ASC, col ASC;"); 
				DataSet data = getMssqlData("SELECT * FROM mfac_college_choice WHERE claimid = " + Session["id"] + " ORDER BY [id] ASC;");
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					%>
						<td>
					<%
						if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<font class="black"><%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}
						if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
							string test = "";
							try {
								test += data.Tables[0].Rows[Convert.ToInt32(tmp.Tables[0].Rows[i]["src_id"].ToString()) - 1][tmp.Tables[0].Rows[i]["src_column"].ToString()].ToString();
								//Response.Write(test + "<br>");
							}catch(Exception e){
								//Response.Write(e.Message + "<br>");
								test = "";
							}
					%>		
							<%= printInputField(tmp.Tables[0].Rows[i], test) %>
					<%
						}
					%>
						</td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "4") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"></td>
			<td align="right">
				<asp:button id="next1bottomdb" text="Next Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update1bottomdb" text="Update Section" runat="server" onClick="checkSection1Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section2web" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="twowebsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twowebsection2" class="red" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twowebsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twowebsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twowebsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twowebsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update2topweb" text="Update Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev2topweb" text="Prev Section" runat="server" onClick="checkSection2Web" />
			</td>
			<td align="right">
				<asp:button id="next2topweb" text="Next Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<%= printForm(2, "web", 44.1, 58) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev2bottomweb" text="Prev Section" runat="server" onClick="checkSection2Web" />
			</td>
			<td align="right">
				<asp:button id="next2bottomweb" text="Next Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update2bottomweb" text="Update Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section2db" && Request["sqlgen"] != "on") { %>		
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="twodbsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twodbsection2" class="red" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twodbsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twodbsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twodbsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="twodbsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update2topdb" text="Update Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev2topdb" text="Prev Section" runat="server" onClick="checkSection2Web" />
			</td>
			<td align="right">
				<asp:button id="next2topdb" text="Next Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<%= printForm(2, "db", 44.1, 58) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev2bottomdb" text="Prev Section" runat="server" onClick="checkSection2Web" />
			</td>
			<td align="right">
				<asp:button id="next2bottomdb" text="Next Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update2bottomdb" text="Update Section" runat="server" onClick="checkSection2Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section3web" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="threewebsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threewebsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threewebsection3" class="red" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threewebsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threewebsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threewebsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update3topweb" text="Update Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev3topweb" text="Prev Section" runat="server" onClick="checkSection3Web" />
			</td>
			<td align="right">
				<asp:button id="next3topweb" text="Next Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<%= printForm(3, "web", 58.1, 137) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev3bottomweb" text="Prev Section" runat="server" onClick="checkSection3Web" />
			</td>
			<td align="right">
				<asp:button id="next3bottomweb" text="Next Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update3bottomweb" text="Update Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section3db" && Request["sqlgen"] != "on") { %>		
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="threedbsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threedbsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threedbsection3" class="red" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threedbsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threedbsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="threedbsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update3topdb" text="Update Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev3topdb" text="Prev Section" runat="server" onClick="checkSection3Web" />
			</td>
			<td align="right">
				<asp:button id="next3topdb" text="Next Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<%= printForm(3, "db", 58.1, 137) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev3bottomdb" text="Prev Section" runat="server" onClick="checkSection3Web" />
			</td>
			<td align="right">
				<asp:button id="next3bottomdb" text="Next Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update3bottomdb" text="Update Section" runat="server" onClick="checkSection3Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section4db" && Request["sqlgen"] != "on") { 
		DataSet tmp = null;
		DataSet data = null;
		DataSet parentData = null;
%>		
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="fourdbsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourdbsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourdbsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourdbsection4" class="red" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourdbsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourdbsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update4topdb" text="Update Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev4topdb" text="Prev Section" runat="server" onClick="checkSection4Web" />
			</td>
			<td align="right">
				<asp:button id="next4topdb" text="Next Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<%= printForm(4, "db", 137.1, 163) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="115%">
			<tr>
				<td colspan="7" align="center">
					<font class="black">Asset Information Summary</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td colspan="2" align="center"><font class="blacksm">Parents</font></td>
				<td colspan="2" align="center"><font class="blacksm">Student</font></td>
				<td colspan="2" align="center"><font class="blacksm">Non-college siblings under 19</font></td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 164 AND 187 AND section = '4' ORDER BY row ASC, col ASC;"); 
				data = getMssqlData("SELECT * FROM mfac_client_data2 WHERE [id] = " + Session["id"] + ";");
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="20%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td>
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], data.Tables[0].Rows[0][tmp.Tables[0].Rows[i]["column_id"].ToString()].ToString()) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "7") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "db", 188, 206) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td colspan="3" align="center">
					<font class="black">Parents' Retirement Asset Information<br>
					Enter net asset value (asset value - asset debt)</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Parent #1</font></td>
				<td align="center"><font class="blacksm">Parent #2</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 207 AND 219 AND section = '4' ORDER BY row ASC, col ASC;"); 
				parentData = getMssqlData("SELECT * FROM mfac_parent_info WHERE [claimid] = " + Session["id"] + ";");
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
						string test = "";
						try {
							test += parentData.Tables[0].Rows[Convert.ToInt32(tmp.Tables[0].Rows[i]["src_id"].ToString()) - 1][tmp.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//Response.Write(test + "<br>");
						}catch(Exception e){
							//Response.Write(e.Message + "<br>");
							test = "";
						}
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], test) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td colspan="3" align="center">
					<font class="black">Parents' Debts</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Current Balance</font></td>
				<td align="center"><font class="blacksm">Monthly Payment</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 220 AND 223 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], data.Tables[0].Rows[0][tmp.Tables[0].Rows[i]["column_id"].ToString()].ToString()) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "db", 224, 229.1) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="95%">
			<tr>
				<td colspan="5" align="center">
					<font class="black">Life Insurance</font>
				</td>
			</tr>
			<tr>
				<td><br><font class="blacksm">Enter information about additional policies in the comments or special circumstances section at the end.</font></td>
				<td align="center" colspan="2"><font class="blacksm">Parent #1</font></td>
				<td align="center" colspan="2"><font class="blacksm">Parent #2</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 230 AND 236 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td>
					<%
						if(tmp.Tables[0].Rows[i]["number"].ToString().ToLower() == "231") {
					%>
							<font class="blacksm"><%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}else{
					%>
							<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
						string test = "";
						try {
							test += parentData.Tables[0].Rows[Convert.ToInt32(tmp.Tables[0].Rows[i]["src_id"].ToString()) - 1][tmp.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//Response.Write(test + "<br>");
						}catch(Exception e){
							//Response.Write(e.Message + "<br>");
							test = "";
						}
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], test) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "5") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "db", 237, 237.1) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td align="center"><font class="blacksm">Expense</font></td>
				<td align="center"><font class="blacksm">Parent #1</font></td>
				<td align="center"><font class="blacksm">Parent #2</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 238 AND 244 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
						string test = "";
						try {
							test += parentData.Tables[0].Rows[Convert.ToInt32(tmp.Tables[0].Rows[i]["src_id"].ToString()) - 1][tmp.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//Response.Write(test + "<br>");
						}catch(Exception e){
							//Response.Write(e.Message + "<br>");
							test = "";
						}
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], test) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev4bottomdb" text="Prev Section" runat="server" onClick="checkSection4Web" />
			</td>
			<td align="right">
				<asp:button id="next4bottomdb" text="Next Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update4bottomdb" text="Update Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section4web" && Request["sqlgen"] != "on") { 
	DataSet tmp = null;
%>		
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="fourwebsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourwebsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourwebsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourwebsection4" class="red" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourwebsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fourwebsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update4topweb" text="Update Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev4topweb" text="Prev Section" runat="server" onClick="checkSection4Web" />
			</td>
			<td align="right">
				<asp:button id="next4topweb" text="Next Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<%= printForm(4, "web", 137.1, 163) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="115%">
			<tr>
				<td colspan="7" align="center">
					<font class="black">Asset Information Summary</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td colspan="2" align="center"><font class="blacksm">Parents</font></td>
				<td colspan="2" align="center"><font class="blacksm">Student</font></td>
				<td colspan="2" align="center"><font class="blacksm">Non-college siblings under 19</font></td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
				<td align="center"><font class="blacksm">Value</font></td>
				<td align="center"><font class="blacksm">Debt</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 164 AND 187 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="20%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td>
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], Request[tmp.Tables[0].Rows[i]["column_id"].ToString()]) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "7") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "web", 188, 206) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td colspan="3" align="center">
					<font class="black">Parents' Retirement Asset Information<br>
					Enter net asset value (asset value - asset debt)</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Parent #2</font></td>
				<td align="center"><font class="blacksm">Parent #1</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 207 AND 219 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], Request[tmp.Tables[0].Rows[i]["column_id"].ToString()]) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td colspan="3" align="center">
					<font class="black">Parents' Debts</font>
				</td>
			</tr>
			<tr>
				<td><br></td>
				<td align="center"><font class="blacksm">Current Balance</font></td>
				<td align="center"><font class="blacksm">Monthly Payment</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 220 AND 223 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], Request[tmp.Tables[0].Rows[i]["column_id"].ToString()]) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 224 AND 229.1 AND section = '4' ORDER BY number ASC;"); 
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "web", 224, 229.1) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="95%">
			<tr>
				<td colspan="5" align="center">
					<font class="black">Life Insurance</font>
				</td>
			</tr>
			<tr>
				<td><br><font class="blacksm">Enter information about additional policies in the comments or special circumstances section at the end.</font></td>
				<td align="center" colspan="2"><font class="blacksm">Parent #1</font></td>
				<td align="center" colspan="2"><font class="blacksm">Parent #2</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 230 AND 236 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td>
					<%
						if(tmp.Tables[0].Rows[i]["number"].ToString().ToLower() == "231") {
					%>
							<font class="blacksm"><%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}else{
					%>
							<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
						}
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], Request[tmp.Tables[0].Rows[i]["column_id"].ToString()]) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "5") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<%= printForm(4, "web", 237, 237.1) %>
		<tr>
			<td colspan="3" align="center">

			<table border="1" cellpadding="2" cellspacing="0" align="center" width="80%">
			<tr>
				<td align="center"><font class="blacksm">Expense</font></td>
				<td align="center"><font class="blacksm">Parent #1</font></td>
				<td align="center"><font class="blacksm">Parent #2</font></td>
			</tr>
			<% 
				tmp = getMssqlData("SELECT * FROM mfac_data_dictionary WHERE number BETWEEN 238 AND 244 AND section = '4' ORDER BY row ASC, col ASC;"); 
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { 
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "1") {
					%>
						<tr>
					<%
					}

					if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
					%>
						<td width="30%">
						<font class="blacksm"><%= tmp.Tables[0].Rows[i]["number"].ToString() %>)&nbsp;<%= tmp.Tables[0].Rows[i]["name"].ToString() %></font>
					<%
					}else{
					%>
						<td align="center">
					<%
					}
					if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					%>
						<%= printInputField(tmp.Tables[0].Rows[i], Request[tmp.Tables[0].Rows[i]["column_id"].ToString()]) %>
					<%
					}
					%>
						<br></td>
					<%
					if(tmp.Tables[0].Rows[i]["col"].ToString() == "3") {
					%>
						</tr>
					<%
					}
				}
			%>
			</table>

			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev4bottomweb" text="Prev Section" runat="server" onClick="checkSection4Web" />
			</td>
			<td align="right">
				<asp:button id="next4bottomweb" text="Next Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update4bottomweb" text="Update Section" runat="server" onClick="checkSection4Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section5db" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="fivedbsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivedbsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivedbsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivedbsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivedbsection5" class="red" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivedbsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update5topweb" text="Update Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev5topweb" text="Prev Section" runat="server" onClick="checkSection5Web" />
			</td>
			<td align="right">
				<asp:button id="next5topweb" text="Next Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<%= printForm(5, "db", 244.1, 310) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev5bottomweb" text="Prev Section" runat="server" onClick="checkSection5Web" />
			</td>
			<td align="right">
				<asp:button id="next5bottomweb" text="Next Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update5bottomweb" text="Update Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section5web" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="fivewebsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivewebsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivewebsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivewebsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivewebsection5" class="red" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="fivewebsection6" class="black" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update5topdb" text="Update Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev5topdb" text="Prev Section" runat="server" onClick="checkSection5Web" />
			</td>
			<td align="right">
				<asp:button id="next5topdb" text="Next Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<%= printForm(5, "web", 244.1, 310) %>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev5bottomdb" text="Prev Section" runat="server" onClick="checkSection5Web" />
			</td>
			<td align="right">
				<asp:button id="next5bottomdb" text="Next Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update5bottomdb" text="Update Section" runat="server" onClick="checkSection5Web" />
			</td>
		</tr>
		</table>
<% }else if(Session["state"].ToString() == "section6db" && Request["sqlgen"] != "on") { %>
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td colspan="3" align="center">
				<font class="red">Jump to section:&nbsp;</font>
				<asp:LinkButton id="sixwebsection1" class="black" Text="One" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="sixwebsection2" class="black" Text="Two" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="sixwebsection3" class="black" Text="Three" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="sixwebsection4" class="black" Text="Four" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="sixwebsection5" class="black" Text="Five" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>&nbsp;
				<asp:LinkButton id="sixwebsection6" class="red" Text="Six" Font-Name="Verdana" Font-Size="9pt" onclick="linkButtonCase" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update6topdb" text="Update Section" runat="server" onClick="checkSection6Web" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev6topdb" text="Prev Section" runat="server" onClick="checkSection6Web" />
			</td>
			<td align="right">

			</td>
		</tr>
		<tr>
			<td colspan="3" align="center"><font class="red"> 
			311. Comments or Special Circumstances
			</font></td>
		</tr>
		<tr>
			<td colspan="3" align="center">
			<font class="black">
			Listed below are any items that would change or create an incorrect financial Snapshot from
			the information provided in the above sheets.  Entries can be made using the "Case Notes" link
			on the menu bar.
			</font>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
			<%
				//sql = "SELECT notes.note as [Comments],users.name as [Created By] FROM notes INNER JOIN users on users.userid = notes.createdBy WHERE claimid = '" + Session["id"] + "' AND admin IN ";
				string sql = "SELECT cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Creation Date], notes.note as [Comment],users.name as [Name] FROM notes INNER JOIN users on users.userid = notes.createdBy WHERE claimid = '" + Session["id"] + "' AND NOT note IS NULL AND note <> '' AND admin IN ";
				double d;
				if(Session["account_type"].ToString().ToLower() == "admin") {
					sql += "('Y','N')";
				}else{
					sql += "('N')";
				}
				sql += " ORDER BY createdDate ASC;";
				DataSet temp = getMssqlData(sql);
				dataView.DataSource = temp.Tables[0].DefaultView;
				dataView.DataBind();


				//string html = "";
				if(temp.Tables.Count > 0) {
					if(temp.Tables[0].Rows.Count > 0) { %>
			
						<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="90%">
						<tr class="grey">
							<td>
								<ASP:Datagrid 
								id="dataView" 
								runat="server" 
								align="center"
								width="100%"
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
								Font-Size = "9pt"
								Font-Name = "Arial"
								>
								<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
								<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
								<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
								<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
								<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
								</asp:datagrid>

							</td>
						</tr>
						</table>

			<%		}else{ %>
						<font class="black">The are no comments for this claim.</font>
			<%		}
				}else{ %>
					<font class="black">There are no comments for this claim.</font>
			<%	} %>
			</td>
		</tr>
		<tr height=10>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="3" align="center">

				<font class="black">Payment Authorization</font>
			</td>
		</tr>


		<!-- start of nested table -->
		<tr>
			<td colspan="3" align=center>

		<table>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="2" align="left"><font class="black">Plan</font>&nbsp;&nbsp;
				<select name="plan">
				<% 
				DataSet dv = getMssqlData("SELECT * FROM planSet WHERE claimid = '" + Session["id"] + "'");
				bool sel = false;
				if(dv.Tables.Count > 0) {
					if(dv.Tables[0].Rows.Count > 0) {
						sel = true;
					}
				}
				DataSet tmp = getMssqlData("SELECT * FROM plans");
				d = 0.00;
				for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {
					d = Convert.ToDouble(tmp.Tables[0].Rows[i]["srp"].ToString());
					if(sel) {
						if(dv.Tables[0].Rows[0]["planid"].ToString() == tmp.Tables[0].Rows[i]["id"].ToString()) {
				%>
							<option selected value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"] + "(S.R.P. $" + d.ToString("###0.00") + ")" %></option>
				<% 		
						}else{ 
				%>
							<option value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"] + "(S.R.P. $" + d.ToString("###0.00") + ")" %></option>
				<% 		
						}
					}else{ 
				%>
						<option value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"] + "(S.R.P. $" + d.ToString("###0.00") + ")" %></option>
				<% 	
					} 
				}
				if(!sel) { %>
						<option selected value="">SELECT ONE</option>
				<% } %>					
				</select>
			</td>
		</tr>
		<tr height=10>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="1" width="30%" align="left"><font class="black">Payment Type</font>&nbsp;&nbsp;
			<td>
			<select name="type">
			<% if(sel) { %>
				<option value="">SELECT ONE</option>
				<% if(dv.Tables[0].Rows[0]["payment_type"].ToString() == "Credit Card") { %>
					<option selected value="Credit Card">Credit Card</option>
					<option value="Check">Check</option>
				<% }else{ %>
					<option value="Credit Card">Credit Card</option>
					<option selected value="Check">Check</option>
				<% } %>
			<% }else{ %>
				<option selected value="">SELECT ONE</option>
				<option value="Credit Card">Credit Card</option>
				<option value="Check">Check</option>
			<% } %>
			</select>
			</td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="1" width="30%" align="left"><font class="black">Plan Amount</font>&nbsp;&nbsp;
			<td>
			<font class="black">$</font>
			<%
				try {
					d = 0.00;
					if(dv.Tables[0].Rows[0]["plan_amount"].ToString() != "0") {
						d = Convert.ToDouble(dv.Tables[0].Rows[0]["plan_amount"].ToString());
			%>
						<input type="10" name="plan_amount" value="<%= d.ToString("###0.00") %>" size="20" maxlength="10">
			<%
					}else{
			%>
						<input type="10" name="plan_amount" size="20" maxlength="10">
			<%
					}			
				}catch(Exception ex) { 
			%>
					<input type="10" name="plan_amount" size="20" maxlength="10">
			<% 
				} 
			%>
			</td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="1" width="20%" align="left"><font class="black">Amount Collected</font>&nbsp;&nbsp;
			<td>
			<font class="black">$</font>
			<%
				try {
					d = 0.00;
					if(dv.Tables[0].Rows[0]["amount_collected"].ToString() != "0") {
						d = Convert.ToDouble(dv.Tables[0].Rows[0]["amount_collected"].ToString());
			%>
						<input type="10" name="amount_collected" value="<%= d.ToString("###0.00") %>" size="20" maxlength="10">
			<%
					}else{
			%>
						<input type="10" name="amount_collected" size="20" maxlength="10">
			<%
					}			
				}catch(Exception ex) { 
			%>
					<input type="10" name="amount_collected" size="20" maxlength="10">
			<% 
				} 
			%>
			</td>
		</tr>

		<tr height=10>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="1" width="20%" align="left"><font class="black">Submit to C.C.C.</font>&nbsp;&nbsp;
			<td>
					<select name=pendingccc>
						<option value="0">No</option>
						<option value="1">Yes</option>
					</select>						
			</td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="1" width="20%" align="left"><font class="black">Generate Presentation</font>&nbsp;&nbsp;
			<td>
					<select name=pendingcf>
						<option value="0">No</option>
						<option value="1">Yes</option>
					</select>						
			</td>
		</tr>
		</table>
		<!-- end of nested table -->
			</td>
		</tr>
	

		<tr>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<asp:button id="prev6bottomdb" text="Prev Section" runat="server" onClick="checkSection6Web" />
			</td>
			<td align="right">

			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<asp:button id="update6bottomdb" text="Update Section" runat="server" onClick="checkSection6Web" />
			</td>
		</tr>
		</table>
<% } %>

	</td>
</tr>
</table>
</form>
<!--#include file="./footer.aspx"-->

</body></html>