<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="Google.GData.Client" %>
<%@ Import Namespace="Google.GData.Calendar" %>
<%@ Import Namespace="Google.GData.Extensions" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<script type="text/javascript">
    
    var dtCh= "/";
    var minYear=1900;
    var maxYear=2100;

    function isInteger(s){
        var i;
        for (i = 0; i < s.length; i++){   
            // Check that current character is number.
            var c = s.charAt(i);
            if (((c < "0") || (c > "9"))) return false;
        }
        // All characters are numbers.
        return true;
    }

    function stripCharsInBag(s, bag){
        var i;
        var returnString = "";
        // Search through string's characters one by one.
        // If character is not in bag, append to returnString.
        for (i = 0; i < s.length; i++){   
            var c = s.charAt(i);
            if (bag.indexOf(c) == -1) returnString += c;
        }
        return returnString;
    }

    function daysInFebruary (year){
        // February has 29 days in any year evenly divisible by four,
        // EXCEPT for centurial years which are not also divisible by 400.
        return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
    }
    function DaysArray(n) {
        for (var i = 1; i <= n; i++) {
            this[i] = 31
            if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
            if (i==2) {this[i] = 29}
       } 
       return this
    }

    function isDate(dtStr){
        var daysInMonth = DaysArray(12)
        var pos1=dtStr.indexOf(dtCh)
        var pos2=dtStr.indexOf(dtCh,pos1+1)
        var strMonth=dtStr.substring(0,pos1)
        var strDay=dtStr.substring(pos1+1,pos2)
        var strYear=dtStr.substring(pos2+1)
        strYr=strYear
        if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
        if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
        for (var i = 1; i <= 3; i++) {
            if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
        }
        month=parseInt(strMonth)
        day=parseInt(strDay)
        year=parseInt(strYr)
        if (pos1==-1 || pos2==-1){
            alert("The date format should be : mm/dd/yyyy")
            return false
        }
        if (strMonth.length<1 || month<1 || month>12){
            alert("Please enter a valid month")
            return false
        }
        if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
            alert("Please enter a valid day")
            return false
        }
        if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
            alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
            return false
        }
        if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
            alert("Please enter a valid date")
            return false
        }
    return true
    }

    function validateSchedule(){
        var dt=document.getElementById('date')
        if (isDate(dt.value)==false){
            dt.focus()
            return false
        }
        var hr=document.getElementById('hour')
        var mn=document.getElementById('min')
        var ampm=document.getElementById('ap')
        var loc=document.getElementById('location')
        var time = hr.options[hr.selectedIndex].text + ':' + mn.options[mn.selectedIndex].text + ' ' + ampm.options[ampm.selectedIndex].text;
        var locationname = loc.options[loc.selectedIndex].text + '';
        return confirm('The appointment will be set for:\n\nDate:     ' + dt.value + '\nTime:     ' + time + '\nLocation: ' + locationname + '\n\nIs this correct?');
     }   
    function loadDFlink()      
    {
        var id = '<%= Session["id"].ToString() %>';
        var myDFtd = document.getElementById('dflinktd');
        myDFtd.innerHTML = '<iframe width="95%" height="40px" border="1" src="../dfLink.aspx?ID=' + id + '"></iframe>';
    }
