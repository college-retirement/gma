<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Register TagPrefix="mbrsc" Namespace="MetaBuilders.WebControls" 
         Assembly="MetaBuilders.WebControls.RowSelectorColumn" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language=javascript>

 function SelectAllCheckboxes(spanChk){

   // Added as ASPX uses SPAN for checkbox
   var oItem = spanChk.children;
   var theBox= (spanChk.type=="checkbox") ? 
        spanChk : spanChk.children.item[0];
   xState=theBox.checked;
   elm=theBox.form.elements;

   for(i=0;i<elm.length;i++)
     if(elm[i].type=="checkbox" && 
              elm[i].id!=theBox.id)
     {
       //elm[i].click();
       if(elm[i].checked!=xState)
         elm[i].click();
       //elm[i].checked=xState;
     }
 }
 
 
</script>	
	<script language="C#" runat="server">
        DataSet data;	
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() != "admin") 
		{
		    //if((Session["userid"].ToString() != "34") && (Session["userid"].ToString() != "44") && (Session["userid"].ToString() != "30") && (Session["userid"].ToString() != "49"))
		    //	{
		    //    Response.Redirect("./nopriv.aspx");
            	    //	}//commented on 18th feb
        	}

       
        if (!Page.IsPostBack)
        {
            Session["astate"] = "list";
            Session["reassign"] = "";
            //Session["sort"] = "desc";
            // Session["col"] = "payment_authorizationDate";			
            Session["col"] = "transactionDate";
            //GridView1.DataSource = data.Tables[0].DefaultView;
            // GridView1.DataBind();

            string sql2 = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ' ' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 + ' ' + e.col0003 AS [Parents Name],e.col0018 AS [Email],d.status, cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM mfac_client_data2 AS d INNER JOIN users ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=users.userid WHERE  d.userid > 0 and e.col0003 is not null  ORDER BY d.transactionDate DESC";
            string strconn = ConfigurationManager.ConnectionStrings["oldcrsdb"].ConnectionString.ToString();
            //SqlCommand cmd1 = new SqlCommand(sql, strconn);
            SqlDataAdapter data1 = new SqlDataAdapter(sql2, strconn);
            DataSet ds1 = new DataSet();
            data1.Fill(ds1, "temp1");

            //GridView1.DataSource = ds1.Tables[0].DefaultView;

            //GridView1.DataBind();
      
            GridView1.DataBind();


        }else {
			string sql22 = string.Empty;
			string sql = string.Empty;
           		string sql_del = string.Empty;//modified by me
			if(Session["sql"] == null){
			 Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 AS [Parent Last Name], e.col0003 AS [Parents First Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=users.userid WHERE";
        //		Session["sql"] += " [status] = 'Payment Authorized' ";
			Session["sql"] += " d.userid > 0 ";
			 sql = Session["sql"] + " ORDER BY d.transactionDate DESC;";
			Session["sql1"] = sql.ToString();
			//Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid WHERE";
			//Session["sql"] += " d.userid > 0 ";
			sql22 = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ' ' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 AS [Parent last Name], e.col0003 AS [Parents first Name],e.col0018 AS [Email],d.status, cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM mfac_client_data2 AS d INNER JOIN users ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=d.id WHERE  d.userid > 0  and e.col0003 is not null ORDER BY d.transactionDate DESC";
			//string strconn = ConfigurationManager.ConnectionStrings["oldcrsdb"].ConnectionString.ToString();
			////SqlCommand cmd1 = new SqlCommand(sql, strconn);
			//SqlDataAdapter data1 = new SqlDataAdapter(sql2, strconn);
			//DataSet ds1 = new DataSet();
			//data1.Fill(ds1, "temp1");
            		sql_del = "deletestudent";////modified by me
			} else {
				sql = Session["sql"].ToString();
				sql22 = Session["sql"].ToString();
			}

			DataSet d = new DataSet();
			//SqlDataSource1.SelectCommand = sql22.ToString();
			data = getMssqlData(sql);
			d = getMssqlData(sql22);
		   
			//GridView1.DataBind();
			//int a = GridView1.Rows.Count;
			Label1.Text = " " + d.Tables[0].Rows.Count.ToString() + " Total";
			SqlDataSource1.SelectCommand = sql22.ToString();
            		SqlDataSource1.DeleteCommand = sql_del.ToString();//modified by me
		}
        
		return;
	}



	// this function rebuilds the sql query stored in the session based on the current form values
	private void rebuildSessionQuery() {

        Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 AS [Parents last Name], e.col0003 AS [Parents First Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=users.userid WHERE";
//		Session["sql"] += " [status] = 'Payment Authorized' ";
		Session["sql"] += " e.col0003 is not null and d.userid > 0 ";

       if (Request["qclientlast"] != "") {
			//Response.Write("last " + Request["qclientlast"]);
			Session["sql"] += " AND d.col0004 LIKE '%" + Request["qclientlast"] + "%' ";
		}

		if (Request["qclientfirst"] != "") {
			Session["sql"] += " AND d.col0002 LIKE '%" + Request["qclientfirst"] + "%' ";
		}

		if (Request["qclienths"] != "") {
			Session["sql"] += " AND d.col0018 LIKE '%" + Request["qclienths"] + "%' ";
		}

		if (Request["qclientgrad"] != "") {
			Session["sql"] += " AND d.col0020 LIKE '%" + Request["qclientgrad"] + "%' ";
		}

		if (Request["qclientuserid"] != "") {
			Session["sql"] += " AND d.userid = '" + Request["qclientuserid"] + "' ";
		}

		if (Request["qclientstatus"] != "") {
			Session["sql"] += " AND status = '" + Request["qclientstatus"] + "' ";
		}

		/*if (Request["qclientaddress"] != "") {
			Session["sql"] += " AND d.col0007 LIKE '" + Request["qclientaddress"] + "%' ";
		}*/
		
        if (Request["qid"] != "") {
			Session["sql"] += " AND d.id LIKE '" + Request["qid"] + "%' ";
		}
		
		if (Request["qclientcity"] != "") {
			Session["sql"] += " AND d.col0009 LIKE '" + Request["qclientcity"] + "%' ";
		}

		if (Request["qclientstate"] != "") {
			Session["sql"] += " AND d.col0010 LIKE '%" + Request["qclientstate"] + "%' ";
		}

		if (Request["qclientzip"] != "") {
			Session["sql"] += " AND d.col0011 LIKE '%" + Request["qclientzip"] + "%' ";
		}

        if (Request["qclientlastparentname"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0002) LIKE '%" + Request["qclientlastparentname"] + "%' ";
        }
        if (Request["qclientfirstparentname"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0003) LIKE '%" + Request["qclientfirstparentname"] + "%' ";
        }
        if (Request["qclientemail"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0018) LIKE '%" + Request["qclientemail"] + "%' ";
        }
	}
	
	private void downloadAll_Click(Object sender, EventArgs e) {
	    string myCases = "SELECT d.[id] AS [ID], d.col0004 + ', ' + d.col0002 AS [Student Name], e.col0004 + ', ' + e.col0002 AS [Parent(s) Name(s)], d.col0020 AS [HS Grad Year], d.col0007 AS [Address], d.col0009 AS [City], d.col0010 AS [State], d.col0011 AS [Zip], d.col0013 AS [Phone], e.col0018 AS [Email] FROM " + Session["mainDataTable"] + " AS d left JOIN mfac_parent_info as e ON d.id=e.claimid WHERE len(e.col0004)>0 and e.col0003 is not null and e.col0002 is not null and d.userid > 0 ";
	    if (Request["qclientlast"] != "") {
			//Response.Write("last " + Request["qclientlast"]);
			myCases += " AND d.col0004 LIKE '%" + Request["qclientlast"] + "%' ";
		}

		if (Request["qclientfirst"] != "") {
			myCases += " AND d.col0002 LIKE '%" + Request["qclientfirst"] + "%' ";
		}

		if (Request["qclienths"] != "") {
			myCases += " AND d.col0018 LIKE '%" + Request["qclienths"] + "%' ";
		}

		if (Request["qclientgrad"] != "") {
			myCases += " AND d.col0020 LIKE '%" + Request["qclientgrad"] + "%' ";
		}

		if (Request["qclientuserid"] != "") {
			myCases += " AND d.userid = '" + Request["qclientuserid"] + "' ";
		}

		if (Request["qclientstatus"] != "") {
			myCases += " AND status = '" + Request["qclientstatus"] + "' ";
		}
        if (Request["qid"] != "") {
			myCases += " AND d.id LIKE '%" + Request["qid"] + "%' ";
		}
		
		if (Request["qclientcity"] != "") {
			myCases += " AND d.col0009 LIKE '%" + Request["qclientcity"] + "%' ";
		}

		if (Request["qclientstate"] != "") {
			myCases += " AND d.col0010 LIKE '%" + Request["qclientstate"] + "%' ";
		}

		if (Request["qclientzip"] != "") {
			myCases += " AND d.col0011 LIKE '%" + Request["qclientzip"] + "%' ";
		}

        if (Request["qclientlastparentname"] != "")
        {
            myCases += " AND UPPER(e.col0004) LIKE UPPER('%" + Request["qclientlastparentname"] + "%') ";
        }
        if (Request["qclientfirstparentname"] != "")
        {
            myCases += " AND UPPER(e.col0002) LIKE UPPER('%" + Request["qclientfirstparentname"] + "%') ";
        }
        if (Request["qclientemail"] != "")
        {
            myCases += " AND UPPER(e.col0018) LIKE UPPER('%" + Request["qclientemail"] + "%') ";
        }
        DataTable CaseTable = SQLManager.GetDataPrimitive(myCases);
        string myCSV = "Data" + DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString()+ DateTime.Now.Second.ToString() + ".csv";
        CRSCRM.CreateCSVFile(CaseTable, Server.MapPath("~/Temp/") + myCSV);
        Response.Redirect("~/Temp/" + myCSV);
    }
    
	// this function is called when scheduled leads re-assign button is clicked
	private void updateSearchQuery(Object sender, EventArgs e) {

		//rebuildSessionQuery();
        Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ', ' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0004 AS [Parent's last name] , e.col0002 AS [Parent's first Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d left JOIN mfac_parent_info as e ON d.id=e.claimid left JOIN users  ON d.userid=users.userid WHERE";
//// backup of above query//       Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0004 AS [Parent's last name] , e.col0002 AS [Parent's first Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d left JOIN mfac_parent_info as e ON e.claimid=d.id left JOIN users  ON d.userid=e.claimid WHERE";
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////FROM mfac_client_data2 AS d left JOIN mfac_parent_info as e ON d.id=e.claimid left JOIN users  ON d.userid=users.userid
////modified by me///////////SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 AS [Parent's last name] , e.col0002 AS [Parent's first Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users  ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=users.userid WHERE";
        //Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], e.col0002 AS [Parent's last name] , e.col0003 AS [Parent's first Name], e.col0018 AS [Email], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users  ON d.userid=users.userid INNER JOIN mfac_parent_info as e ON e.claimid=users.userid WHERE";
//		Session["sql"] += " [status] = 'Payment Authorized' ";
        Session["sql"] += " len(e.col0004)>0 and e.col0003 is not null and e.col0002 is not null and d.userid > 0 ";
  
		if (Request["qclientlast"] != "") {
			//Response.Write("last " + Request["qclientlast"]);
			Session["sql"] += " AND d.col0004 LIKE '%" + Request["qclientlast"] + "%' ";
		}

		if (Request["qclientfirst"] != "") {
			Session["sql"] += " AND d.col0002 LIKE '%" + Request["qclientfirst"] + "%' ";
		}

		if (Request["qclienths"] != "") {
			Session["sql"] += " AND d.col0018 LIKE '%" + Request["qclienths"] + "%' ";
		}

		if (Request["qclientgrad"] != "") {
			Session["sql"] += " AND d.col0020 LIKE '%" + Request["qclientgrad"] + "%' ";
		}

		if (Request["qclientuserid"] != "") {
			Session["sql"] += " AND d.userid = '" + Request["qclientuserid"] + "' ";
		}

		if (Request["qclientstatus"] != "") {
			Session["sql"] += " AND status = '" + Request["qclientstatus"] + "' ";
		}
/*
		if (Request["qclientaddress"] != "") {
			Session["sql"] += " AND d.col0007 LIKE '" + Request["qclientaddress"] + "%' ";
		}
*/
        if (Request["qid"] != "") {
			Session["sql"] += " AND d.id LIKE '%" + Request["qid"] + "%' ";
		}
		
		if (Request["qclientcity"] != "") {
			Session["sql"] += " AND d.col0009 LIKE '%" + Request["qclientcity"] + "%' ";
		}

		if (Request["qclientstate"] != "") {
			Session["sql"] += " AND d.col0010 LIKE '%" + Request["qclientstate"] + "%' ";
		}

		if (Request["qclientzip"] != "") {
			Session["sql"] += " AND d.col0011 LIKE '%" + Request["qclientzip"] + "%' ";
		}

        if (Request["qclientlastparentname"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0004) LIKE UPPER('%" + Request["qclientlastparentname"] + "%') ";
        }
        if (Request["qclientfirstparentname"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0002) LIKE UPPER('%" + Request["qclientfirstparentname"] + "%') ";
        }
        if (Request["qclientemail"] != "")
        {
            Session["sql"] += " AND UPPER(e.col0018) LIKE UPPER('%" + Request["qclientemail"] + "%') ";
        }
        string sql = Session["sql"].ToString();
///		Response.Write (sql);
		//return;
        data = getMssqlData(sql);
        //string strconn= ConfigurationManager.ConnectionStrings["oldcrsdb"].ConnectionString.ToString();
        ////SqlCommand cmd1 = new SqlCommand(sql, strconn);
        //SqlDataAdapter data1 = new SqlDataAdapter(sql, strconn);
        //DataSet ds1 = new DataSet();
        //data1.Fill(ds1, "temp1");
        Label1.Text = " " + data.Tables[0].Rows.Count.ToString() + " Total" ;
		//Label1.Text =sql.ToString();
        SqlDataSource1.SelectCommand = sql.ToString();
        GridView1.DataBind();  
        
	}

	private string printStatusList(string id) {

		string package = "";
		
		string [] stats = {"New Lead","Assigned","Scheduled","Payment Authorized"};

		for (int i=0; i < stats.Length; i++) {
			if(id == stats[i] ) {
				package += "<option selected value=\"" + stats[i] + "\">" + stats[i] + "</option>\n";
			}else{
				package += "<option value=\"" + stats[i] + "\">" + stats[i] + "</option>\n";
			}
		}
		
		return package;
	}



        private string printUserList(string id)
        {
            string package = "";
            string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
            string sql = "SELECT * FROM users WHERE (account_type = 'Representative' or account_type = 'Admin') and active='1' ORDER BY name";
            SqlConnection activeConn = new SqlConnection(connStr);
            SqlCommand comm = new SqlCommand(sql, activeConn);
            try
            {
                comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
            }
            catch (Exception e)
            {
                message.Text = "** Error loading user set. **<br>" + e.Message;
                return "";
            }
            SqlDataAdapter dAdpt = new SqlDataAdapter();
            dAdpt.SelectCommand = comm;
            try
            {
                activeConn.Open();
            }
            catch (Exception e)
            {
                message.Text = "** Error loading user set. **<br>" + e.Message;
                return "";
            }
            DataSet data = new DataSet();
            try
            {
                dAdpt.Fill(data);
            }
            catch (Exception e)
            {
                message.Text = "** Error loading user set. **<br>" + e.Message;
                return "";
            }
            activeConn.Close();
            try
            {
                if (data.Tables[0].Rows.Count == 0)
                {
                    message.Text = "** No users found. **";
                    return "";
                }
                else
                {
                    package += "<option value=\"\">SELECT ONE</option>\n";
                    for (int i = 0; i < data.Tables[0].Rows.Count; i++)
                    {
                        if (id == data.Tables[0].Rows[i]["userid"].ToString())
                        {
                            package += "<option selected value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
                        }
                        else
                        {
                            package += "<option value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
                        }
                    }
                }
            }
            catch (Exception e)
            {
                message.Text = "** Error loading user set. **<br>" + e.Message;
                return "";
            }
            return package;
        }   

	private string printUserList() {
		string package = "";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM users WHERE account_type = 'Representative' and active='1' ORDER BY name";
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
				package += "<option value=\"\">SELECT ONE</option>\n";
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					//if(id == data.Tables[0].Rows[i]["userid"].ToString() ) {
					//	package += "<option selected value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					//}else{
						package += "<option value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					//}
				}
			}
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		return package;
	}


	// this function is called when scheduled leads re-assign button is clicked
	private void updateDB(Object sender, EventArgs e) 
    {
		try {
			
			string sql = "";
			
                Session["id"] = Session["reassign"];
                sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user"] + "' WHERE id = '" + Session["id"] + "';";

                Session["astate"] = "list";
                Session["reassign"] = "";
                getMssqlData(sql);

                updateLog(Session["id"].ToString(), "Assigned");
			}


	catch(Exception ex){
			message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
			return;
		}
	}


	private void cancelAssign(Object sender, EventArgs e) {
		Session["astate"] = "list";
		Session["reassign"] = "";
	}


        private void AssignGroup(Object sender, EventArgs e)
        {
            string sql;
            message.Text = "";

            foreach (GridViewRow row in GridView1.Rows)
            {
                CheckBox check = (CheckBox)row.FindControl("chkReAssignSelect");
                if (check != null && check.Checked)
                {
                    int id = Convert.ToInt32(GridView1.DataKeys[row.RowIndex].Value);
                    Session["id"] = Convert.ToInt32(id);
                    sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user"] + " WHERE [id] = " + Session["id"] + "";
                    getMssqlData(sql);
                    updateLog(Session["id"].ToString(), "Assigned");
                }

            }
            Session["id"] = null;
        }

        protected void GridView1Update(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int userid;
                if (e.CommandName == "Select")
                {

                    userid = Convert.ToInt32(e.CommandArgument);
                    System.Web.HttpContext.Current.Session["id"] = Convert.ToInt32(userid);
                    message.Text = "";
                    DataSet temp = getMssqlData("SELECT col0004,col0002,col0013 FROM " + Session["mainDataTable"] + " WHERE [id] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["home_phone"] = temp.Tables[0].Rows[0]["col0013"].ToString();
                    Session["student_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["student_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

                    temp = getMssqlData("SELECT col0004,col0002,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["parent_email_address"] = temp.Tables[0].Rows[0]["col0018"].ToString();
                    Session["client_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["client_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();
                    Response.Redirect("./case_info.aspx");
                }
                else if (e.CommandName == "Re-Assign")
                {
                    userid = Convert.ToInt32(e.CommandArgument);
                    Session["reassign"] = Convert.ToInt32(userid);
                    Session["astate"] = "reassign";

                }
                else if (e.CommandName == "Deletestudent")
                {

                    userid = Convert.ToInt32(e.CommandArgument);
                    string connStr = @"DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
                    SqlConnection sqlconn = new SqlConnection(connStr);
                    SqlCommand delete = new SqlCommand("deletestudent", sqlconn);
                    delete.CommandType = CommandType.StoredProcedure;
                    delete.Parameters.Add(new SqlParameter("@id", userid));
                    sqlconn.Open();
                    delete.ExecuteNonQuery();
                    sqlconn.Close();
                    Response.Redirect("./case_finder_admin.aspx");
                }

            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **" + ex.Message;
                return;
            }

        }


</script>
  	

</head>
<body text="#000000" bgColor="#ffffff" >
<%
          if (Session["account_type"].ToString().ToLower() != "admin")
          {
              //Response.Redirect("./nopriv.aspx");%>
              <!-- #include file="./images/rep_menu/nav2.aspx" -->
              <%
          }
           
         else {%>
           
    <!-- #include file="./images/admin_menu/nav4.aspx" --><%}%> 
<form id="Form1" method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" style="vertical-align :top" width="1200">
<!--
<tr class="red">
	<td>
		<table bord3er="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Add New Lead&nbsp;</font></td>
		</tr></table>
	</td>
</tr>
-->
<tr>
	<td align="center" style="width: 903px" >
		<table border="0" cellpadding="4" cellspacing="0" align="center" style="vertical-align :top" width="1200">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>

	<td align="center" style="width: 903px">
	

		<table border="0" cellpadding="4" cellspacing="4" align="center" style="vertical-align :top" width= "1200">
		<tr class="grey" align="center">
			<td style="width: 761px"><font class="black">Search Limits</font></td>

		</tr>

		<tr>
           
            
			<td style="width: 761px">
			<table>
        
		<tr>
			<td><font class="black">Case ID: </font></td><td><font class="black"><input type="text" name=qid value="<%= Request["qid"] %>"> </font></td>
		    <td width=20></td>
			<td><font class="black">Student High School: </font></td><td><font class="black"><input type="text" name=qclienths value="<%= Request["qclienths"] %>"> </font></td>
		</tr>
		<tr>
			<td><font class="black">Student Last Name: </font></td><td><font class="black"><input type="text" name=qclientlast value="<%= Request["qclientlast"] %>"> </font></td>
			<td width=20></td>
			<td><font class="black">Student Grad Year: </font></td><td><font class="black"><input type="text" name=qclientgrad value="<%= Request["qclientgrad"] %>"> </font></td>
		</tr>
		<tr>
			<td><font class="black">Student First Name: </font></td><td><font class="black"><input type="text" name=qclientfirst value="<%= Request["qclientfirst"] %>"> </font></td>
			<td width=20></td>
			<td><font class="black">Student City: </font></td><td><font class="black"><input type="text" name=qclientcity value="<%= Request["qclientcity"] %>"> </font></td>
		</tr>


		<tr>
			<td><font class="black">Assigned To: </font></td><td><font class="black"><select name="qclientuserid"><%= printUserList(Request["qclientuserid"]) %></select></font></td>
			<td width=20></td>
			<td><font class="black">Student State: </font></td><td><font class="black"><input type="text" name=qclientstate value="<%= Request["qclientstate"] %>"> </font></td>
		</tr>
		<tr>
			<td><font class="black">Current Status: </font></td><td><font class="black"><select name="qclientstatus"><option value="">SELECT ONE</option><%= printStatusList(Request["qclientstatus"]) %></select></font></td>
			<td width=20></td>
			<td><font class="black">Student Zip: </font></td><td><font class="black"><input type="text" name=qclientzip value="<%= Request["qclientzip"] %>"> </font></td>
		</tr>
		<%--Date 29 nov 2007 Akhil Parashar- text box for parents and email--%>
		<tr>
			<td><font class="black">Parent's First Name: </font></td><td><font class="black"><input type="text" name=qclientfirstparentname value="<%= Request["qclientfirstparentname"] %>"> </font></td>
			<td width=20></td>
			<td><font class="black">Parent's Email: </font></td><td style="width: 134px"><font class="black"><input type="text" name=qclientemail value="<%= Request["qclientemail"] %>" id="Input2"> </font></td>
		</tr>
		<tr>
		<td><font class="black">Parent's Last Name: </font></td><td><font class="black"><input type="text" name=qclientlastparentname value="<%= Request["qclientlastparentname"] %>"> </font></td>
		</tr>


		<tr>
			<td colspan=2><asp:Button id="searchQuery" runat="server" text="Search" onClick="updateSearchQuery" />&nbsp;</td>
		</tr>
                     
			</table>
			</td>
		</tr>
		</table>





		<% if(Session["astate"].ToString() == "list") { %>

		<table border="0" cellpadding="4" cellspacing="4" align="center" style="vertical-align :top" width="1200">

		<tr>
		<%--calculating total--%>
			<%--<td align="center" style="height: 23px"><font class="black">Matching Leads (= data.Tables[0].Rows.Count  Total)</font></td>--%>
			
		<%--	<%int a = GridView1.Rows.Count; %>--%>
			<td align="center" style="height: 23px"><font class="black">Matching Leads</font><asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="arial" Font-Size="9pt"></asp:Label><br />
                <asp:Button ID="downloadAll" runat="server" Font-Size="8pt" 
                    onclick="downloadAll_Click" Text="Download This Data" /></td>
		<%--	<%Label1.Text = " " + a + " Total"; %>--%>
		</tr>
		<%--Date 29 Nov 2007 Akhil Parashar ---GridView1------%>
		
			<tr>
		
			<td width="1100" align="center">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="true" AllowPaging="True" DataKeyNames="id" AllowSorting="True" OnRowCommand = "GridView1Update" CellPadding="3" Font-Names="Arial" Font-Size="9pt" PageSize="25" Width="103%" DataSourceID="SqlDataSource1" >
                <Columns>
                 <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
                        <asp:CheckBox ID="chkReAssignSelect"  runat="server" />
                     </ItemTemplate>
                    <HeaderTemplate>
                    <input id="chkAll"  onclick="javascript:SelectAllCheckboxes(this);" 
                    runat="server" type="checkbox"  /> 
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnaassign" runat="server" Text="Re-Assign"  CommandName="Re-Assign" CommandArgument='<%# Eval("id") %>'/>
                        </ItemTemplate></asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="true" CommandName="Select"
                                    Text="Info" CommandArgument='<%# Eval("id") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
             <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btdelete" runat="server" Text="Delete"  CommandName="Deletestudent" OnClientClick="return confirm('Are you sure you want to delete this Record?');" CommandArgument='<%# Eval("id") %>'/>
                    </ItemTemplate>
             </asp:TemplateField> 
                </Columns>
                    <EditRowStyle Font-Strikeout="False" />
                    <SelectedRowStyle Font-Bold="True" />
                    <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                    <AlternatingRowStyle BackColor="#F7F7F7" />
                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                    <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                </asp:GridView>
                

	<font class="black">Re-Assign Selected To: &nbsp;</font>
	<select name="user"><%= printUserList() %></select>
	 <asp:Button ID="Button1" runat="server" onclick="AssignGroup" text="Re-Assign Selected" /> 
			</td>
		</tr>
		</table>
	

		


	<% }else if(Session["astate"].ToString() == "reassign") {
		//DataSet tmp = getMssqlData(@"SELECT client_last_name + ',' + client_first_name as [Client Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE id = '" + Session["reassign"] + "';");
        DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON users.userid = d.userid WHERE [id] = " + Session["reassign"] + ";");   
                
	%>
	
		<table border="0" cellpadding="4" cellspacing="4" align="center" style="vertical-align :top" width="100%">

		<tr>
			<td align="center"><font class="black">Re-Assign Lead</font></td>
		</tr>
		<tr>
			<td align="center">
				<table border="0" cellpadding="4" cellspacing="4" align="center" style="vertical-align :top" width="70%">
				<tr>
					<td><font class="red">Student Name&nbsp;</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Student Name"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Assigned To</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Assigned To"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Home Phone</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Home Phone"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Status</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Status"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Re-Assign To</font></td>
					<td>
					<select name="user">
						<%= printUserList() %>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignLead" runat="server" text="Re-Assign Lead" onClick="updateDB" />&nbsp;
						<asp:Button id="cancelReAssignLead" runat="server" text="Cancel" onClick="cancelAssign" />
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>

		<% } %>


	</td>
</tr>
</table>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:oldcrsdb %>"
        SelectCommand=""></asp:SqlDataSource>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>