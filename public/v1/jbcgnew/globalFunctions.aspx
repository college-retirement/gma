<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
	<script runat="server" language="C#">

	private string selectBox(string target, string datatype) {
		DataSet tmp = getMssqlData("SELECT uid,code,name FROM selectBox WHERE datatype = '" + datatype + "' ORDER BY uid ASC");
		string html = "";
		bool found = false;
		string test = "" + target;
		test = test.Trim();
		for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {
			if(tmp.Tables[0].Rows[i]["code"].ToString() == test) {
				found = true;
				html += "<option selected value=\"" + tmp.Tables[0].Rows[i]["code"] + "\">" + tmp.Tables[0].Rows[i]["name"] + "</option>\n";
			}else{
				html += "<option value=\"" + tmp.Tables[0].Rows[i]["code"] + "\">" + tmp.Tables[0].Rows[i]["name"] + "</option>\n";
			}
		}
		if(found == false) {
			return "<option selected value=\"\">SELECT ONE</option>\n" + html;
		}else{
			return "<option value=\"\">SELECT ONE</option>\n" + html;
		}
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
			//Response.Write("<p>" + e.Message + "<br><br>" + e.StackTrace);
			message.Text += "<center>** There was an error accessing " + Session["dbserver"] + ". **</center><br>" + e.Message + "<br>" + e.StackTrace;
			//throw(e);
		}
		return dt;
	}

	private string clean(string src){
		src = src.Replace("'","''");
		src = src.Replace(",","");
		return src;
	}

	private void updateSection(int section) {
		string sql = "SELECT src_table FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND input_field = 'Y' AND NOT src_table is null GROUP BY src_table;";
		DataSet tables = getMssqlData(sql);
		for(int i = 0; i < tables.Tables[0].Rows.Count; i++) {
			if(tables.Tables[0].Rows[i]["src_table"].ToString() == Session["mainDataTable"].ToString()) {
				try {
					sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND input_field = 'Y' AND src_table = '" + tables.Tables[0].Rows[i]["src_table"].ToString() + "';";
					DataSet tmp = getMssqlData(sql);

					sql = "UPDATE " + tables.Tables[0].Rows[i]["src_table"] + " SET ";
					for(int j = 0; j < tmp.Tables[0].Rows.Count; j++) {
						if(tmp.Tables[0].Rows[j]["datatype"].ToString().ToLower() == "money" || tmp.Tables[0].Rows[j]["datatype"].ToString().ToLower() == "numeric" || tmp.Tables[0].Rows[j]["datatype"].ToString().ToLower() == "int" || tmp.Tables[0].Rows[j]["datatype"].ToString().ToLower() == "bigint") {
							if(Request[tmp.Tables[0].Rows[j]["column_id"].ToString()] == null || Request[tmp.Tables[0].Rows[j]["column_id"].ToString()] == "") {
								sql += "[" + tmp.Tables[0].Rows[j]["src_column"] + "] = null";
							}else{
								sql += "[" + tmp.Tables[0].Rows[j]["src_column"] + "] = " + clean(Request[tmp.Tables[0].Rows[j]["column_id"].ToString()]);
							}
						}else{
							sql += "[" + tmp.Tables[0].Rows[j]["src_column"] + "] = '" + clean(Request[tmp.Tables[0].Rows[j]["column_id"].ToString()]) + "'";
						}

						if(j < (tmp.Tables[0].Rows.Count - 1)) {
							sql += ",";
						}
					}
					sql += " WHERE [id] = " + Session["id"] + "";
					//Response.Write(sql);
					getMssqlData(sql);
				}catch{

				}
			}else if(tables.Tables[0].Rows[i]["src_table"].ToString() == "notes") {
				try {
					sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND input_field = 'Y' AND src_table = '" + tables.Tables[0].Rows[i]["src_table"].ToString() + "';";
					//Response.Write(sql);
					DataSet data = getMssqlData(sql);
					DataSet tmp = null;
					int id = 1;
					for(int j = 0; j < data.Tables[0].Rows.Count; j++) {
						id = 1;
						sql = "SELECT MAX([id]) FROM notes;";
						tmp = getMssqlData(sql);
						try {
							id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
							id++;
						}catch{
							id = 1;
						}
						sql = "INSERT INTO notes ([id],[note],[claimid],[createdBy],[createdDate],[admin]) VALUES(" + id + ",'" + clean(Request[data.Tables[0].Rows[j]["column_id"].ToString()]) + "'," + Session["id"] + "," + Session["userid"] + ",'" + System.DateTime.Now.ToShortDateString() + "','N');";
						//Response.Write(sql);
						getMssqlData(sql);
					}
				}catch(Exception e){
					Response.Write(e.Message + "<br>" + e.StackTrace);
				}
			}else{
				try {
					sql = "SELECT src_id FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND input_field = 'Y' AND src_table = '" + tables.Tables[0].Rows[i]["src_table"].ToString() + "' GROUP BY src_id;";
					DataSet tmp = getMssqlData(sql);
					for(int j = 0; j < tmp.Tables[0].Rows.Count; j++) {
						sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND input_field = 'Y' AND src_table = '" + tables.Tables[0].Rows[i]["src_table"].ToString() + "' AND src_id = '" + tmp.Tables[0].Rows[j]["src_id"] + "';";
						DataSet inf = getMssqlData(sql);

						DataSet count = getMssqlData("SELECT COUNT(*) FROM " + tables.Tables[0].Rows[i]["src_table"].ToString() + " WHERE [id] = " + tmp.Tables[0].Rows[j]["src_id"] + " AND [claimid] = " + Session["id"] + ";");
						bool update = true;
						if(count.Tables.Count > 0) {
							if(count.Tables[0].Rows.Count > 0) {
								if(count.Tables[0].Rows[0][0].ToString() != "" && Convert.ToInt32(count.Tables[0].Rows[0][0].ToString()) == 0) {
									update = false;
								}
							}else{
								update = false;
							}
						}else{
							update = false;
						}
						if(update) {
							sql = "UPDATE " + tables.Tables[0].Rows[i]["src_table"].ToString() + " SET ";
							for(int z = 0; z < inf.Tables[0].Rows.Count; z++) {
								if(inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "money" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "numeric" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "int" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "bigint") {
									// || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "datetime"
									if(Request[inf.Tables[0].Rows[z]["column_id"].ToString()] == null || Request[inf.Tables[0].Rows[z]["column_id"].ToString()] == "") {
										sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "] = null";
									}else{
										sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "] = " + clean(Request[inf.Tables[0].Rows[z]["column_id"].ToString()]);
									}
								}else{
									sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "] = '" + clean(Request[inf.Tables[0].Rows[z]["column_id"].ToString()]) + "'";
								}
								if(z < (inf.Tables[0].Rows.Count - 1)) {
									sql += ",";
								}
							}
							sql += " WHERE [id] = '" + tmp.Tables[0].Rows[j]["src_id"] + "' AND claimid = " + Session["id"] + ";";
							//Response.Write(sql + "<br><br>");
							getMssqlData(sql);
						}else{
							sql = "INSERT INTO " + tables.Tables[0].Rows[i]["src_table"].ToString() + "([id],[claimid],";
							string sql1 = ") VALUES(" + tmp.Tables[0].Rows[j]["src_id"] + "," + Session["id"] + ",";
							for(int z = 0; z < inf.Tables[0].Rows.Count; z++) {
								if(inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "money" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "numeric" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "int" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "bigint" || inf.Tables[0].Rows[z]["datatype"].ToString().ToLower() == "datetime") {
									if(Request[inf.Tables[0].Rows[z]["column_id"].ToString()] == null || Request[inf.Tables[0].Rows[z]["column_id"].ToString()] == "") {
										sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "]";
										sql1 += "null";
									}else{
										sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "]";
										sql1 += clean(Request[inf.Tables[0].Rows[z]["column_id"].ToString()]);
									}
								}else{
									sql += "[" + inf.Tables[0].Rows[z]["src_column"] + "]";
									sql1 += "'" + clean(Request[inf.Tables[0].Rows[z]["column_id"].ToString()]) + "'";
								}

								if(z < (inf.Tables[0].Rows.Count - 1)) {
									sql += ",";
									sql1 += ",";
								}
							}
							sql = sql + sql1 + ")";
							//Response.Write(sql);
							getMssqlData(sql);						
						}
					}
				}catch{

				}
			}
		}
	}


	private void checkDataSimple(DataSet tmp, bool required) {
		string test = "";
		message.Text = "";
		for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) {
			//Response.Write(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] + " " + tmp.Tables[0].Rows[i]["datatype"].ToString());
			if(tmp.Tables[0].Rows[i]["required"].ToString().ToLower() == "y" && required) {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] == null || Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] == "") {
					message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is a required field. *<br>";
					return;
				}
			}
			if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "varchar" || tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "char") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "int") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
					try {
						Convert.ToInt32(test);
					}catch{
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "bigint") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					//Response.Write("ss" + test.Length + "ss");
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
					try {
						Convert.ToInt64(test);
					}catch(Exception e){
						message.Text += e.Message + "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "numeric") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
					try {
						Convert.ToDouble(test);
					}catch{
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "datetime") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					try {
						DateTime t = Convert.ToDateTime(test);
					}catch{
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "money") {
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
					try {
						Convert.ToDouble(test);
					}catch{
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}else{
				//handle everything else like a varchar field
				if(Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != null && Request[tmp.Tables[0].Rows[i]["column_id"].ToString()] != "") {
					int min = Convert.ToInt32(tmp.Tables[0].Rows[i]["minlength"].ToString());
					int max = Convert.ToInt32(tmp.Tables[0].Rows[i]["maxlength"].ToString());
					test = "";
					test += Request[tmp.Tables[0].Rows[i]["column_id"].ToString()];
					if(test.Length < min || test.Length > max) {
						message.Text += "*" + tmp.Tables[0].Rows[i]["name"] + " (" + tmp.Tables[0].Rows[i]["number"] + ") is invalid. *<br>";
						return;
					}
				}
			}

			if(message.Text != "") {
				return;
			}
		}
	}

	private string printInputField(DataRow dr, string value) {
		string html = "";
		if(dr["datatype"].ToString().ToLower() == "int" || dr["datatype"].ToString().ToLower() == "bigint" || dr["datatype"].ToString().ToLower() == "numeric" || dr["datatype"].ToString().ToLower() == "varchar" || dr["datatype"].ToString().ToLower() == "char") {	
			html += "<input value=\"" + value + "\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";

		}else if(dr["datatype"].ToString().ToLower() == "money") {
			if(value != "") {
				try {
					double d = Convert.ToDouble(value);	
					html += "<font class=\"blacksm\">$</font><input value=\"" + d.ToString("###0.00") + "\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
				}catch{
					html += "<font class=\"blacksm\">$</font><input value=\"" + value + "\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
				}
			}else{
				html += "<font class=\"blacksm\">$</font><input value=\"\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
			}
		}else if(dr["datatype"].ToString().ToLower() == "datetime") {
			if(value != "") {
				try {
					DateTime t = Convert.ToDateTime(value);
					if(t.ToShortDateString() == "1/1/1900" || t.ToShortDateString() == "01/01/1900") {
						html += "<input value=\"\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
					}else{
						html += "<input value=\"" + t.ToShortDateString() + "\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
					}
				}catch{
					html += "<input value=\"" + value + "\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
				}
			}else{
				html += "<input value=\"\" type=\"text\" name=\"" + dr["column_id"].ToString() + "\" size=\"" + dr["width"].ToString() + "\" maxlength=\"" + dr["maxlength"].ToString() + "\">";
			}
		}else if(dr["datatype"].ToString().ToLower() == "textbox") {
			html += "<textarea cols=\"" + dr["width"] + "\" rows=\"5\" name=\"" + dr["column_id"] + "\">" + value + "</textarea>\n";
		}else{
			html += "<select name=\"" + dr["column_id"].ToString() + "\">";
			html += selectBox(value,dr["datatype"].ToString());
			html += "</select>";
		}
		return html;
	}

	private string printForm(int section, string src, double snum, double fnum) {
		string sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section =" + section + " AND number BETWEEN " + snum + " AND " + fnum + " ORDER BY number ASC;";
		string html = "";
		DataSet all = getMssqlData(sql);



		DataSet claimdata = null;
		DataSet collchoice = null;
		DataSet parentInfo = null;
		DataSet familyInfo = null;
		string test = "";
		for(int i = 0; i < all.Tables[0].Rows.Count; i++) {
			if(all.Tables[0].Rows[i]["src_table"].ToString() == Session["mainDataTable"].ToString()) {
				if(all.Tables[0].Rows[i]["input_field"].ToString().ToLower() == "y") {
					if(src == "db") {
						sql = "SELECT * FROM " + Session["mainDataTable"] + " WHERE [id] = '" + Session["id"] + "'";
						claimdata = getMssqlData(sql);

						html += getFormHtml(all,claimdata.Tables[0].Rows[0][all.Tables[0].Rows[i]["column_id"].ToString()].ToString(),i);
						//html += getFormHtml(all,all.Tables[0].Rows[i]["column_id"].ToString(),i);
					}else if(src == "web"){
						html += getFormHtml(all,Request[all.Tables[0].Rows[i]["column_id"].ToString()],i);
					}else if(src == "null") {
						html += getFormHtml(all,"",i);
					}
				}else{
						html += getFormHtml(all, "", i);
				}
			}else if(all.Tables[0].Rows[i]["src_table"].ToString() == "mfac_college_choice") {
				if(src == "db") {
						try {
							collchoice = getMssqlData("SELECT * FROM mfac_college_choice WHERE [id] = " + all.Tables[0].Rows[i]["src_id"].ToString() + " AND [claimid] = " + Session["id"] + ";");
							test = collchoice.Tables[0].Rows[0][all.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//test = all.Tables[0].Rows[i]["src_column"].ToString();
						}catch{
							test = "";
						}
						html += getFormHtml(all, test, i);
				}else if(src == "web"){
					html += getFormHtml(all,Request[all.Tables[0].Rows[i]["column_id"].ToString()],i);
				}else if(src == "null") {
					html += getFormHtml(all, "", i);
				}
			}else if(all.Tables[0].Rows[i]["src_table"].ToString() == "mfac_parent_info") {
				if(src == "db") {
						try {
							parentInfo = getMssqlData("SELECT * FROM mfac_parent_info WHERE [id] = " + all.Tables[0].Rows[i]["src_id"].ToString() + " AND [claimid] = " + Session["id"] + ";");
							test = parentInfo.Tables[0].Rows[0][all.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//test = all.Tables[0].Rows[i]["src_column"].ToString();
						}catch{
							test = "";
						}
						html += getFormHtml(all, test, i);
				}else if(src == "web"){
					html += getFormHtml(all,Request[all.Tables[0].Rows[i]["column_id"].ToString()],i);
				}else if(src == "null") {
					html += getFormHtml(all, "", i);
				}
			}else if(all.Tables[0].Rows[i]["src_table"].ToString() == "mfac_family_info") {
				if(src == "db") {
						try {
							familyInfo = getMssqlData("SELECT * FROM mfac_family_info WHERE [id] = " + all.Tables[0].Rows[i]["src_id"].ToString() + " AND [claimid] = " + Session["id"] + ";");
							test = familyInfo.Tables[0].Rows[0][all.Tables[0].Rows[i]["src_column"].ToString()].ToString();
							//test = all.Tables[0].Rows[i]["src_column"].ToString();
						}catch{
							test = "";
						}
						html += getFormHtml(all, test, i);
				}else if(src == "web"){
					html += getFormHtml(all,Request[all.Tables[0].Rows[i]["column_id"].ToString()],i);
				}else if(src == "null") {
					html += getFormHtml(all, "", i);
				}
			}else if(all.Tables[0].Rows[i]["src_table"].ToString() == "notes") {
				if(src == "db") {
					html += getFormHtml(all, "", i);
				}else if(src == "web"){
					html += getFormHtml(all,Request[all.Tables[0].Rows[i]["column_id"].ToString()],i);
				}else if(src == "null") {
					html += getFormHtml(all, "", i);
				}
			}
		}
		return html;
	}

	private string getFormHtml(DataSet tmp, string value, int i) {
		string html = "";
		int t = 0;
		if(i > 0) {
			t = Convert.ToInt32(tmp.Tables[0].Rows[i]["col"].ToString());
			t--;
			if(! (tmp.Tables[0].Rows[i - 1]["col"].ToString() == t.ToString() && tmp.Tables[0].Rows[i - 1]["row"].ToString() == tmp.Tables[0].Rows[i]["row"].ToString()) ) {
				if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "title" || tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "textbox") {
					html += "<tr>\n<td class=\"grey\" width=\"10%\">&nbsp;</td>\n";
					html += "<td class=\"grey\" colspan=\"2\" align=\"left\" width=\"40%\">\n";
				}else{
					html += "<tr>\n<td width=\"10%\">&nbsp;</td>\n";
					html += "<td align=\"left\" width=\"40%\">\n";
				}
			}
		}else{
			if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "title" || tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "textbox") {
				html += "<tr>\n<td class=\"grey\" width=\"10%\">&nbsp;</td>\n";
				html += "<td class=\"grey\" colspan=\"2\" align=\"left\" width=\"40%\">\n";
			}else{
				html += "<tr>\n<td width=\"10%\">&nbsp;</td>\n";
				html += "<td align=\"left\" width=\"40%\">\n";
			}
		}
		if(tmp.Tables[0].Rows[i]["display_name"].ToString().ToLower() == "y") {
			if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "title") {
				html += "<font class=\"black\">" + tmp.Tables[0].Rows[i]["name"].ToString() + "</font>\n";
			}else{
				if(tmp.Tables[0].Rows[i]["required"].ToString().ToLower() == "y") {
					html += "<font class=\"redsm\">" + tmp.Tables[0].Rows[i]["number"].ToString() + ")&nbsp;</font>\n";
					html += "<font class=\"blacksm\">" + tmp.Tables[0].Rows[i]["name"].ToString() + "</font>\n<font class=\"redsm\">*</font>\n";
				}else{
					if(i > 0) {
						t = Convert.ToInt32(tmp.Tables[0].Rows[i]["col"].ToString());
						t--;
						if(! (tmp.Tables[0].Rows[i - 1]["col"].ToString() == t.ToString() && tmp.Tables[0].Rows[i - 1]["row"].ToString() == tmp.Tables[0].Rows[i]["row"].ToString()) ) {
							html += "<font class=\"blacksm\">" + tmp.Tables[0].Rows[i]["number"].ToString() + ")&nbsp</font>\n";		
						}
					}else{
						html += "<font class=\"blacksm\">" + tmp.Tables[0].Rows[i]["number"].ToString() + ")&nbsp</font>\n";
					}
					html += "<font class=\"blacksm\">" + tmp.Tables[0].Rows[i]["name"].ToString() + "</font>\n";
				}
			}
		}

		if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() != "title" && tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() != "textbox") {
			if(i > 0) {
				t = Convert.ToInt32(tmp.Tables[0].Rows[i]["col"].ToString());
				t--;
				if(! (tmp.Tables[0].Rows[i - 1]["col"].ToString() == t.ToString() && tmp.Tables[0].Rows[i - 1]["row"].ToString() == tmp.Tables[0].Rows[i]["row"].ToString()) ) {
					html += "</td>\n<td align=\"left\" width=\"40%\">\n";
				}
			}else{
				html += "</td>\n<td align=\"left\" width=\"40%\">\n";
			}
			if(tmp.Tables[0].Rows[i]["input_field"].ToString().ToLower().ToLower() == "y") {
				html += printInputField(tmp.Tables[0].Rows[i], value);
			}
		}else if(tmp.Tables[0].Rows[i]["datatype"].ToString().ToLower() == "textbox") {
			html += "</td></tr><tr>\n<td align=\"center\" colspan=\"3\">\n";
			html += printInputField(tmp.Tables[0].Rows[i], value);
		}

		if(i < (tmp.Tables[0].Rows.Count - 1)) {
			t = Convert.ToInt32(tmp.Tables[0].Rows[i]["col"].ToString());
			t++;
			if(! (tmp.Tables[0].Rows[i+1]["col"].ToString() == t.ToString() && tmp.Tables[0].Rows[i+1]["row"].ToString() == tmp.Tables[0].Rows[i]["row"].ToString()) ) {	
				html += "</td>\n</tr>\n";
			}
		}else{
			html += "</td>\n</tr>\n";
		}
		return html;
	}

	private void updateLog(string claimid, string status) {
		int id = 1;
		string sql = "SELECT MAX([id]) FROM " + Session["mainLogTable"] + ";";
		DataSet tmp = getMssqlData(sql);
		try {
			id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
			id++;
		}catch{
			id = 1;
		}
		sql = "INSERT INTO " + Session["mainLogTable"] + " ([id],[claimid],[transactionDate],[transactionBy],[status],[active]) VALUES(" + id + "," + Session["id"] + ",'" + System.DateTime.Now.ToShortDateString() + "'," + Session["userid"] + ",'" + status + "','Y');";
		getMssqlData(sql);
	}
</script>