</script>
<script runat="server">

    //DataSet data;
    string satta = string.Empty;
    public void Page_Load()
    {
        if (Session["id"] != null)
        {
            try
            {
                SQLManager.StoredProcedure setUrgency = new SQLManager.StoredProcedure("UpdateUrgency");
                setUrgency.AddParam("myCaseID", Session["id"].ToString());
                setUrgency.ExecuteNQ();
            }
            catch (Exception Ex)
            {

            }
        }
        if (Session["userid"] == null || Session["userid"].ToString() == "" )
        {
            Response.Redirect("./timeout.aspx");
        }
        if (Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern")
        {
            Response.Redirect("./nopriv.aspx");
        }
        if (!Page.IsPostBack)
        {
            Session["cancel"] = "";
            Session["view"] = "three";
            DataTable myReps = SQLManager.GetData("userid,name", "users", "WHERE (account_type='representative' OR account_type='admin') and active='1' ORDER BY name ASC");
            repDDL.DataSource = myReps;
            repDDL.DataTextField = "name";
            repDDL.DataValueField = "userid";
            repDDL.DataBind();
            refreshPage();
        }
    }

    protected void refreshPage()
    {
        setupLocation();
        caseidlabel.Text = Session["id"].ToString();
        string sql = "SELECT appointments.id as 'ID',appointments.appointment as 'Appointment Time',users.name as 'Name', locations.name as 'Location', appointments.apptstatus as 'Status',appointments.apptclient as 'Client',appointments.note as 'Appointment Notes', appointments.appt_set_date AS 'Set Date', appointments.Outcome AS 'Autoresponders' FROM appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC ";
        if (Session["view"] != null && Session["view"].ToString() == "three")
            sql = "SELECT TOP 3 appointments.id as 'ID',appointments.appointment as [Appointment Time],users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status],appointments.apptclient as [Client], appointments.note as [Appointment Notes], appointments.appt_set_date AS 'Set Date', appointments.Outcome AS 'Autoresponders' FROM appointments as appointments INNER JOIN users as users on users.userid = appointments.userid INNER JOIN locations as locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC";
        string config = ConfigurationManager.ConnectionStrings["oldcrsdb"].ConnectionString.ToString();
        SqlDataAdapter sdapt = new SqlDataAdapter(sql, config);
        DataSet ds = new DataSet();
        sdapt.Fill(ds, "temp1");
        GridView1.DataSource = ds.Tables[0].DefaultView;
        GridView1.DataBind();
        DataTable myNotes = SQLManager.GetData("TOP 5 convert(varchar(10),n.createdDate,101) as [Date], u.name as [Name], n.note as [Note]","notes n LEFT OUTER JOIN users u ON n.createdBy=u.userid","WHERE n.claimid='" + Session["id"].ToString() + "' AND n.note <> '' order by n.id desc");
        DataList1.DataSource = myNotes;
        DataList1.DataBind();
        /*
        int myGradYear = Convert.ToInt32(SQLManager.GetValue("col0020", "mfac_client_data2", "where id='" + Session["id"].ToString() + "'"));
        int lastseason = DateTime.Now.Year;
        if (DateTime.Now.Month > 6 && DateTime.Now.Day > 15)
            lastseason++;
        lastseason--;
        int days1, days2, days3;
        if (myNotes.Rows.Count > 0 && myNotes.Rows[0]["date"] != DBNull.Value)
        {
            days2 = Math.Min(new TimeSpan(DateTime.Now.Ticks - DateTime.Parse(myNotes.Rows[0]["date"].ToString()).Ticks).Days, 45);
            if (myNotes.Rows.Count > 1 && myNotes.Rows[0]["date"] != DBNull.Value)
                days1 = Math.Min(new TimeSpan(DateTime.Now.Ticks - DateTime.Parse(myNotes.Rows[1]["date"].ToString()).Ticks).Days, 45);
            else
                days1 = 45;
        }
        else
        {
            days1 = 45;
            days2 = 45;
        }
        days3 = Math.Max(days1, days2) - Math.Min(days1, days2);
        double note1score = (12.5 * Math.Pow(1.04729006366822, days1));
        double note2score = (12.5 * Math.Pow(1.04729006366822, days2));
        double note3score = (12.5 * Math.Pow(1.04729006366822, days3));
        double yearscore = (Math.Max(1/(Math.Max(myGradYear - lastseason,0)-0.5+(0.5*Math.Max(myGradYear - lastseason,0))),0) * 100);

        double urgencyScore = (0.35 * note1score);
        urgencyScore += (0.10 * note2score);
        urgencyScore += (0.05 * note3score);
        urgencyScore += (0.50 * yearscore);
        urgencyScore = Math.Round(urgencyScore, 1);
        urgency.Text = urgencyScore.ToString(); // + "<br />note1score: " + note1score.ToString() + "<br />note2score: " + note2score.ToString() + "<br />note3score: " + note3score.ToString() + "<br />yearscore: " + yearscore.ToString() + "<br />myGradYear: " + myGradYear.ToString() + "<br />lastseason: " + lastseason.ToString()
        */
        DataTable myAccounts = SQLManager.GetDataPrimitive("SELECT active, userid, name, username, password, emailaddress from users WHERE usercase='" + Session["id"].ToString() + "'");
        DataTable myProducts = SQLManager.GetDataPrimitive("Select u.userid, p.name, pbu.product, pbu.active FROM CRM_ProductsByUser pbu INNER JOIN users u ON u.userid=pbu.userid INNER JOIN CRM_Products p ON pbu.product=p.id where u.usercase='" + Session["id"].ToString() + "' order by pbu.product, u.userid");
        if (myProducts.Rows.Count > 0)
        {
            myAccounts.Columns.Add(myProducts.Rows[0]["name"].ToString(), System.Type.GetType("System.String"));
            for (int i = 0; i < myAccounts.Rows.Count; i++)
                if (myAccounts.Rows[i]["userid"].ToString() == myProducts.Rows[i]["userid"].ToString())
                    myAccounts.Rows[i][myProducts.Rows[0]["name"].ToString()] = myProducts.Rows[0]["active"].ToString();
            for (int j = 1; j < myProducts.Rows.Count; j++)
            {
                if(myProducts.Rows[j]["product"].ToString() != myProducts.Rows[j-1]["product"].ToString())
                    myAccounts.Columns.Add(myProducts.Rows[j]["name"].ToString(), System.Type.GetType("System.String"));
                for (int i = 0; i < myAccounts.Rows.Count; i++)
                    if (myAccounts.Rows[i]["userid"].ToString() == myProducts.Rows[j]["userid"].ToString())
                        myAccounts.Rows[i][myProducts.Rows[j]["name"].ToString()] = myProducts.Rows[j]["active"].ToString();
            }
        }
        
        LoginTable.DataSource = myAccounts;
        LoginTable.DataBind();
        DataTable myTasks = TaskManager.getTasksByCase(Convert.ToInt32(Session["id"].ToString()));
        DataList2.DataSource = myTasks;
        DataList2.DataBind();
        DataTable myProductTasks = TaskManager.getProductTasksByCase(Convert.ToInt32(Session["id"].ToString()));
        DataList3.DataSource = myProductTasks;
        if(myProductTasks.Rows.Count >= 1)
            DataList3.DataBind();
        UpdatePanel1.Update();
    }

    protected void setupLocation()
    {
        G2Mlabel.Visible = false;
        G2Mbutton.Visible = false;
        G2Mbox.Visible = false;
        addG2MIDButtom.Visible = false;
        try
        {
            DataTable myAppt = SQLManager.GetData("id,locationid,gotomeetingID", "appointments", "WHERE claimid='" + Session["id"].ToString() + "' AND status='Y'");
            if (myAppt.Rows.Count < 1) return;
            if (myAppt.Rows[0]["locationid"].ToString() == "13")
            {
                if (myAppt.Rows[0]["gotomeetingID"] == DBNull.Value || myAppt.Rows[0]["gotomeetingID"].ToString().Length < 9)
                    addG2MIDButtom.Visible = true;
                else
                {
                    G2Mlabel.Visible = true;
                    G2Mlabel.Text = myAppt.Rows[0]["gotomeetingID"].ToString();
                }
            }
            else
            {
                G2Mlabel.Visible = false;
                G2Mbutton.Visible = false;
                G2Mbox.Visible = false;
                addG2MIDButtom.Visible = false;
            }
        }
        catch (Exception ex)
        {
            G2Mlabel.Visible = false;
            G2Mbutton.Visible = false;
            G2Mbox.Visible = false;
            addG2MIDButtom.Visible = false;
        }
    }
    
    public string getMeeting(DataSet tmp)
    {
        if (tmp.Tables[0].Rows[0]["gotomeetingID"] != DBNull.Value && tmp.Tables[0].Rows[0]["gotomeetingID"].ToString() != string.Empty)
        {
            G2Mlabel.Visible = true;
            G2Mbox.Visible = false;
            G2Mbutton.Visible = false;
            addG2MIDButtom.Visible = false;
            return tmp.Tables[0].Rows[0]["gotomeetingID"].ToString();
        }
        else
        {
            G2Mlabel.Visible = false;
            addG2MIDButtom.Visible = true;
            G2Mbox.Visible = false;
            G2Mbutton.Visible = false;
            return string.Empty;
        }
    }
    
    protected void createAccount()
    {
        int id = Convert.ToInt32(Session["id"].ToString());
        PasswordGenerator pwgen = new PasswordGenerator();
        string randomPW = pwgen.Generate();

        string getUserInfo = "SELECT col0018 as emailaddress, col0018 as username, col0002 as firstname, col0004 as lastname FROM mfac_parent_info WHERE claimid='" + id.ToString() + "' and id=1";
        string getUserInfo2 = "SELECT col0013 as phone, col0020 as usergradyear, col0018 as highschool FROM mfac_client_data2 WHERE id='" + id.ToString() + "'";

        SqlConnection sCon = new SqlConnection(ConfigurationManager.ConnectionStrings["oldcrsdb"].ToString());
        SqlCommand checkUser = new SqlCommand("SELECT COUNT(*) FROM users WHERE usercase='" + id.ToString() + "'",sCon);
        SqlCommand getUI1 = new SqlCommand(getUserInfo, sCon);
        SqlCommand getUI2 = new SqlCommand(getUserInfo2, sCon);
        SqlDataReader reader = null;
        DataTable dt1 = new DataTable();
        DataTable dt2 = new DataTable();

        sCon.Open();
        int ucount = (int)checkUser.ExecuteScalar();
        if (ucount > 0)
        {
            sCon.Close();
            return;
        }
        reader = getUI1.ExecuteReader();
        dt1.Load(reader);
        reader.Close();
        reader = getUI2.ExecuteReader();
        dt2.Load(reader);
        reader.Close();

        string email = dt1.Rows[0]["emailaddress"].ToString();
        if (email == null || email == "")
        {
            sCon.Close();
            return;
        }

        string highschool = dt2.Rows[0]["highschool"].ToString();
        string fname = dt1.Rows[0]["firstname"].ToString();
        string lname = dt1.Rows[0]["lastname"].ToString();

        string newUserStr = "INSERT INTO users (random,parentOrStudent,lastEmailSent,account_creation_date, active, emailaddress, name, password, phone, username, password_expiration_date, password_set_date, account_type, usergradyear, usercase) VALUES ('" + pwgen.Generate() + "','Parent','" + DateTime.Now.ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','1','" + dt1.Rows[0]["emailaddress"].ToString().Replace("'", "''") + "','" + dt1.Rows[0]["firstname"].ToString().Replace("'", "''") + " " + dt1.Rows[0]["lastname"].ToString().Replace("'", "''") + "','" + randomPW + "','" + dt2.Rows[0]["phone"].ToString() + "','" + dt1.Rows[0]["username"].ToString().Replace("'", "''") + "','" + System.DateTime.Now.AddMonths(3).ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','Customer','" + dt2.Rows[0]["usergradyear"].ToString() + "','" + id.ToString() + "')";
        SqlCommand sCmd = new SqlCommand(newUserStr, sCon);
        sCmd.ExecuteNonQuery();
        sCon.Close();
    }
    
    private void sendInfo(bool isFollowUpAppt)
    {
        string crlf = "<br>";
        string t = Request["date"] + " " + Request["hour"] + ":" + Request["min"] + " " + Request["ap"];
        string claimid = Session["id"].ToString();
        string locationid = Request["location"];
        DataSet l = getMssqlData("SELECT name FROM locations WHERE id = '" + locationid + "'");
        locationid = l.Tables[0].Rows[0]["name"].ToString();

        string sql = "SELECT col0002, col0004,col0007,col0009,col0010,col0011,col0013,col0018,col0020 FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"];
        DataSet data = getMssqlData(sql);

        sql = "SELECT col0002, col0004,col0015,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"];
        DataSet parent = getMssqlData(sql);

        sql = "SELECT col0015 FROM " + Session["mainParentTable"] + " WHERE [id] = 2 AND [claimid] = " + Session["id"];
        DataSet parent1 = getMssqlData(sql);
        
        try
        {
            string gUserName = "nziering@college-retirement.com";
            if (isFollowUpAppt)
                gUserName = "followup@college-retirement.com";
            string gPassword = "shunp1ke";
            CalendarQuery query = new CalendarQuery();
            CalendarService service = new CalendarService("CRS-adminCal-1");
            // Set your credentials:
            GDataCredentials cred = new GDataCredentials(gUserName, gPassword);
            service.Credentials = cred;

            Google.GData.Calendar.EventEntry entry = new Google.GData.Calendar.EventEntry();

            Where eventLocation = new Where();
            eventLocation.ValueString = locationid;

            if (locationid == "Web Meeting")
                locationid = "Web";

            entry.Title.Text = locationid + " - " + parent.Tables[0].Rows[0]["col0004"] + " - " + claimid;
            entry.Content.Content = parent.Tables[0].Rows[0]["col0002"].ToString().Replace("&", "and") + " " + parent.Tables[0].Rows[0]["col0004"] + "\t\t" + data.Tables[0].Rows[0]["col0002"] + "\n" +
                                    parent.Tables[0].Rows[0]["col0018"] + "\t\t" + data.Tables[0].Rows[0]["col0018"] + "\n" +
                                    data.Tables[0].Rows[0]["col0007"] + "\t\tGrad: " + data.Tables[0].Rows[0]["col0020"] + "\n" +
                                    data.Tables[0].Rows[0]["col0009"] + ", " + data.Tables[0].Rows[0]["col0010"] + " " + data.Tables[0].Rows[0]["col0011"] + "\n" +
                                    "H: " + data.Tables[0].Rows[0]["col0013"] + "\n" +
                                    "W: " + parent.Tables[0].Rows[0]["col0015"] + "\n" +
                                    "W: " + parent1.Tables[0].Rows[0]["col0015"] + "\n" +
                                    "\n" +
                                    "Appt: " + t + " " + locationid + "\n" +
                                    "[ID: " + claimid + "] (" + Session["name"] + ")";

            entry.Locations.Add(eventLocation);
            
            // Get Hosting Timezone
            TimeZoneInfo hz = TimeZoneInfo.FindSystemTimeZoneById("Mountain Standard Time");
            
            // Get Eastern Standard Timezone
            TimeZoneInfo tz = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
            
            // Convert event time to Eastern Standard Time
            DateTime sTime = TimeZoneInfo.ConvertTime(DateTime.Parse(t), tz, tz);
            
            DateTime hTime = TimeZoneInfo.ConvertTime(DateTime.Parse(t), tz, hz);
            
            When eventTime = new When(hTime, hTime.AddHours(1));
            
            entry.Times.Add(eventTime);

            Uri postUri = new Uri("http://www.google.com/calendar/feeds/8ph2qah9jms7pk67tb8higrfrk@group.calendar.google.com/private/full");
            if (isFollowUpAppt)
            {
                postUri = new Uri("http://www.google.com/calendar/feeds/followup%40college-retirement.com/private/full");
            }
            // Send the request and receive the response:
            AtomEntry insertedEntry = service.Insert(postUri, entry);
            message.Text += "<br />Appointment successfully posted to Google Calendar.";
            
        }
        catch (Exception gExc)
        {
            //throw(new Exception(gExc.Message));
            string mailBody = "Appointment Info:" + crlf + crlf +
                parent.Tables[0].Rows[0]["col0002"].ToString().Replace("&", "and") + " " + parent.Tables[0].Rows[0]["col0004"] + "\t\t" + data.Tables[0].Rows[0]["col0002"] + crlf +
                parent.Tables[0].Rows[0]["col0018"] + "\t\t" + data.Tables[0].Rows[0]["col0018"] + crlf +
                data.Tables[0].Rows[0]["col0007"] + "\t\tGrad: " + data.Tables[0].Rows[0]["col0020"] + crlf +
                data.Tables[0].Rows[0]["col0009"] + ", " + data.Tables[0].Rows[0]["col0010"] + " " + data.Tables[0].Rows[0]["col0011"] + crlf +
                "H: " + data.Tables[0].Rows[0]["col0013"] + crlf +
                "W: " + parent.Tables[0].Rows[0]["col0015"] + crlf +
                "W: " + parent1.Tables[0].Rows[0]["col0015"] + crlf +
                crlf +
                "Appt: " + t + " " + locationid + crlf +
                "[ID: " + claimid + "]";
            AutomatedEmailManager.ExecuteHtmlSendMail("info@college-retirement.com", "info@college-retirement.com", "Error posting appointment to Google Calendar", mailBody); 
            
            message.Text += "<br />Error posting appointment to Google Calendar - Notice of error successfully sent to info@college-retirement.com";
        }
    }

    private string getRandom(string id)
    {
        SqlConnection sCon = new SqlConnection(ConfigurationManager.ConnectionStrings["oldcrsdb"].ToString());
        SqlCommand sCmd = new SqlCommand("SELECT random FROM users WHERE usercase='" + id + "'", sCon);
        sCon.Open();
        string random = (string)sCmd.ExecuteScalar();
        sCon.Close();
        return random;
    }

    private void scheduleAppointment(Object obj, EventArgs args)
    {
        message.Text = "";
        string t = Request["date"] + " " + Request["hour"] + ":" + Request["min"] + " " + Request["ap"];
        DataSet tmp = getMssqlData("SELECT * FROM appointments WHERE claimid = '" + Session["id"] + "' AND status = 'Y'");
        if (tmp.Tables.Count > 0)
        {
            if (tmp.Tables[0].Rows.Count > 0)
            {
                message.Text = "** You can only have one active appointment. **";
                return;
            }
        }
        try
        {
            Convert.ToDateTime(t);
        }
        catch
        {
            message.Text = "** The date/time you submitted is invalid. **";
            return;
        }
//        try
//        {
            createAccount();
            string sql = "INSERT INTO appointments (appt_set_date,claimid,userid,appointment,locationid,status,pending) VALUES('" + DateTime.Now.ToString() + "','" + Session["id"] + "','" + Session["userid"] + "','" + t + "','" + Request["location"] + "','Y','1');";
            getMssqlData(sql);

            //          sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled' WHERE [id] = " + Session["id"];
            //          sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled', nextApptDate = '" + t + "', nextApptLocationid = '" + Request["location"] + "' WHERE [id] = " + Session["id"];

            // update appointment and location listing in main record
            sql = "UPDATE " + Session["mainDataTable"] + " SET nextApptDate = '" + t + "', nextApptLocationid = '" + Request["location"] + "' WHERE [id] = " + Session["id"];
            getMssqlData(sql);
            // only change status to Scheduled if not payment authorized
            sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled' WHERE [id] = " + Session["id"] + " AND [status] != 'Payment Authorized'";
            getMssqlData(sql);
            Session["state"] = "list";

            // Set variables
/*            string clientName, email, location, AdvisorName = null;
            string sqlStr = null;
            string sAttach = null;
*/            string eventKey = null;
            string eventKey2 = null;
            string claimid = Session["id"].ToString();
            string locationid = Request["location"];
/*            int hour = Convert.ToInt32(Request["hour"]);
            string emailFrom = "auto-confirm@college-retirement.com";
            string sBody1 = "<b>Thank you for scheduling your free no-obligation consultation with ";
            string sBody = "<a href=\"http://www.college-retirement.com/learnmore.html\">Click here</a> to learn more about what you can expect " +
                        "of this evaluation from College and Retirement Solutions.<br><br><b>Below is the link to our Data Form. Please complete it and return it to us no less than one day in advance of your meeting, so that an analyst may have time to properly prepare for your meeting and make the best use of your time.</b> ";
            string sBody2 = "Sensitive information can be left blank.<br>" +
                        "<br><center><font size=5>&raquo; <b><a href=\"http://www.college-retirement.com/onlinedataform/DataForm.aspx?ID=" + getRandom(claimid) + claimid + "\">Data Form for your Evaluation</a></b> &laquo;</font></center><br>";
*/            /*            
                        string sBody = "<a href=\"http://www.college-retirement.com/learnmore.html\">Click here</a> to learn more about what you can expect " +
                                    "of this evaluation from College and Retirement Solutions.<br><br><b>Attached is the client data form (in two different formats) " +
                                    "that must be completed ";
                        string sBody2 = "Use whichever one you can open.  Social Security numbers or other sensitive information can be left blank. ";   
            */
/*            string sBody3 = "please contact us at 973-514-2002 at least 48 hours in advance.</b><br><br>We look forward to meeting with you! " +
                        " <br><br>Sincerely, <br>";
            string appt = "Your evaluation is set for: <br><br><center><font size=5 color=CC6666> " + t;
            string sFooter = "<br>---------------------------------------------------------------------------------------------- <br>" +
                        "<font size=1>If investment, financial or insurance planning or products are required, College and Retirement " +
                        "Solutions, LLC (CRS) may refer you to one of its affiliates, including The Ziering Insurance Agency.  Any " +
                        "discussion of the tax implications of planning is strictly for general purposes.  Neither CRS nor its " +
                        "representatives may give specific tax advice.  Advice and counsel should be sought out from their accountant " +
                        "and/or tax advisor for information regarding their own particular situation.</font><br><br>" +
                        "<font color=red><b>*** DO NOT REPLY TO THIS MESSAGE.  THIS IS AN AUTOMATIC EMAIL NOTIFICATION. IF YOU NEED TO CONTACT US, " +
                        "PLEASE EMAIL US AT info@college-retirement.com TO ENSURE YOUR MESSAGE IS DELIVERED ***</font><b>";

            sqlStr = "SELECT * FROM " + Session["mainDataTable"] + " WHERE id = " + claimid;
            DataSet mfac_data = getMssqlData(sqlStr);

            // Advisor Name
            if (mfac_data.Tables[0].Rows[0]["userid"].ToString() != "")
            {
                sqlStr = "SELECT name FROM users WHERE userid = '" + mfac_data.Tables[0].Rows[0]["userid"] + "'";
                DataSet repdata = getMssqlData(sqlStr);
                AdvisorName = repdata.Tables[0].Rows[0]["name"].ToString();
                if (mfac_data.Tables[0].Rows[0]["userid"].ToString() == "34")
                {
                    AdvisorName = AdvisorName + ", CCPS<br>President";
                }
            }

            sqlStr = "SELECT col0002 + ' ' + col0004 as [client_name],col0018 FROM " + Session["mainParentTable"] + " WHERE id = 1 AND claimid = " + claimid;
            DataSet parent = getMssqlData(sqlStr);
            // Parent Name and Email
            clientName = parent.Tables[0].Rows[0]["client_name"].ToString();
            email = parent.Tables[0].Rows[0]["col0018"].ToString();

            // Location
            DataSet l = getMssqlData("SELECT name FROM locations WHERE id = '" + locationid + "'");
            location = l.Tables[0].Rows[0]["name"].ToString();

            // 12-13-06 Sending email confirmation out automatically
            //MailMessage msg = new MailMessage();
            string msgTo, msgFrom, msgSubject, msgBody = null;


            if (email == "")
            {
                msgTo = "info@college-retirement.com";
                msgFrom = emailFrom;
                msgSubject = "Need to Schedule Appt Manually: [id = " + claimid + "]";
                msgBody = "There is no email in the database for client [" + clientName + "].  The claim id is [" + claimid +
                    "]. The Representative for this case is [" + AdvisorName + "]. Please get the email so we can send the " +
                    "client a confirmation email. The appointment is scheduled for " + t + ".  Location = " + location + ".";
            }
            else
           {
*/                 //                switch (locationid)
                //                {
                //                    case "1":
                //                        sAttach = "CRS_RedBank.pdf";
                //                        break;
                //                    case "3":
                //                        /* sAttach = "MFAC_Saddlebrook.pdf"; */
                //                        break;
                //                    case "4":
                //                        sAttach = "CRS_Chatham.pdf";
                //                        break;
                //                    case "7":
                //                        /* sAttach = "MFAC_Mahwah.pdf"; */
                //                        break;
                //                    case "12":
                //                        sAttach = "CRS_Edison.pdf";
                //                        break;
                //                    //case "13":
                //                        // 12-7-06 For appointment via web
                //                        //sAttach = "Forms.pdf";     
                //                        //break;
                //                }
                //                MailAttachment myAttachment = new MailAttachment(Server.MapPath(sAttach));
                //                msg.Attachments.Add(myAttachment);
/*                switch (locationid)
                {
                    case "1":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_RedBank.pdf\">Click Here</a> for directions to our Red Bank office.";
                        break;
                    case "4":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_Chatham.pdf\">Click Here</a> for directions to our Chatham office.";
                        break;
                    case "12":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_Edison.pdf\">Click Here</a> for directions to our Edison office.";
                        break;
                }

                msgTo = email;
                //msg.Bcc = "info@college-retirement.com";
                msgFrom = emailFrom;
                msgSubject = "Appointment Confirmation on " + t;
                //msg.BodyFormat = MailFormat.Html;
                if (locationid == "13")
                {
                    // msg.Attachments.Add (new MailAttachment(Server.MapPath("dataform.xls")));
                    // web meeting email confirm
                    msgBody = "Dear " + clientName + ",<br><br>" +
                        sBody1 + "College and Retirement Solutions. " + appt + " on the Web.</font></center></b><br>" +
                        "<b>You will receive a web link and a phone call with instructions on how to access the meeting 1-2 days before " +
                        "your scheduled appointment.</b><br><br>" + sBody +
                        sBody2 + "In the mean time, please fill out the data form. " +
                        "If you need to reschedule for any reason, " + sBody3 + AdvisorName + sFooter;
                }
                else
                {
                    //                    msg.Attachments.Add(new MailAttachment(Server.MapPath("Forms.pdf")));
                    //                    msg.Attachments.Add (new MailAttachment(Server.MapPath("dataform.xls")));
                    msgBody = "Dear " + clientName + ",<br><br>" +
                         sBody1 + "our college planning specialist at College and Retirement Solutions, LLC. " + appt + " in " + location
                         + ", NJ</font></center></b><br>" +
                        "<i>This appointment will take about an hour, and it is designed to measure your expected college costs. </i>" + sBody +
                        sBody2 + sAttach + " " +
                        "<b> If you have any questions or concerns, or you need to reschedule your appointment, " + sBody3 + AdvisorName + sFooter;
                }

            }
            //SmtpMail.Send(msg);
            ExecuteHtmlSendMail(msgFrom, msgTo, msgSubject, msgBody, "info@college-retirement.com");
*/          
            

            switch (locationid)
            {
                case "1":
                    eventKey = "setredbankappt";
                    eventKey2 = "redbankapptdate";
                    break;
                case "4":
                    eventKey = "setchathamappt";
                    eventKey2 = "chathamapptdate";
                    break;
                case "12":
                    eventKey = "setedisonappt";
                    eventKey2 = "edisonapptdate";
                    break;
                case "13":
                    eventKey = "setwebappt";
                    eventKey2 = "webapptdate";
                    break;
            }
            if (Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "admin" && followUp != null && followUp.Checked)
            {
                int myApptID = SQLManager.getMax("id", "appointments", "WHERE claimid='" + claimid.ToString() + "'");
                int numFollowUps = SQLManager.Count("*", "CRM_Follow_Up_Appointments", "WHERE claimid='" + claimid.ToString() + "'");
                string followUpEventStr = "fuapptset";
                if (numFollowUps > 0)
                    followUpEventStr += "2";
                EventManager.Trigger(followUpEventStr, claimid, false, true);
                SQLManager.GeneralNonQuery("INSERT INTO CRM_Follow_Up_Appointments (claimid, apptid) VALUES ('" + claimid.ToString() + "','" + myApptID.ToString() + "')");
                sendInfo(true);
            }
            else
            {
                EventManager.Trigger(eventKey, claimid, false, true);
                EventManager.Trigger(eventKey2, claimid, false, true);
                sendInfo(false);
            }
            message.Text = "Appointment Scheduled.";
            refreshPage();
//        }
//        catch (Exception e)
//        {
//            message.Text = "** Could not submit appointment. **<br>" + e.Message + "<br>" + t;
//            return;
//        }
    }

    private void cancelAppointment(object obj, EventArgs args)
    {
        Session["cancel"] = Request["cancel"];
        arListBox.SelectedValue = "noautoresponders";
        return;
    }
    private void backAppointment(Object obj, EventArgs args)
    {
        Session["cancel"] = "";
        return;
    }

    private void updateDB(object obj, EventArgs args)
    {
        message.Text = "";
        try
        {
/*            if (Request["reason"] == null || Request["reason"] == "")
            {
                message.Text = "** You must submit follow up notes to close. **";
                Session["cancel"] = Request["id"];
                return;
            }
            else
            {
*/
                EventManager.Trigger("apptclosed", Session["id"].ToString(), true, false);
                string outcome = string.Empty;
                foreach (ListItem Item in arListBox.Items)
                {
                    if (Item.Selected)
                    {
                        outcome += ", " + Item.Text.Trim();
                        if (Item.Value != "none" && Item.Value != "noautoresponders")
                            EventManager.Trigger(Item.Value, Session["id"].ToString());
                    }
                }
                if (rebookNotice.Checked)
                {
                    EventManager.Trigger("rebookNotice", Session["id"].ToString());
                }
                if (rebookNotice2.Checked)
                {
                    EventManager.Trigger("resetOffice", Session["id"].ToString());
                }
                
                outcome = outcome.Substring(2);

                string sql = "UPDATE appointments SET Outcome='" + outcome.Replace("'", "''") + "', status = 'N', apptstatus='" + Request["apptstatus"].Replace("'", "''") + "', apptclient='" + Request["apptclient"].Replace("'", "''") + "', note = '" + Request["reason"].Replace("'", "''") + "', cancelledBy = '" + Session["userid"] + "' WHERE claimid = '" + Session["id"] + "' AND id = '" + Request["id"] + "'";
                getMssqlData(sql);          // commented by me
                Session["cancel"] = "";            
                
/*
                string status = Request["apptstatus"].ToString();
                string claimid = Session["id"].ToString();
            
            

                if (status.ToLower() == "no show")
                    EventManager.Trigger("noshow", claimid);
                else if (status.ToLower() == "reschedule")
                    EventManager.Trigger("tbr", claimid);
                else if (status.ToLower() == "showed")
                    EventManager.Trigger("shows", claimid);
            }
*/        }
        catch (Exception ex) 
        { 
            message.Text = "" + ex.Message; 
        }
        refreshPage();
    }
    private void toggleGrid(Object sender, EventArgs e)
    {
        DataSet tmp;
        try
        {
            if (Session["view"].ToString() == "three")
            {
                Session["view"] = "entire";
                tmp = getMssqlData("SELECT appointments.id as 'ID',appointments.appointment as [Appointment Time],users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status],appointments.apptclient as [Client], appointments.note as [Appointment Notes], appointments.appt_set_date AS 'Set Date', appointments.Outcome AS 'Autoresponders' FROM appointments as appointments INNER JOIN users as users on users.userid = appointments.userid INNER JOIN locations as locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC");
                GridView1.DataSource = tmp.Tables[0].DefaultView;
                GridView1.DataBind();

            }
            else
            {
                Session["view"] = "three";
                //tmp = getMssqlData("SELECT TOP 3 appointments.appointment [Appointment Time], users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status], appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM madison_sysdba.appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='N' ORDER BY appointments.appointment DESC");
                tmp = getMssqlData("SELECT TOP 3 appointments.id as 'ID',appointments.appointment as [Appointment Time],users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status],appointments.apptclient as [Client], appointments.note as [Appointment Notes], appointments.appt_set_date AS 'Set Date', appointments.Outcome AS 'Autoresponders' FROM appointments as appointments INNER JOIN users as users on users.userid = appointments.userid INNER JOIN locations as locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC");
                GridView1.DataSource = tmp.Tables[0].DefaultView;
                GridView1.DataBind();

            }
        }
        catch (Exception ex) 
        { 
            message.Text = "" + ex.Message; 
        }
    }
    
    private string checkInput(string inputString)
    {
        inputString = inputString.Replace('[', '<');
        inputString = inputString.Replace(']', '>');
        inputString = inputString.Replace(Environment.NewLine, "<BR />");
        return inputString.Replace("'", "''");
    }

    public string DFView(string myID)
    {
        string forms = SQLManager.GetValue("userHasSubmittedForms", "users", "WHERE usercase='" + myID + "'");
        int viewCount = SQLManager.Count("*", "CRS_Dataforms", "WHERE claimid='" + myID + "'");
        string learningReportLink = "<br><a href=\"../learningStyle/pages/learningStyleReport.php?ID=" + myID + "\" target=\"_blank\">Learning Style</a>";

        if (viewCount < 1)
            return "Not Viewed" + learningReportLink;
        else if (forms.ToUpper() == "N")
            return "<a href=\"../viewDataForm.aspx?ID=" + myID + "\" target=\"_blank\">Not Complete</a>" + learningReportLink;
        else
            return "<a href=\"../viewDataForm.aspx?ID=" + myID + "\" target=\"_blank\">Complete</a>" + learningReportLink;
    }        

    public class PasswordGenerator
    {
        private char[] characterArray;
        private Int32 passwordLength = 8;
        Random randNum = new Random();
        public PasswordGenerator()
        {
            characterArray = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".ToCharArray();
        }
        private char GetRandomCharacter()
        {
            return this.characterArray[(int)((this.characterArray.GetUpperBound(0) + 1) * randNum.NextDouble())];
        }
        public string Generate()
        {
            StringBuilder sb = new StringBuilder();
            sb.Capacity = passwordLength;
            for (int count = 0; count <= passwordLength - 1; count++)
            {
                sb.Append(GetRandomCharacter());
            }
            if ((sb != null))
            {
                return sb.ToString();
            }
            return string.Empty;
        }
    }

    protected void reassign_button_Click(object sender, EventArgs e)
    {
        SQLManager.GeneralNonQuery("UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + repDDL.SelectedValue + "' WHERE id = '" + Session["id"] + "';");
        refreshPage();
    }

    protected void DataList2_EditCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Complete(Convert.ToInt32(Session["userid"].ToString()));
        refreshPage();
    }
    protected void DataList2_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Delete();
        refreshPage();
    }
    protected void DataList3_EditCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Complete(Convert.ToInt32(Session["userid"].ToString()));
        refreshPage();
    }
    protected void DataList3_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Delete();
        refreshPage();
    }
    
    protected void Button3_Click(object sender, EventArgs e)
    {
        Response.Redirect("../addTask.aspx?ID=" + Session["id"].ToString());
    }

    protected void addG2MIDButtom_Click(object sender, EventArgs e)
    {
        G2Mlabel.Visible = false;
        G2Mbox.Visible = true;
        G2Mbutton.Visible = true;
        addG2MIDButtom.Visible = false;
    }

    protected void G2Mbutton_Click(object sender, EventArgs e)
    {
        string myG2Mid = G2Mbox.Text;
        SQLManager.GeneralNonQuery("UPDATE appointments SET gotomeetingID='" + myG2Mid + "' WHERE claimid='" + Session["id"].ToString() + "' AND status='Y'");
        G2Mbox.Visible = false;
        G2Mbutton.Visible = false;
        addG2MIDButtom.Visible = false;
        G2Mlabel.Visible = true;
        G2Mlabel.Text = myG2Mid;
    }

    protected void AddNewUser_Click(object sender, EventArgs e)
    {
        string[] names = newUser_Name.Text.Split(' ');
        string fname = names[0];
        string lname = fname;
        if (names.Length > 0)
            lname = newUser_Name.Text.Substring((fname.Length) + 1);
        string gradyear = SQLManager.GetValue("col0020", "mfac_client_data2", "WHERE id='" + Session["id"].ToString() + "'");
        SQLManager.GeneralNonQuery("INSERT INTO users (random,parentOrStudent,lastEmailSent,account_creation_date, active, emailaddress, name, password, phone, username, password_expiration_date, password_set_date, account_type, usergradyear, usercase) VALUES ('" + (new PWGen()).Generate() + "','Parent','" + DateTime.Now.ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','1','" + newUser_Email.Text.Replace("'", "''") + "','" + fname.Replace("'", "''") + " " + lname.Replace("'", "''") + "','" + (new PWGen()).Generate() + "','1111111111','" + newUser_Email.Text.Replace("'", "''") + "','" + System.DateTime.Now.AddYears(5).ToShortDateString() + "','" + System.DateTime.Now.ToShortDateString() + "','Customer','" + gradyear + "','" + Session["id"].ToString() + "')");
        int myUserID = SQLManager.getMax("userid","users","where usercase='" + Session["id"].ToString() + "'");
        SQLManager.GeneralNonQuery("INSERT INTO CRM_ProductsByUser (userid, product, active) SELECT '" + myUserID.ToString() + "' as 'userid', pbs.product, 'N' AS 'active' FROM CRM_ProductsBySale pbs INNER JOIN CRM_Sales s on pbs.sale=s.id where s.caseid='" + Session["id"].ToString() + "'");
        newUser_Name.Text = newUser_Email.Text = string.Empty;
        refreshPage();
    }

    protected void LoginTable_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ((Button)e.Row.Cells[0].Controls[0]).CommandArgument = e.Row.RowIndex.ToString();
            ((Button)e.Row.Cells[1].Controls[0]).CommandArgument = e.Row.RowIndex.ToString();
        }
    }

    protected void LoginTable_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            Response.Redirect("editUserProducts.aspx?userid=" + LoginTable.Rows[Convert.ToInt32(e.CommandArgument.ToString())].Cells[3].Text);
        }
        else if (e.CommandName == "Item")
        {
            toggleActive(Convert.ToInt32(LoginTable.Rows[Convert.ToInt32(e.CommandArgument.ToString())].Cells[3].Text));
        }
    }

    protected void toggleActive(int userID)
    {
        string active = SQLManager.GetValue("active", "users", "WHERE userid='" + userID.ToString() + "'");
        if (active == "1")
            active = "0";
        else active = "1";
        SQLManager.GeneralNonQuery("UPDATE users SET active='" + active + "' WHERE userid='" + userID.ToString() + "'");
        refreshPage();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><!--#include file="./title.aspx"--></title>
    <!--#include file="./globalFunctions.aspx"-->
    <LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
    </head>
    <body text="#000000" bgColor="#ffffff" style="text-align: center"  >
    
    <script type="text/javascript">
    function Left(str, n){
        if (n <= 0)
            return "";
        else if (n > String(str).length)
            return str;
        else
            return String(str).substring(0,n);
    }
    function Right(str, n){
        if (n <= 0)
           return "";
        else if (n > String(str).length)
           return str;
        else {
           var iLen = String(str).length;
           return String(str).substring(iLen, iLen - n);
        }
    }

    function fixDate()
    {
        var d = document.getElementById('date');
        var x = d.value;
        if (x.length <=0)
        {
            return;
        }
        var y = x.split("/");
        if (y.length < 2)
        {
            return;
        }
        
        var a = y[0];
        var b = y[1];
        var c = y[2];
        
        if (a.length == 1)
        {
            a = "0" + a;
        }
        if (b.length == 1)
        {
            b = "0" + b;
        }
        if (c.length < 4)
        {
            if (c.length == 1)
            {
                return;
            }
            c = "20" + Right(c,2);
        }
        d.value = a + "/" + b + "/" + c;        
    }
    </script>
    
<!--#include file="./images/case_review_menu/nav.aspx"-->
<form id="Form2" method="post" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

<table border="1" cellpadding="0" cellspacing="0" align="center" style="vertical-align:top;" width="772">
<tr>
    <td align="center">
        <table border="0" cellpadding="4" cellspacing="0" align="center"  style="vertical-align:top;" width="100%">
        <tr>
            <td align="center"><font class="redsm">
                <asp:Label id="message" runat="server"/>
            </font></td>
        </tr></table>
    </td>
</tr><tr>
    <td align="center">
        <%

            string sql = "SELECT userid,status,tax_bracket,est_income,col0004 + ', ' + col0002 as [student_name],col0007,col0009,col0010,col0011,col0013,col0018,col0020,student_hs_city,student_hs_state,seminar_date FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"];
        DataSet data = getMssqlData(sql);
        //data = getMssqlData(sql);

        string Repname;
        
            if (data.Tables[0].Rows[0]["userid"].ToString() != "")
            {
                sql = "SELECT name FROM users WHERE userid = '" + data.Tables[0].Rows[0]["userid"] + "'";
                DataSet repdata = getMssqlData(sql);
                Repname = repdata.Tables[0].Rows[0]["name"].ToString();
            }
            else
            {
                Repname = "Lead Not Assigned";
            }
       

        sql = "SELECT col0004 + ', ' + col0002 as [client_name],col0015,col0016,col0018,col0024,col0037 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"];
        DataSet parent = getMssqlData(sql);
        Session["clientemail"] = parent.Tables[0].Rows[0]["col0018"].ToString();
        Session["clientName"] = parent.Tables[0].Rows[0]["client_name"].ToString();    
        //Response.Write("Clients Email:" +Session["clientemail"].ToString());    

        sql = "SELECT col0015,col0016 FROM " + Session["mainParentTable"] + " WHERE [id] = 2 AND [claimid] = " + Session["id"];
        DataSet parent1 = getMssqlData(sql);

        sql = "SELECT TOP 1 note FROM notes WHERE [claimid] = " + Session["id"] + " ORDER BY [id] ASC";
        DataSet note = getMssqlData(sql); 
        %>
        <table border="0" cellpadding="2" cellspacing="2" align="center"  style="vertical-align:top;" width="90%">
        <tr>
            <td width="50%"><font class="red">Client Name:</font> <font class="black"><%= parent.Tables[0].Rows[0]["client_name"] %></font></td>
            <%try
            { %>
            <% if (data.Tables[0].Rows[0]["col0020"].ToString() == "0")
            { %>
                <td width="50%"><font class="red">Student Grad Year:</font> <font class="black"></font></td>
            <% }
            else
            { %>
                <td width="50%"><font class="red">Student Grad Year:</font> <font class="black"><%= data.Tables[0].Rows[0]["col0020"]%></font></td>
            <% } %>
            <%}
            catch (Exception ex) 
            { 
                message.Text = "" + ex.Message; 
            } %>
        </tr><tr>
            <td><font class="red">Student Name:</font> <font class="black"><%= data.Tables[0].Rows[0]["student_name"] %></font></td>
            <td><font class="red">Student's High School:</font> <font class="black"><%= data.Tables[0].Rows[0]["col0018"] %></font></td>
        </tr><tr>
            <td><font class="red">Parent's Email Address:</font> <font class="black"><%= parent.Tables[0].Rows[0]["col0018"] %></font></td>
            <td><font class="red">Student High School City:</font> <font class="black"><%= data.Tables[0].Rows[0]["student_hs_city"] %></font></td>
        </tr><tr>
            <td><font class="red">Student Address:</font> <font class="black"><%= data.Tables[0].Rows[0]["col0007"] %></font></td>
            <td><font class="red">Student High School State:</font> <font class="black"><%= data.Tables[0].Rows[0]["student_hs_state"] %></font></td>
        </tr><tr>
            <td><font class="red">Student City:</font> <font class="black"><%= data.Tables[0].Rows[0]["col0009"] %></font></td>
            <%try
            { %>
            <% if (parent1.Tables[0].Rows[0]["col0015"].ToString() == "0")
            { %>
                <td><font class="red">Mother's Work Phone:</font> <font class="black"></font></td>
            <% }
            else
            { %>
                <td><font class="red">Mother's Work Phone:</font><span style="font-size: 9pt; font-family: Arial">
                    </span>
                    <font class="black"><%= parent1.Tables[0].Rows[0]["col0015"]%><span
                        style="color: #660000">Ext.<%= parent1.Tables[0].Rows[0]["col0016"]%></span></font></td>
            <% } %>
            <%}
            catch (Exception ex)
            { %>
            <%
                message.Text = "" + ex.Message;
            } %>
        </tr><tr style="font-size: 12pt; color: #660000; font-family: Times New Roman">
            <td><font class="red">Student State:</font><span
                    style="font-size: 9pt"><span style="color: #660000"><span style="font-family: Arial">
                        <font class="black"><%= data.Tables[0].Rows[0]["col0010"] %></font></span></span></span></td>
            <%try
            { %>
            <% if (parent.Tables[0].Rows[0]["col0015"].ToString() == "0")
            { %>
                <td style="font-size: 12pt; color: #660000; font-family: Times New Roman"><font class="red">Father's Work Phone:</font><span
                        style="font-size: 9pt"><span style="font-family: Arial"> <font class="black"></font></span></span></td>
            <% }
            else
            { %>
                <td style="font-size: 9pt; font-family: Arial"><font class="red">Father's Work Phone:</font> <font class="black"><%= parent.Tables[0].Rows[0]["col0015"]%><span
                        style="color: #660000">Ext.<%= parent.Tables[0].Rows[0]["col0016"]%></span></font></td>
            <% } %>
            <%}
            catch (Exception ex)
            { %>
            <%message.Text = "" + ex.Message;
            } %>
        </tr><tr style="font-size: 12pt; color: #660000; font-family: Times New Roman">
            <td><font class="red">Student Zip:</font><span style="font-size: 9pt"><span
                    style="color: #660000"><span style="font-family: Arial"> <font class="black"><%= data.Tables[0].Rows[0]["col0011"] %></font></span></span></span></td>
            <% 
                try
                {
                    DateTime dt = Convert.ToDateTime(data.Tables[0].Rows[0]["seminar_date"].ToString());
            %>
                    <td style="font-size: 12pt; color: #660000; font-family: Times New Roman"><font class="red">Seminar Date:</font><span style="font-size: 9pt"><span
                            style="color: #660000"><span style="font-family: Arial"> <font class="black"><%= dt.ToShortDateString() %></font></span></span></span></td>
            <%
                }
                catch
                {
            %>
                    <td style="font-size: 12pt; color: #660000; font-family: Times New Roman"><font class="red">Seminar Date:</font><span style="font-size: 9pt"><span
                            style="color: #660000"><span style="font-family: Arial"> <font class="black"></font></span></span></span></td>
            <%
                }
            %>
        </tr><tr style="font-size: 9pt; color: #660000; font-family: Arial">
            <td><font class="red">
                    Home Phone:</font><span style="color: #660000"> <font class="black"><%= data.Tables[0].Rows[0]["col0013"] %></font></span></td>
            <td style="font-size: 9pt; color: #660000; font-family: Arial"><font class="red">
                    Own Home:</font><span style="color: #660000"> <font class="black"><%= parent.Tables[0].Rows[0]["col0024"] %></font></span></td>
        </tr><tr style="font-size: 9pt; color: #660000; font-family: Arial">
            <td><font class="red">
                    Self Employed:</font><span style="color: #660000"> <font class="black"><%= parent.Tables[0].Rows[0]["col0024"] %></font></span></td>
            <td style="font-size: 9pt; color: #660000; font-family: Arial"><font class="red">
                    Estimated Income:</font><span style="color: #660000"> <font class="black"><%= data.Tables[0].Rows[0]["est_income"] %></font></span></td>
        </tr><tr style="font-size: 9pt; color: #660000; font-family: Arial">
            <td><font class="red">
                    Tax Bracket:</font> <font class="black"><%= data.Tables[0].Rows[0]["tax_bracket"] %></font></td>
            <td style="font-size: 9pt; font-family: Arial"><font class="red">Assigned To:</font> <font class="black"><%= Repname %></font></td>
        </tr>
        <% if(note.Tables[0].Rows[0]["note"].ToString() != "") { %>
        <tr>
            <td colspan="2" align="center"><font class="black">Sibling Information</font></td>
        </tr>
        <tr style="color: #ffffff">
            <td colspan="2" align="center"><font class="black"><%= note.Tables[0].Rows[0]["note"] %></font></td>
        </tr>
        <% } %>
        </table>
        
        <br>
        <table border="0" cellpadding="4" cellspacing="2" align="center"  style="vertical-align:top; color: #ffffff;" width="100%">
        <tr height="20">
            <td align="center">
                <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                    <tr>
                        <td align="center" valign="bottom" style="padding-right: 15px; padding-left: 15px">
                            <font class="black">Case ID: <asp:Label ID="caseidlabel" runat="server"></asp:Label></font></td>
                        <td align="center" valign="bottom" style="padding-right: 15px; padding-left: 15px">
                            <font class="black">Assign To: </font>
                            <asp:DropDownList ID="repDDL" runat="server">
                            </asp:DropDownList>
                            <asp:Button ID="reassign_button" runat="server" OnClick="reassign_button_Click" Text="Reassign" /></td>
                        <td align="center" valign="bottom" style="padding-right: 15px; padding-left: 15px">
                            <input type="button" id="sendEmailButton" value="Send Email" onclick="<%= "window.open('../sendEmail.aspx?ID=" + Session["id"].ToString() + "','','scrollbar=no,resizable=yes,width=450,height=500,left=300,top=90');" %>" />
                            </td>
                        <td align="center" valign="bottom" style="padding-right: 15px; padding-left: 15px">
                            <input type="button" value="Dataform Link" id="dfbutton" onclick="loadDFlink()" /></td>
                    </tr>
                    <tr>
                        <td id="dflinktd" align="center" colspan="4">
                        
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
                <td align="center"><font class="black">Website Logins</font></td>
            </tr>
            <tr class="grey">
                <td align="center">
                    <asp:GridView DataKeyNames="userid" ID="LoginTable" runat="server" 
                        AutoGenerateColumns="true" Width="100%" Font-Names="arial" Font-Size="9pt"
                        OnRowCreated="LoginTable_RowCreated" OnRowCommand="LoginTable_RowCommand" >
                        <Columns>
                            <asp:ButtonField ButtonType="Button" CommandName="Edit" Text="Edit" />
                            <asp:ButtonField ButtonType="Button" CommandName="Item" Text="Active" />
                        </Columns>                        
                        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                        <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                        <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                    </asp:GridView>
                    Add Login: 
                        Name: <asp:TextBox ID="newUser_Name" runat="server"></asp:TextBox> 
                        Email: <asp:TextBox ID="newUser_Email" runat="server"></asp:TextBox> 
                        &nbsp;<asp:Button ID="AddNewUser" runat="server" onclick="AddNewUser_Click" 
                        Text="Add" />
                </td>
            </tr>
        <%
        if(data.Tables[0].Rows[0]["status"].ToString() != "New Lead") {

        DataSet tmp = getMssqlData("SELECT appointments.*,users.name,locations.name as lname FROM appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='Y'");
        if(tmp.Tables.Count > 0) {
            if(tmp.Tables[0].Rows.Count > 0) {
                if(Session["cancel"].ToString() != "") {
                    Session["cancel"] = "";
                    Session["state"] = "cancel";
                }else{
                    Session["state"] = "list";
                }
            }else{
                Session["state"] = "new";
            }
        }else{
            Session["state"] = "new";
        }

        DataTable myFU = SQLManager.GetDataPrimitive("SELECT * FROM CRM_Follow_Up_Appointments WHERE claimid='" + Session["id"].ToString() + "'");
        string fuState = "First Meeting";
        if (myFU.Rows.Count > 0)
        {
            switch(myFU.Rows.Count) {
                case 1:
                    fuState = "1st Followup";
                    break;
                case 2:
                    fuState = "2nd Followup";
                    break;
                case 3:
                    fuState = "3rd Followup";
                    break;
                default:
                    fuState = myFU.Rows.Count.ToString() + "th Followup";
                    break; 
            }
        }    
            
        if(Session["state"].ToString() == "list") { %>
            
            <tr>
                <td align="center"><font class="black">Upcoming Appointment</font></td>
            </tr>
            <tr class="grey" style="font-size: 12pt; color: #ffffff; font-family: Times New Roman">
                <td align="center">

                <table cellspacing="0" cellpadding="3" align="center" bordercolor="Black" border="1" bgcolor="White" width="100%">
                <tr bgcolor="#4A3C8C">
                    <td><font class="white">Assigned To</font></td>
                    <td><font class="white">Appointment Time</font></td>
                    <td><font class="white">Scheduled By</font></td>
                    <td><font class="white">Location</font></td>
                    <td><font class="white">Set Date</font></td>
                    <td><font class="white">Forms?</font></td>
                    <td><font class="white">Type</font></td>
                    <td>&nbsp;</td>
                </tr>
                <tr bgcolor="#E7E7FF">
                    <td valign="top"><font class="blacksm"><%= Repname %></font></td>
                    <td valign="top"><font class="blacksm"><%= tmp.Tables[0].Rows[0]["appointment"] %></font></td>
                    <td valign="top"><font class="blacksm"><%= tmp.Tables[0].Rows[0]["name"] %></font></td>
                    <td valign="top"><font class="blacksm"><%= tmp.Tables[0].Rows[0]["lname"] %><br />
                        <asp:Label ID="G2Mlabel" runat="server" Text="g2mlabel" ></asp:Label>
                        <asp:LinkButton ID="addG2MIDButtom" runat="server" OnClick="addG2MIDButtom_Click" Text="(Add ID)" ></asp:LinkButton>
                        <asp:TextBox ID="G2Mbox" runat="server" Width="75px" ></asp:TextBox>
                        <asp:Button ID="G2Mbutton" runat="server" Text="Add" OnClick="G2Mbutton_Click" /></font></td>
                    <td valign="top"><font class="blacksm"><%= tmp.Tables[0].Rows[0]["appt_set_date"] %></font></td>
                    <td valign="top"><font class="blacksm"><%= DFView(Session["id"].ToString()) %></font></td>
                    <td valign="top"><font class="blacksm"><%= fuState %></font></td>
                    <td valign="top" align="center">
                        <input type="hidden" name="id" value="<%= tmp.Tables[0].Rows[0]["id"] %>"><strong> </strong>
                        <asp:button id="Cancel" text="Close" runat="server" onClick="cancelAppointment"/>
                    </td>
                </tr>
                </table>
        <% }else if(Session["state"].ToString() == "new") { %>
            <tr>
                <td align="center"><font class="black">Schedule Appointment</font></td>
            </tr>
            <tr>
                <td align="center">

                <table border="0" cellpadding="4" cellspacing="0" align="center" width="70%">   
                <tr>
                    <td width="25%"><font class="black">Date</font></td>
                    <td><input onfocusout="fixDate()" id="date" type="text" name="date" size="10" maxlength="10" value="<%= Request["date"] %>"> <font class="black">MM / DD / YYYY</font></td>
                </tr>
                <tr>
                    <td><font class="black">Time</font></td>
                    <td>
                        <select name="hour">
                        <% if (Request["hour"] == "1" || Request["hour"] == "01")
         { %>
                            <option value="01" selected>01</option>
                        <% }else{ %>
                            <option value="01">01</option>
                        <% } %>

                        <% if (Request["hour"] == "2" || Request["hour"] == "02")
         { %>
                            <option value="02" selected>02</option>
                        <% }else{ %>
                            <option value="02">02</option>
                        <% } %>

                        <% if (Request["hour"] == "3" || Request["hour"] == "03")
         { %>
                            <option value="03" selected>03</option>
                        <% }else{ %>
                            <option value="03">03</option>
                        <% } %>

                        <% if (Request["hour"] == "4" || Request["hour"] == "04")
         { %>
                            <option value="04" selected>04</option>
                        <% }else{ %>
                            <option value="04">04</option>
                        <% } %>

                        <% if (Request["hour"] == "5" || Request["hour"] == "05")
         { %>
                            <option value="05" selected>05</option>
                        <% }else{ %>
                            <option value="05">05</option>
                        <% } %>

                        <% if (Request["hour"] == "6" || Request["hour"] == "06")
         { %>
                            <option value="06" selected>06</option>
                        <% }else{ %>
                            <option value="06">06</option>
                        <% } %>

                        <% if (Request["hour"] == "7" || Request["hour"] == "07")
         { %>
                            <option value="07" selected>07</option>
                        <% }else{ %>
                            <option value="07">07</option>
                        <% } %>

                        <% if (Request["hour"] == "8" || Request["hour"] == "08")
         { %>
                            <option value="08" selected>08</option>
                        <% }else{ %>
                            <option value="08">08</option>
                        <% } %>

                        <% if (Request["hour"] == "9" || Request["hour"] == "09")
         { %>
                            <option value="09" selected>09</option>
                        <% }else{ %>
                            <option value="09">09</option>
                        <% } %>

                        <% if(Request["hour"] == "10") { %>
                            <option value="10" selected>10</option>
                        <% }else{ %>
                            <option value="10">10</option>
                        <% } %>

                        <% if(Request["hour"] == "11") { %>
                            <option value="11" selected>11</option>
                        <% }else{ %>
                            <option value="11">11</option>
                        <% } %>

                        <% if(Request["hour"] == "12") { %>
                            <option value="12" selected>12</option>
                        <% }else{ %>
                            <option value="12">12</option>
                        <% } %>
                        </select>
                        <select name="min">
                        <% if(Request["min"] == "00") { %>
                            <option value="00" selected>00</option>
                        <% }else{ %>
                            <option value="00">00</option>
                        <% } %>

                        <% if(Request["min"] == "15") { %>
                            <option value="15" selected>15</option>
                        <% }else{ %>
                            <option value="15">15</option>
                        <% } %>

                        <% if(Request["min"] == "30") { %>
                            <option value="30" selected>30</option>
                        <% }else{ %>
                            <option value="30">30</option>
                        <% } %>

                        <% if(Request["min"] == "45") { %>
                            <option value="45" selected>45</option>
                        <% }else{ %>
                            <option value="45">45</option>
                        <% } %>
                        </select>
                        <select name="ap">
                        <% if(Request["ap"] == "AM") { %>
                            <option value="AM" selected>AM</option>
                            <option value="PM">PM</option>
                        <% }else{ %>
                            <option value="AM">AM</option>
                            <option value="PM" selected>PM</option>
                        <% } %>
                        </select>
                        <select name="location">
                        <% 
                            try
                            {
                                tmp = getMssqlData("SELECT * FROM locations");
                                for (int i = 0; i < tmp.Tables[0].Rows.Count; i++)
                                { %>
                            <% if (Request["location"] == tmp.Tables[0].Rows[i]["name"].ToString())
                            { %>
                                <option selected value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"]%></option>
                            <% }
                            else
                            { %>
                                <option value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"]%></option>
                            <% } %>
                        <% }
                        }
                        catch (Exception ex) 
                            { 
                                message.Text = "" + ex.Message; 
                            } %>
                        </select>
                    </td>
                </tr>
                <%
                    if (Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "admin")
                    {
                %>
                <tr>
                    <td align="center" colspan="2">
                        <asp:CheckBox ID="followUp" Font-Bold="true" runat="server" Text="This is a Follow Up Appointment" Checked="false" />
                    </td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td align="center" colspan="2">
                        <asp:button id="schedule" text="Schedule" runat="server" OnClientClick="return validateSchedule()" onClick="scheduleAppointment"/>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2" style="color:Red;">
                        <asp:Label ID="lblMessage" runat="Server" Font-Names="arial" Font-Size="9pt"></asp:Label>
                    </td>
                </tr>
                </table>
        <% }else if(Session["state"].ToString() == "cancel") { %>
            <tr>
                <td align="center"><font class="black">Close Appointment</font></td>
            </tr>
            <tr class="grey">
                <td align="center">

                <table border="1" cellpadding="4" cellspacing="0" align="center" width="95%">
                <tr bgcolor="#4A3C8C">
                    <td><font class="white">Time</font></td>
                    <td><font class="white">Scheduled By</font></td>
                    <td><font class="white">Location</font></td>
                    <td><font class="white">Status</font></td>
                    <td><font class="white">Client</font></td>
                </tr>
                <tr bgcolor="#E7E7FF">
                    <td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["appointment"] %></font></td>
                    <td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["name"] %></font></td>
                    <td>
                        <font class="blacksm"><%= tmp.Tables[0].Rows[0]["lname"] %></font>
                        <input type="hidden" name="id" value="<%= tmp.Tables[0].Rows[0]["id"] %>">
                    </td>
                    <td><select name=apptstatus><%= selectBox(Request["apptstatus"],"apptstatus") %></select></td>
                    <td><select name=apptclient><%= selectBox(Request["apptclient"],"apptclient") %></select></td>

                </tr>
                <tr bgcolor="#FFFFFF">
                    <td colspan="5" align="center">
                        <font class="black">Appointment Notes:</font>
                        <input type="text" name="reason" size="35" maxlength="255" style="width: 450px"><br />
                        <asp:CheckBox ID="rebookNotice" runat="server" Font-Bold="True" Text="Check this box to automatically send a rebooking notification to the appointment setting staff." Font-Names="Arial,Helvecta" Font-Size="12px" /><br /><strong><span style="font-size: 9pt; font-family: Arial"><br />
                        <asp:CheckBox ID="rebookNotice2" runat="server" Font-Bold="True" Text="Check this box to automatically send a rebooking notification to the office staff." Font-Names="Arial,Helvecta" Font-Size="12px" /><br /><strong><span style="font-size: 9pt; font-family: Arial">
                            <br />
                            Setup Autoresponders: </span></strong>
                        <br /><span style="font-size: 8pt; font-family: Arial; font-style: italic;">Hint: CTRL + Click to setup more than one</span>
                        <br />
                        <asp:ListBox ID="arListBox" runat="server" Rows="10" Width="600px" SelectionMode="Multiple">
                            <asp:ListItem Value="noautoresponders" Text="Do not set up autoresponders" />
                            <asp:ListItem Value="none" Text="\A0" />
                            <asp:ListItem Value="none" Text="Appointment Did Not Occur:" />
                                <asp:ListItem Value="cancelreset" Text="\A0\A0\A0Prospect cancelled appointment and reset." />
                                <asp:ListItem Value="canceltbr" Text="\A0\A0\A0Prospect cancelled appointment and will reset." />
                                <asp:ListItem Value="cancelnoreset" Text="\A0\A0\A0Prospect cancelled appointment and will not reset." />
                                <asp:ListItem Value="noshow" Text="\A0\A0\A0Prospect did not show up for their appointment" />
                                <asp:ListItem Value="noforms" Text="\A0\A0\A0Appointment Cancelled - Prospect did not submit Data Forms" />
                            <asp:ListItem Value="none" Text="\A0" />
                            <asp:ListItem Value="none" Text="Appointment Outcomes:" />
                                <asp:ListItem Value="nq" Text="\A0\A0\A0Prospect is Not Qualified" />
                                <asp:ListItem Value="ni" Text="\A0\A0\A0Prospect is Not Interested" />
                                <asp:ListItem Value="pending" Text="\A0\A0\A0Prospect is Interested. Sale pending" />
                                <asp:ListItem Value="client" Text="\A0\A0\A0Prospect has become a Client" />
                        </asp:ListBox></td>
                </tr>
                <tr bgcolor="#E7E7FF">
                    <td colspan="5" align="center">
                        <asp:button id="backdb" text="Back" runat="server" onClick="backAppointment"/>
                        <asp:button id="canceldb" text="Confirm" runat="server" onClick="updateDB"/>
                    </td>
                </tr>
                </table>
        <% } %>

            </td>
        </tr>
        <tr height="20">
            <td></td>
        </tr>
            
        <tr>
            <td align="center">
                <font class="black">Appointment History</font>
                <%try
                { %>
                    <% if (Session["view"].ToString() == "three")
                    { %>
                        (<asp:LinkButton id="entireButton" class="red" Text="Entire History" Font-Names="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>
                        )
                    <% }
                    else
                    { %>
                        (<asp:LinkButton id="recentButton" class="red" Text="Recent History" Font-Names ="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>)
                    <% }
                    }
                    catch (Exception ex) 
                    { 
                        message.Text = "" + ex.Message; 
                    }%>
            </td>
        </tr>
        <tr class="grey">
            <td align="center">

            <table border="0" cellpadding="4" cellspacing="0" align="center"  style="vertical-align:top;" width="100%">
            <tr>
                <td align="center">
            
            <%--    
            Date:29/11/2007
            In this gridview edit link is there by clicking on the edit link popup window opens and all appointment data is shown of that
            particular id and that poup window page name is(case_info_edit.aspx with the id).
            
            Date: 10/3/2008
            Edit link disabled. Editing appointments in this manner creates inconsistencies in the system - 
            it is much better handled if an appointment is closed and re-set with the appropriate information
            -RG
            --%>
            <%try
            { %>
                <%if (GridView1.Rows.Count > 0)
                { %>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"  Font-Names="arial" Font-Size="9pt" Width="753px">
                        <Columns>
                        <%--<asp:TemplateField>--%>
                        <%--<ItemTemplate>--%>
                        <%--<asp:LinkButton ID="LinkButton1" runat="server" Text = "Edit" OnClientClick ='<%#String.Format("{0}\"{1}{2}\")", "javascript:window.open(","case_info_edit.aspx?ID=",Eval("ID"),"","resizable=0,width=350,height=250")%>'></asp:LinkButton>--%>                         
                        <%--<a href="javascript:void(window.open('case_info_edit.aspx?ID=<%# Eval("ID")%>','','scrollbar=no,resizable=no,width=500,height=400,left=300,top=90'))">Edit</a>--%>
                        <%--</ItemTemplate>--%>
                        <%--</asp:TemplateField>--%>
                        
                            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                SortExpression="ID" Visible="false" />
                            <asp:BoundField DataField="Appointment Time" HeaderText="Appointment Time" SortExpression="Appointment Time" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                            <asp:BoundField DataField="Client" HeaderText="Client" SortExpression="Client" />
                            <asp:BoundField DataField="Appointment Notes" HeaderText="Appointment Notes" SortExpression="Appointment Notes" />
                            <asp:BoundField DataField="Set Date" HeaderText="Set Date" SortExpression="Set Date" />
                            <asp:BoundField DataField="Autoresponders" HeaderText="Autoresponders" SortExpression="Autoresponders" />
                            
                        </Columns>
                        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                        <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                        <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                    </asp:GridView>
                    <%}
                      else
                      { %>
                    
                        <font class="black">No appointment history.</font>
                    
                    <%  }%>
                    <%}
                    catch (Exception ex)
                    { 
                        message.Text = "" + ex.Message; 
                    } %>
                    </td>
            </tr>
            </table>
            </td>
            </tr>
            
                    <%--    <%      }else{ %>
                    <tr class="grey">
                        <td colspan="2" align="center"><font class="black">No appointment history.</font></td>
                    </tr>
        <%      }
            }else{  %>
                <tr class="grey">
                    <td colspan="2" align="center"><font class="black">No appointment history.</font></td>
                </tr>
        <%  } --%>


        <%}
        %>      

                
        
        <tr height="20">
            <td colspan="2"></td>
        </tr>
            <tr height="20">
                <td colspan="2">
                    <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                        <tr>
                            <td width="55%" valign="top">
                                <asp:DataList ID="DataList1" runat="server" BackColor="White" BorderColor="Black"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Horizontal" Width="100%" Font-Names="Arial">
                                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                                    <AlternatingItemStyle BackColor="#F7F7F7" />
                                    <ItemStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" VerticalAlign="Top" Width="1%" Font-Names="Arial" />
                                    <SelectedItemStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <HeaderTemplate>
                                        Notes (Last 5)
                                    </HeaderTemplate>
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" Font-Names="Arial" />
                                    <ItemTemplate>
                                        <table border="0" cellpadding="3" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td colspan="2" style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: white">
                                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Note") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Label ID="Label5" runat="server" Text='<%# Eval("Date") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                                <td align="right" valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Label ID="Label6" runat="server" Text='<%# Eval("Name") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <a href="./case_notes.aspx">View All Notes</a>
                                    </FooterTemplate>
                                </asp:DataList></td>
                            <td width="45%" valign="top">
                                <asp:DataList ID="DataList2" runat="server" BackColor="White" BorderColor="Black"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Horizontal"
                                    Width="100%" OnEditCommand="DataList2_EditCommand" OnDeleteCommand="DataList2_DeleteCommand">
                                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" Font-Names="Arial" />
                                    <AlternatingItemStyle BackColor="#F7F7F7" />
                                    <ItemStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" Font-Names="arial" />
                                    <SelectedItemStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <HeaderTemplate>
                                        Tasks
                                    </HeaderTemplate>
                                    <FooterTemplate>
                                        <asp:Button ID="Button3" OnClick="Button3_Click" runat="server" Text="Add Task" Font-Names="Arial" Font-Size="7pt" /> | <a href="./tasklist.aspx">My Task List</a>
                                    </FooterTemplate>
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" Font-Names="arial" />
                                    <ItemTemplate>
                                        <table border="0" cellpadding="3" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td colspan="2" style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: white"><asp:Label ID="Label4" runat="server" Text='<%# Eval("Task") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Label ID="Label5" runat="server" Text='<%# "Due: " + Eval("DueDate") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                                <td align="right" valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button1" runat="server" Text="Done" CommandName="edit" CommandArgument='<%# Eval("ID") %>' Font-Names="Arial" Font-Size="7pt" /> <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button4" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this task?')" CommandName="delete" CommandArgument='<%# Eval("ID") %>' Font-Names="Arial" Font-Size="7pt" /> <asp:Label Visible='<%# Eval("CompleteBy") != DBNull.Value ? true : false %>' ID="Label3" runat="server" Text='<%# "Completed: " + Eval("CompleteDate") + " by " + Eval("CompleteByName") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:DataList>
                                <br /><br />
                                <asp:DataList ID="DataList3" runat="server" BackColor="White" BorderColor="Black"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Horizontal"
                                    Width="100%" OnEditCommand="DataList3_EditCommand" OnDeleteCommand="DataList3_DeleteCommand">
                                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" Font-Names="Arial" />
                                    <AlternatingItemStyle BackColor="#F7F7F7" />
                                    <ItemStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" Font-Names="arial" />
                                    <SelectedItemStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <HeaderTemplate>
                                        Product Tasks
                                    </HeaderTemplate>
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" Font-Names="arial" />
                                    <ItemTemplate>
                                        <table border="0" cellpadding="3" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td colspan="2" style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: white"><asp:Literal ID="Label4" runat="server" Text='<%# "<p style=\"font-size:9pt;margin: 0; padding: 0; border-bottom: solid 1px black; font-weight:bold;\">Product: " + Eval("ProductName") + "</p>" + Eval("Task") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Label ID="Label5" runat="server" Text='<%# "Due: " + Eval("DueDate") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                                <td align="right" valign="top" style="padding-bottom: 6px; padding-top: 0px">
                                                    <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button1" runat="server" Text="Done" CommandName="edit" CommandArgument='<%# Eval("ID") %>' Font-Names="Arial" Font-Size="7pt" /> <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button4" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this task?')" CommandName="delete" CommandArgument='<%# Eval("ID") %>' Font-Names="Arial" Font-Size="7pt" /> <asp:Label Visible='<%# Eval("CompleteBy") != DBNull.Value ? true : false %>' ID="Label3" runat="server" Text='<%# "Completed: " + Eval("CompleteDate") + " by " + Eval("CompleteByName") %>' Font-Names="Arial" Font-Size="7pt"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:DataList>
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>
<center><a href="http://www.college-retirement.com/adminCalendar2.aspx">
        Go to Admin Calendar</a></center>
        
        </ContentTemplate>
    </asp:UpdatePanel>
</form>
<!--#include file="./footer.aspx"-->
</body>
</html>

    
