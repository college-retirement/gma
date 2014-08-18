<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	
<script language="javascript" type="text/javascript">

var boxes = new Array("fafsabox","cssbox","otbox","awbox","cpbox","satactbox","apbox","aabox","ccsbox","ecbox","wkbox");
var p1 = new Array("$249.00","otbox");
var p2 = new Array("$459.00","otbox","satactbox");
var p3 = new Array("$499.00","otbox","fafsabox");
var p4 = new Array("$699.00","otbox","fafsabox","cssbox");
var p5 = new Array("$995.00","awbox","fafsabox","cssbox","ccsbox","ecbox","wkbox");
var p6 = new Array("$1395.00","awbox","fafsabox","cssbox","ccsbox","ecbox","wkbox","satactbox","cpbox");
var p7 = new Array("$2495.00","awbox","fafsabox","cssbox","ccsbox","ecbox","wkbox","satactbox","cpbox","aabox","apbox");

function clearboxes() {
    
    for (var i = 0; i < boxes.length; i++)
    {  
        var x = document.getElementById(boxes[i]);
        x.checked = "";
    }
    
    var myPrice = document.getElementById('<%= price.ClientID %>');
    myPrice.value="$";
}

function myclick(pkg) {
    clearboxes();
    var x = null;
    if(pkg == 1)
        x = p1;
    else if(pkg == 2)
        x = p2;
    else if(pkg == 3)
        x = p3;
    else if(pkg == 3)
        x = p3;
    else if(pkg == 4)
        x = p4;
    else if(pkg == 5)
        x = p5;
    else if(pkg == 6)
        x = p6;
    else if(pkg == 7)
        x = p7;
        
    for (var i = 1; i < x.length; i++)
    {
        var z = document.getElementById(x[i]);
        z.checked = "checked";
    }
    
    var myPrice = document.getElementById('<%= price.ClientID %>');
    myPrice.value = x[0];
}

function setupPage()
{
    var x = document.getElementById('fafsa');
    var y = x;
    if (x.value == 'y')
        {
            y = document.getElementById('fafsabox');
            y.checked = 'checked';
        }
    x = document.getElementById('profile');
    if (x.value == 'y')
        {
            y = document.getElementById('cssbox');
            y.checked= 'checked';
        }
    x = document.getElementById('ontrack');
    if (x.value == 'y')
        {
            y = document.getElementById('otbox');
            y.checked= 'checked';
        }
    x = document.getElementById('applywise');
    if (x.value == 'y')
        {
            y = document.getElementById('awbox');
            y.checked= 'checked';
        }
    x = document.getElementById('planning');
    if (x.value == 'y')
        {
            y = document.getElementById('cpbox');
            y.checked= 'checked';
        }
    x = document.getElementById('satact');
    if (x.value == 'y')
        {
            y = document.getElementById('satactbox');
            y.checked= 'checked';
        }
    x = document.getElementById('admissionprob');
    if (x.value == 'y')
        {
            y = document.getElementById('apbox');
            y.checked= 'checked';
        }
    x = document.getElementById('appeals');
    if (x.value == 'y')
        {
            y = document.getElementById('aabox');
            y.checked= 'checked';
        }
    x = document.getElementById('selection');
    if (x.value == 'y')
        {
            y = document.getElementById('ccsbox');
            y.checked= 'checked';
        }
    x = document.getElementById('enrichment');
    if (x.value == 'y')
        {
            y = document.getElementById('ecbox');
            y.checked= 'checked';
        }
    x = document.getElementById('welcomekit');
    if (x.value == 'y')
        {
            y = document.getElementById('wkbox');
            y.checked= 'checked';
        }
    x = document.getElementById('myprice');
    document.getElementById('price').value = x.value;
}

