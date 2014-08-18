using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class jbcgnew_invoice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["account_type"] == null || Session["account_type"].ToString().ToLower() == "customer")
            Response.Redirect("../default.aspx");
        if(Request.QueryString["id"] == null || Request.QueryString["id"].ToString() == string.Empty)
            Response.Redirect("../default.aspx");

        if (Page.IsPostBack) return;

        initPage();
    }

    public void initPage()
    {
        int myID = Convert.ToInt32(Request.QueryString["id"].ToString());
        CRSCRM.Sale mySale = new CRSCRM.Sale(myID);
        pricebox.Text = "$" + toMoney(mySale.price);
        pricelabel1.Text = toMoney(mySale.price);
        pricelabel2.Text = toMoney(mySale.price);
        //PA_Price_2.Text = PA_price.Text = mySale.price.ToString();
        DataTable parentInfo = SQLManager.GetData("*","mfac_parent_info","where ID='1' AND claimid='" + mySale.caseID.ToString() + "'");
        DataTable caseInfo = SQLManager.GetData("*", "mfac_client_data2", "where id='" + mySale.caseID + "'");
        if(parentInfo.Rows.Count > 0 && parentInfo.Rows[0]["col0004"] != DBNull.Value)
            packagebox.Text = mySale.package + " for the " + parentInfo.Rows[0]["col0004"].ToString() + " Family";
        else packagebox.Text = "Your Package: " + mySale.package;
        notebox.Text = mySale.notes;
        if (notebox.Text == string.Empty)
            notelabel.Visible = false;
        discountbox.Text = "$" + toMoney(mySale.discount);
        retailprice.Text = toMoney(mySale.retailprice);

        if (parentInfo.Rows.Count > 0)
        {
            Label7.Text = Label2.Text = parentName.Text = parentInfo.Rows[0]["col0002"].ToString() + " " + parentInfo.Rows[0]["col0004"].ToString();
            Label4.Text = emailAddress.Text = parentInfo.Rows[0]["col0018"].ToString();
        }

        if (caseInfo.Rows.Count > 0)
        {
            Label1.Text = studentName.Text = caseInfo.Rows[0]["col0002"].ToString() + " " + caseInfo.Rows[0]["col0004"].ToString();
            Label5.Text = address.Text = caseInfo.Rows[0]["col0007"].ToString();
            Label6.Text = cityStateZip.Text = caseInfo.Rows[0]["col0009"].ToString() + ", " + caseInfo.Rows[0]["col0010"].ToString() + " " + caseInfo.Rows[0]["col0011"].ToString();
            Label3.Text = homePhone.Text = caseInfo.Rows[0]["col0013"].ToString();
            gradYear.Text = gradYear2.Text = caseInfo.Rows[0]["col0020"].ToString();
            zipCode.Text = caseInfo.Rows[0]["col0011"].ToString();
        }

        DataTable myProducts = mySale.Products();
        DataList1.DataSource = myProducts;
        DataList1.DataBind();
        PAserviceList.DataSource = myProducts;
        PAserviceList.DataBind();

        studentName.Attributes.Add("onchange", "mirror1()");
        parentName.Attributes.Add("onchange", "mirror1()");
        emailAddress.Attributes.Add("onchange", "mirror1()");
        address.Attributes.Add("onchange", "mirror1()");
        TextBox7.Attributes.Add("onchange", "mirror1()");
        gradYear.Attributes.Add("onchange", "mirror1()");
        homePhone.Attributes.Add("onchange", "mirror1()");
        TextBox9.Attributes.Add("onchange", "mirror1()");
        cityStateZip.Attributes.Add("onchange", "mirror1()");
        zipCode.Attributes.Add("onchange", "mirror1()");
        TextBox8.Attributes.Add("onchange", "mirror1()");

        Label1.Attributes.Add("onchange", "mirror2()");
        Label2.Attributes.Add("onchange", "mirror2()");
        Label4.Attributes.Add("onchange", "mirror2()");
        Label5.Attributes.Add("onchange", "mirror2()");
        TextBox4.Attributes.Add("onchange", "mirror2()");
        gradYear2.Attributes.Add("onchange", "mirror2()");
        Label3.Attributes.Add("onchange", "mirror2()");
        TextBox6.Attributes.Add("onchange", "mirror2()");
        Label6.Attributes.Add("onchange", "mirror2()");
        TextBox5.Attributes.Add("onchange", "mirror2()");

        double myPrice = 0;
        int myPrice1 = 0;
        DataTable myOptions = new DataTable();
        if (mySale.discount > 0)
        {
            Label8.Text = "1 Payment of $" + toMoney(mySale.price);
            myOptions = setupPaymentOpts(mySale.retailprice, false);
        }
        else
        {
            discountbox.Visible = false;
            discountName.Visible = false;
            pricebox.Visible = false;
            priceName.Visible = false;
            myPrice = mySale.price;
            myPrice1 = Convert.ToInt32(90 * myPrice);
            myPrice = Convert.ToDouble(myPrice1 / 100);
            Label8.Text = "1 Payment of $" + toMoney(myPrice) + " <span style=\"color:red; font-weight:bold;\"></span>";
            myOptions = setupPaymentOpts(mySale.price, true);
        }
        DataList2.DataSource = myOptions;
        DataList2.DataBind();
        if (myOptions.Rows.Count < 1)
            DataList2.Visible = false;
    }

    private DataTable setupPaymentOpts(double price, bool discounts)
    {
        
        double threshold1 = 1000.00, threshold1a = 1100.00, threshold2 = 1200.00;
        double myPrice = price;
        int myPrice1 = 0;
        DataTable myOptions = new DataTable();
        myOptions.Columns.Add("ID", System.Type.GetType("System.Int32"));
        myOptions.Columns.Add("Option", System.Type.GetType("System.String"));
        if (price >= threshold1)
        {
            /* Create counter to set posititon in rows*/
            int i = 0;
            if (discounts)
            {
                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $1250 and 1 Payment of $" + toMoney(myPrice * 1.250);
                myOptions.Rows[i]["ID"] = 0;
                i = i + 1;
            }
/*            else
            {
                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price / 1) * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100));
                myOptions.Rows[0]["Option"] = "1 Payment of $" + toMoney(myPrice);
                myOptions.Rows[0]["ID"] = 0;
/*              Edited 6/22/09 NZ wanted no discount for 3rd payment
                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price / 3) * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 2.50);
                myOptions.Rows[1]["Option"] = "3 Payments of $" + toMoney(myPrice);
                myOptions.Rows[1]["ID"] = 1;
 
            }*/
			if (price >= threshold1a & price < threshold2)
            {
                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) / 2 * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $250 and 2 Payments of $" + toMoney(myPrice * 1.035);
                myOptions.Rows[i]["ID"] = 1;
                i = i + 1;
            }
			
            if (price >= threshold2)
            {
                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) / 2 * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $1250 and 2 Payments of $" + toMoney(myPrice * 1.035);
                myOptions.Rows[i]["ID"] = 1;
				i = i + 1;

				myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) / 3 * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $1250 and 3 Payments of $" + toMoney(myPrice * 1.035);
                myOptions.Rows[i]["ID"] = 2;
                i = i + 1;

                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) / 4 * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $1250 and 4 Payments of $" + toMoney(myPrice * 1.035);
                myOptions.Rows[i]["ID"] = 3;
                i = i + 1;

                myOptions.Rows.Add(myOptions.NewRow());
                myPrice = ((price - 1250) / 5 * 100);
                myPrice1 = Convert.ToInt32(myPrice);
                myPrice = ((Convert.ToDouble(myPrice1) / 100) + 5);
                myOptions.Rows[i]["Option"] = "1 Payment of $1250 and 5 Payments of $" + toMoney(myPrice * 1.035);
                myOptions.Rows[i]["ID"] = 4;
                i = i + 1;
                
            }
        }
        return myOptions;
    }

    public string toMoney(double money)
    {
        money = Math.Round(money, 2);
        string[] cash = money.ToString().Split('.');
        if (cash.Length > 1)
        {
            if (cash[1].Length == 2)
                return money.ToString();
            else if (cash[1].Length == 1)
                return money.ToString() + "0";
            else if (cash[1].Length == 0)
                return money.ToString() + ".00";
            else return money.ToString();
        }
        else return money.ToString() + ".00";

    }

    public string getYear(int offset)
    {
        if (DateTime.Now.Month >= 6)
            return DateTime.Now.AddYears(offset).Year.ToString();
        else return DateTime.Now.AddYears((offset-1)).Year.ToString();
    }

    public string getCaseYear(int offset)
    {
        int myID = Convert.ToInt32(Request.QueryString["id"].ToString());
        CRSCRM.Sale mySale = new CRSCRM.Sale(myID);
        int gradYear = Convert.ToInt32(SQLManager.GetValue("col0020", "mfac_client_data2", "where id='" + mySale.caseID.ToString() + "'")) + offset;
        return gradYear.ToString();
    }
    
}