</script>
</head>
	<script language="C#" runat="server">
		
	public void Page_Load() {
		//Check to see if the session is still alive otherwise redirect.
		if(Session["userid"] == null || Session["userid"].ToString() == "") {
				Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}

        if (Page.IsPostBack) return;

        initPage();
	}

        public void initPage()
        {
            int myID = Convert.ToInt32(Session["id"].ToString());
            CRSCRM.Sale mySale = CRSCRM.Sale.getSaleByCaseID(myID);
            string myOutput = string.Empty;
            
            myOutput = "<input type=\"hidden\" id=\"fafsa\" value=\"";
            if (mySale.fafsa) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"profile\" value=\"";
            if (mySale.profile) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"ontrack\" value=\"";
            if (mySale.ontrack) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"applywise\" value=\"";
            if (mySale.applywise) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"planning\" value=\"";
            if (mySale.planning) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"satact\" value=\"";
            if (mySale.satact) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"admissionprob\" value=\"";
            if (mySale.admissionprob) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"appeals\" value=\"";
            if (mySale.appeals) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"selection\" value=\"";
            if (mySale.selection) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"enrichment\" value=\"";
            if (mySale.enrichment) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"welcomekit\" value=\"";
            if (mySale.welcomekit) myOutput += "y";
            else myOutput += "n";
            myOutput += "\" />";

            myOutput += "<input type=\"hidden\" id=\"myprice\" value=\"" + mySale.price + "\" />";

            outputLabel.Text = myOutput;
        }

        protected void savebutton_Click(object sender, EventArgs e)
        {
            int myID = Convert.ToInt32(Session["id"].ToString());
            CRSCRM.Sale mySale = CRSCRM.Sale.getSaleByCaseID(myID);


            if (Request["fafsabox"] != null && Request["fafsabox"].ToString() != string.Empty)
                mySale.fafsa = true;
            else mySale.fafsa = false;
            if (Request["cssbox"] != null && Request["cssbox"].ToString() != string.Empty)
                mySale.profile = true;
            else mySale.profile = false;
            if (Request["otbox"] != null && Request["otbox"].ToString() != string.Empty)
                mySale.ontrack = true;
            else mySale.ontrack = false;
            if (Request["awbox"] != null && Request["awbox"].ToString() != string.Empty)
                mySale.applywise = true;
            else mySale.applywise = false;
            if (Request["cpbox"] != null && Request["cpbox"].ToString() != string.Empty)
                mySale.planning = true;
            else mySale.planning = false;
            if (Request["satactbox"] != null && Request["satactbox"].ToString() != string.Empty)
                mySale.satact = true;
            else mySale.satact = false;
            if (Request["apbox"] != null && Request["apbox"].ToString() != string.Empty)
                mySale.admissionprob = true;
            else mySale.admissionprob = false;
            if (Request["aabox"] != null && Request["aabox"].ToString() != string.Empty)
                mySale.appeals = true;
            else mySale.appeals = false;
            if (Request["ccsbox"] != null && Request["ccsbox"].ToString() != string.Empty)
                mySale.selection = true;
            else mySale.selection = false;
            if (Request["ecbox"] != null && Request["ecbox"].ToString() != string.Empty)
                mySale.enrichment = true;
            else mySale.enrichment = false;
            if (Request["wkbox"] != null && Request["wkbox"].ToString() != string.Empty)
                mySale.welcomekit = true;
            else mySale.welcomekit = false;

            mySale.price = price.Text;
            mySale.Save();
            initPage();
            outputLabel.Text += "Sale Recorded!";
        }
</script>
<body style="text-align: center" onload="setupPage()">
<!--#include file="./images/case_review_menu/nav3.aspx"-->
<form runat="server">
    &nbsp;<table border="0" cellpadding="5" cellspacing="0" style="width: 792px; font-family: calibri, verdana, arial;">
        <tr>
            <td colspan="5" style="text-align: center">
    <asp:Label ID="outputLabel" runat="server"></asp:Label></td>
        </tr>
        <tr>
            <td colspan="5" style="text-align: center; font-weight: bold; font-size: 15pt; padding-bottom: 15px; border-bottom: black 1px solid;">
                Sale Summary</td>
        </tr>
        <tr>
            <td colspan="5" style="font-size: 10pt; text-align: center">
                Pick services cafeteria style from the list below, and enter the price.<br />
                Or, click
                a package name from the box on the right to select the predefined package services.<br />
                Whe you're done, click 'Save Changes'</td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" nowrap="noWrap">
                Form Filing Options:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed">
                <input id="fafsabox" name="fafsabox" type="checkbox" />
                <label for="fafsabox" id="fafsalabel">FAFSA</label></td>
            <td style="border-bottom: #cccccc 1px dashed">
                <input id="cssbox" name="cssbox" type="checkbox" />
                <label for="cssbox" id="csslabel">CSS/PROFILE</label></td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid;">
                Package Selection</td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff" nowrap="noWrap">
                Admissions Services:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
            <input id="otbox" name="otbox" type="checkbox" />
                <label for="otbox" id="otlabel">
                    OnTrack! To College</label></td>
            <td style="border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
            <input id="awbox" name="awbox" type="checkbox" />
                <label for="awbox" id="awlabel">
                    ApplyWise</label></td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg1" type="button" value="Honors Package" style="width: 150px" onclick="myclick(1);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" nowrap="noWrap">
                Planning Options:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed">
                <input id="cpbox" name="cpbox" type="checkbox" />
                <label for="cpbox" id="cplabel">
                    College Planning</label></td>
            <td style="border-bottom: #cccccc 1px dashed">
                &nbsp;</td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg2" type="button" value="Honors for Juniors" style="width: 150px" onclick="myclick(2);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff" nowrap="noWrap">
                SAT/ACT Consultation:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
                <input id="satactbox" name="satactbox" type="checkbox" />
                <label for="satactbox" id="satactlabel">
                    SAT/ACT Consultation</label></td>
            <td style="border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
                &nbsp;</td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg3" type="button" value="Honors Advantage" style="width: 150px" onclick="myclick(3);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" nowrap="noWrap">
                Admissions Probability:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed">
                <input id="apbox" name="apbox" type="checkbox" />
                <label for="apbox" id="aplabel">
                    Admissions Probability</label></td>
            <td style="border-bottom: #cccccc 1px dashed">
                &nbsp;</td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg4" type="button" value="Honors Advantage Plus" style="width: 150px" onclick="myclick(4);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff" nowrap="noWrap">
                Appeal Advice:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
                <input id="aabox" name="aabox" type="checkbox" />
                <label for="aabox" id="aalabel">
                    Appeal Advice</label></td>
            <td style="border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
                &nbsp;</td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg5" type="button" value="Dean's Package" style="width: 150px" onclick="myclick(5);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" nowrap="noWrap">
                College Selection Service:</td>
            <td style="padding-left: 20px; border-bottom: #cccccc 1px dashed">
                <input id="ccsbox" name="ccsbox" type="checkbox" />
                <label for="ccsbox" id="ccslabel">
                    CRS College Selection</label></td>
            <td style="border-bottom: #cccccc 1px dashed">
                <input id="ecbox" name="ecbox" type="checkbox" />
                <label for="ecbox" id="eclabel">
                    Educational Consulting</label></td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg6" type="button" value="Trustee Package" style="width: 150px" onclick="myclick(6);" /></td>
        </tr>
        <tr>
            <td style="border-right: #cccccc 1px solid; width: 1%; border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff" nowrap="noWrap">
                Client Welcome Kit:</td>
            <td align="left" style="padding-left: 20px; border-bottom: #cccccc 1px dashed;" bgcolor="#e7e7ff">
                <input id="wkbox" name="wkbox" type="checkbox" />
                <label for="wkbox" id="wklabel">
                    Client Welcome Kit</label></td>
            <td style="border-bottom: #cccccc 1px dashed" bgcolor="#e7e7ff">
                &nbsp;</td>
            <td>
            </td>
            <td style="text-align: center; border-right: black 1px solid; border-left: black 1px solid;">
                <input id="pkg7" type="button" value="Elite Package" style="width: 150px" onclick="myclick(7);" /></td>
        </tr>
        <tr>
            <td nowrap="nowrap" style="border-right: #cccccc 1px solid">
                Price:</td>
            <td align="left" style="padding-left: 20px">
                <asp:TextBox ID="price" runat="server" Font-Names="Calibri,Verdana,Arial" Font-Size="12pt">$</asp:TextBox></td>
            <td>
                &nbsp;</td>
            <td>
            </td>
            <td style="border-right: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid;
                text-align: center"><input id="clearMe" type="button" value="Clear" style="width: 75px" onclick="clearboxes();" /></td>
        </tr>
    </table>
    <br />
    <asp:Button ID="savebutton" runat="server" Text="Save Changes" OnClick="savebutton_Click" /></form>
<!--#include file="./footer.aspx"-->
</body></html>