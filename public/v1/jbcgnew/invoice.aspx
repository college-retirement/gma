<%@ Page Language="C#" AutoEventWireup="true" CodeFile="invoice.aspx.cs" Inherits="jbcgnew_invoice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>College & Retirement Solutions Invoice</title>
    <style type="text/css">
        body
        {
            margin-top: 0px;
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        table.break
        {
            page-break-after: always;
            /*page-break-inside: avoid;*/
        }
        td.PAhead
        {
            font-size: 14pt;
            font-weight: bold;
            padding: 2px 2px 2px 2px;
            text-align: left;
            border-bottom: solid 3px black;
        }
        td.PAitem
        {
            padding-bottom: 15px;
        }
        a.hide:link
        {
            color: #DDDDDD;
            border-bottom: dotted 1px #DDDDDD;
            padding-left: 4px;
            padding-right: 4px;
            text-decoration: none;
        }
        a.hide:visited
        {
            color: #DDDDDD;
            border-bottom: dotted 1px #DDDDDD;
            padding-left: 4px;
            padding-right: 4px;
            text-decoration: none;
        }
        a.hide:hover
        {
            font-weight: bold;
            color: #FF0000;
            border: solid 2px #FF0000;
            padding-left: 2px;
            padding-right: 2px;
            text-decoration: none;
        }
        @media print
        {
            a.hide
            {
                display: none;
            }
        }
    </style>

    <script language="javascript" type="text/javascript">
<!--


        var list1 = new Array('<%= studentName.ClientID %>',
                        '<%= parentName.ClientID %>',
                        '<%= emailAddress.ClientID %>',
                        '<%= address.ClientID %>',
                        '<%= TextBox7.ClientID %>',
                        '<%= gradYear.ClientID %>',
                        '<%= homePhone.ClientID %>',
                        '<%= TextBox9.ClientID %>',
                        '<%= cityStateZip.ClientID %>',
                        '<%= TextBox8.ClientID %>');

        var list2 = new Array('<%= Label1.ClientID %>',
                        '<%= Label2.ClientID %>',
                        '<%= Label4.ClientID %>',
                        '<%= Label5.ClientID %>',
                        '<%= TextBox4.ClientID %>',
                        '<%= gradYear2.ClientID %>',
                        '<%= Label3.ClientID %>',
                        '<%= TextBox6.ClientID %>',
                        '<%= Label6.ClientID %>',
                        '<%= TextBox5.ClientID %>');

        function mirror1() {
            for (var i = 0; i < 10; i++) {
                var x = document.getElementById(list1[i]);
                var y = document.getElementById(list2[i]);
                y.value = x.value;
            }
        }

        function mirror2() {
            for (var i = 0; i < 10; i++) {
                var x = document.getElementById(list1[i]);
                var y = document.getElementById(list2[i]);
                x.value = y.value;
            }
        }

        function hide(optnum) {
            var x = document.getElementById("PMT" + optnum);
            x.style.display = 'none';
        }
// -->
    </script>

</head>
<body>
    <form runat="server" id="form1">
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 10in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Package Summary</span>
							<br><br>
							<asp:Label ID="packagebox" runat="server" Font-Name="Calibri" Font-Bold="True" Font-Size="12pt"></asp:Label>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
		
        <tr>
            <td style="text-align: left; font-size: 8pt; font-family: Calibri, Verdana;" valign="top">
                <table style="width: 100%; height: 8in">
					<tr>
						<td style="text-align: left; font-size: 12pt; font-family: Calibri, Verdana;" valign="top">
						College & Retirement Solutions help families overcome their college funding problems through the development of effective strategies. <b>If you just want band-aid solutions, then we are not the right organization to assist you.</b> Our programs are comprehensive and will produce measurable results. We are committed to partnering with you to obtain the long term outcomes that you will need to secure your child’s future and your financial future.
						<br><br>
						This service package includes on-going assistance of our professional staff - this assistance will be available until your student graduates High School. You will be provided the support necessary to accomplish all of the steps as outlined in your service agreement that you and your student will need to take throughout the admission process.<br><br>
						</td>
					</tr>
                    <tr>
                        <td valign="top">
                            <asp:DataList ID="DataList1" runat="server" CellPadding="5" Width="100%">
                                <ItemTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td width="15">
                                            </td>
                                            <td colspan="2">
                                                <asp:Label Text='<%# Eval("name") %>' ID="productLabel" runat="server" Font-Bold="True"
                                                    Font-Underline="True"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15">
                                            </td>
                                            <td width="15">
                                            </td>
                                            <td>
                                                <asp:Label Text='<%# Eval("print_description") %>' ID="productDescription" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <br />
                            <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td valign="top" width="50">
                                        <asp:Label ID="notelabel" runat="server" Text="Notes:"></asp:Label>
                                    </td>
                                    <td colspan="3" style="border-right: #cccccc 1px solid; border-top: #cccccc 1px solid;
                                        border-left: #cccccc 1px solid; border-bottom: #cccccc 1px solid; background-color: #FFFACD;
                                        font-size: 11pt; font-weight: bold;">
                                        <asp:Label ID="notebox" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    <br />
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 10in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Engagement Agreement</span>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left; font-size: 11pt; font-family: Calibri, Arial;" valign="top">
                <table style="width: 100%; height: 8in">
                    <tr>
                        <td valign="top">
                            <span style="font-size: 14pt"><strong>I. <span style="text-decoration: underline">Privacy
                                Notice and Disclosure Policy</span></strong></span><br />
                            We want you to know that protecting the privacy of your personal information is one of our top priorities.  We value our relationship with you.  The very nature of our relationship with you requires us to collect or share certain types of information about you.  We want you to know what information we collect, how we protect it and how we may use it.  This privacy notice explains how we use and protect potential, current and former customer information.  Please read it carefully.<br />
                            <br />
                            <strong>What Personal Information Do We Have?<br />
                            </strong>
                            We collect information, such as name, address, social security number, assets, income or employment status we need to provide the products or services you request and to administer your business with us.  The type of information we collect depends on the products or services you have purchased from “CRS” and may include:<br />
                            <ul>
                                <li>Information we receive from you when you request product information or complete an application, a fact finder for college planning, or other form.</li>
                                <li>Information about your transactions and relationships with us and our family of companies.</li>
                                <li>Information we receive from consumer-reporting agencies.</li>
                            </ul>
                            <p>
                                <strong>How Do We Use Your Personal Information?
                                    <br />
                                </strong>We may use your personal information and may provide it to others such as your planner, any 3rd party companies and firms providing services on our behalf (such as College Scholarship Service Profile, FAFSA, Online Test Prep, and another other company).
                                <ul>
                                    <li>To process your requests and transactions</li>
                                    <li>To fulfill legal and regulatory requirements</li>
                                    <li>To perform services for us on our behalf or on your behalf</li>
                                </ul>
                            </p>
                            <p>
                                We do not disclose non-public personal information about our potential, current,
                                and former customers unless allowed or required by law.

				We may share such information without authorization, to the extent permitted by law, with third parties or affiliates assisting us, such as those who assist us in performing our obligations.</p>
                            <p>
                                <strong>Protecting the Confidentiality of Your Personal Information
                                    <br />
                                </strong>We only allow access to your personal information to those individuals who need it to provide products or services for us or on our behalf.  Individuals who have access to your personal information are required to keep it strictly confidential.  We provide training to our employees about the importance of protecting the privacy of your information.  We maintain safeguards to protect your personal information.
                            </p>
                            <p>
                                <span style="font-size: 14pt"><strong>II. <span style="text-decoration: underline">Limitation
                                    of Scope of Services</span></strong></span><br />
                                The recommendations and practices used by College and Retirement Solutions, LLC
                                to reduce the expected family contribution to college tuition are ethical and consistent
                                with the calculations used by federal and institutional methodologies. Results are
                                not guaranteed as the final decision is made at the discretion of the college/university’s
                                admission and/or financial aid administrators.</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    <br />
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 9.5in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Engagement Agreement</span>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left; font-size: 11pt; font-family: Calibri, Arial;" valign="top">
                <table style="width: 100%; height: 8.5in">
                    <tr>
                        <td valign="top">

                                <strong>These college services are not designed for, nor should they be relied upon as a 
                                substitute for a participant’s own business judgment and should not mitigate the 
                                necessity of the participant’s personal review and analysis of any suggestions 
                                and ultimate implementation of any of these suggestions. These services 
                                supplement the participant’s own planning and analysis and merely aid the 
                                participant in fulfilling his or her college services objectives.</strong> In addition, 
                                these services are not designed to discover fraud, irregularities, omissions or 
                                misrepresentations in materials that you provide us, including materials 
                                prepared by other financial advisors. These services also do not include other 
                                services, such as, but not limited to:
                            <ul>
                                <li>Tax compliance services, including tax preparation</li>
                                <li>Accounting and auditing services</li>
                                <li>Legal documents such as pension plans, wills, trusts, and other contracts</li>
<li>Financial planning or Investment Advice</li>
                                <li>Any other service not specifically outlined herein</li>
                            </ul>

                            <p>
                                <span style="font-size: 14pt"><strong>III. <span style="text-decoration: underline">
                                    Limit of Liability</span></strong></span>
                            <br />
                            Please note that our liability in any case is limited only to the fees you have paid to College & Retirement Solutions, LLC.  Other than that, we cannot assume any responsibility for any consequential damages that directly or indirectly result from your child’s non-acceptance for admission by any school or for unwillingness to help pay for it’s cost of attendance, regardless of the reasons for such non-acceptance or failure to provide such aid.
                            </p>
                            <p>
                                <span style="font-size: 14pt"><strong>IV. <span style="text-decoration: underline">
                                    Privacy Agreement</span></strong></span>
                             
                            <br />
                            Any personal information provided may be shared between College and Retirement Solutions, LLC solely for the purpose of understanding the family’s situation in detail.  College and Retirement Solutions will not disclose any information to parties not mentioned in this agreement.<br/><br/> 
                                <b>We will record all client meetings</b> and take handwritten notes to ensure that all concerns and comments are duly noted.  Information will be shared with all support staff, third party providers, and anyone deemed by College and Retirement Solutions, LLC as an integral participant in fulfilling the obligations of services purchased.
                                
                            </p>   
                            <p>
                                <span style="font-size: 14pt"><strong>V. <span style="text-decoration: underline">
                                    Client Cooperation</span></strong></span>
                            <br />
                                It is not possible to provide college services without the necessary information made available to us on a timely basis.  By indicating your acceptance of this engagement, you agree to provide us with the requested information and documents, such as tax returns, financial statements, summaries of investment accounts, wills, trusts, insurance policies, and any information regarding employment and retirement benefits.
                                </p>
                                
                            <p>
                                <span style="font-size: 14pt"><strong>VI. <span style="text-decoration: underline">Termination
                                    of Services</span></strong></span><br />
                                CRS’s forms processing fee represents the school year when you engaged our services.  You may terminate this engagement at any time by written notice to us.  Upon receipt of such notice, we will prepare and forward a bill for our expended time to date and refund any balance due.
                            </p>
                            <p style="font-size: 8pt;">
                                <strong style="text-decoration: underline;">SERVICE CONTRACT</strong>: This is a contract between <strong>you</strong>, our <strong>client(s)</strong> (jointly and severally,
                                <strong>“YOU”</strong>), and <strong>College and Retirement Solutions, LLC (“CRS”)</strong> to perform services indicated
                                on this contract. You will be billed according to the payment plan indicated on
                                this contract, if requested. Information regarding accounts in collection may be
                                reported to credit bureaus. We reserve the right to suspend service under this contract
                                should your account become past due. We will attempt to notify you of this suspension,
                                but failure by us to notify your family shall in no way encumber liability upon
                                CRS to any losses you or your family may sustain.
                            </p>
                            <p style="font-size: 8pt;">
                                <strong style="text-decoration: underline;">REFUND POLICY</strong><strong>: If you are dissatisfied with our services we will be happy to provide a pro-rated refund of your plan fees (less any additional child fees and renewal fees and third-party fees which are non-refundable).  You must make this request within 30 days of contract inception.  Requests received more than 30 days after inception will not be honored.</strong>  We reserve all rights and remedies provided by law to collect delinquent accounts (more than 60 days past due).  If you account becomes more than 60 days past due, without giving us written notice of your intention to request a refund, your rights to any refunds or remedies provided by this contract will become null and void. Additionally, for any refunded service there will be a $34.00 bank processing fee deducted from each refunded payment.
                            </p>
                            <p style="font-size: 8pt;">
                                <strong><em>The terms of this agreement may be modified, at any time, to comply with any state,
                                federal or local law or regulation.</em></strong>
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    <br />
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 10in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Engagement Agreement</span>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left; font-size: 11pt; font-family: Calibri, Arial;" valign="top">
                <table style="width: 100%; height: 8.5in">
                    <tr>
                        <td valign="top">
                            <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td colspan="3">
                                        <span style="font-size: 14pt"><strong>VII. <span style="text-decoration: underline">Student/Family
                                            Information and Client Fees</span></strong></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 47%; font-size: 11pt;" width="47%" height="20">
                                        <asp:TextBox ID="studentName" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="width: 47%; font-size: 11pt;" width="47%" height="20">
                                        <asp:TextBox ID="gradYear" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Student Name
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Year of Graduation
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="parentName" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="homePhone" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Custodial Parent's Name(s)
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Home Phone &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Work Phone (Primary Contact)
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="emailAddress" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox9" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Primary Email Address
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Cell (Mother) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Cell (Father)
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="address" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="cityStateZip" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Address
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        City &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; State &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Zip
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox7" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox8" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Additional Students (If Enrolled Now)
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Year of Graduation
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="font-size: 10pt; vertical-align: top">
                                        The client agrees to pay $<asp:Label ID="pricelabel1" runat="server" Font-Underline="True"></asp:Label>
                                        for the services listed above, and is applicable through the school year ending
                                        June
                                        <%= getCaseYear(0) %>.<br />
                                        <br />
										The College Family Advocacy fee is applicable for the years the student is in college.
										This annual renewal fee will not exceed $299.00 beginning year
                                        <!--The College Family Advocacy fee is $299.00 beginning year-->
                                        <%= getCaseYear(1) %>
                                        (payable during the student’s school years).  Fees are due no later than November 15th to avoid the late charge of $50.00.<br />
                                        <br />
                                        Client Promise: The client promises to provide information and documentation as
                                        required, in a timely manner, to facilitate the provision of services by College
                                        and Retirement Solutions, LLC.<br />
                                        <br />
                                        * The re-filing of all financial aid forms is required every year a student in school.<br />
                                        <br />
                                        <strong><em>By signing below, you acknowledge that the definitions and terms of our engagement
                                        have been explained, including all fees and what is related to those fees and you
                                        accept those terms and conditions. </em></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top; width: 47%; height: 40px" width="47%">
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="vertical-align: top; width: 47%; height: 40px" width="47%">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Client/Parent Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Representative Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        General Agent Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="vertical-align: top; height: 40px; text-align: center">
                                        <em><strong>Client Copy</strong></em>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    <br />
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 10in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Engagement Agreement</span>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left; font-size: 11pt; font-family: Calibri, Arial;" valign="top">
                <table style="width: 100%; height: 8in">
                    <tr>
                        <td valign="top">
                            <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td colspan="3">
                                        <span style="font-size: 14pt"><strong>VII. <span style="text-decoration: underline">Student/Family
                                            Information and Client Fees</span></strong></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 47%; font-size: 11pt;" width="47%" height="20">
                                        <asp:TextBox ID="Label1" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="width: 47%; font-size: 11pt;" width="47%" height="20">
                                        <asp:TextBox ID="gradYear2" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Student Name
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Year of Graduation
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="Label2" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="Label3" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Custodial Parent's Name(s)
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Home Phone &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Work Phone (Primary Contact)
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="Label4" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox6" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Primary Email Address
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Cell (Mother) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Cell (Father)
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="Label5" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="Label6" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Address
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        City &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; State &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Zip
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox4" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                    <td height="20" style="width: 6%" width="6%">
                                    </td>
                                    <td height="20" style="font-size: 11pt; width: 47%" width="47%">
                                        <asp:TextBox ID="TextBox5" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Additional Students (If Enrolled Now)
                                    </td>
                                    <td style="width: 6%" width="6%" height="20">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;"
                                        width="47%" height="20">
                                        Year of Graduation
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="font-size: 10pt; vertical-align: top">
                                        The client agrees to pay $<asp:Label ID="pricelabel2" runat="server" Font-Underline="True"></asp:Label>
                                        for the services listed above, and is applicable through the school year ending
                                        June
                                        <%= getCaseYear(0) %>
                                        .<br />
                                        <br />
										The College Family Advocacy fee is applicable for the years the student is in college.
										This annual renewal fee will not exceed $299.00 beginning year
                                        <!--The College Family Advocacy fee is $299.00 beginning year-->
                                        <%= getCaseYear(1) %>
                                        (payable during the student’s school years).  Fees are due no later than November 15th to avoid the late charge of $50.00.<br />
                                        <br />
                                        Client Promise: The client promises to provide information and documentation as
                                        required, in a timely manner, to facilitate the provision of services by College
                                        and Retirement Solutions, LLC.<br />
                                        <br />
                                        * The re-filing of all financial aid forms is required every year a student in school.<br />
                                        <br />
                                        <strong><em>By signing below, you acknowledge that the definitions and terms of our
                                            engagement have been explained, including all fees and what is related to those
                                            fees and you accept those terms and conditions. </em></strong>
                                    </td>
                                </tr>
                                <tr style="font-weight: bold; font-style: italic">
                                    <td style="vertical-align: top; width: 47%; height: 40px" width="47%">
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="vertical-align: top; width: 47%; height: 40px" width="47%">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Client/Parent Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Representative Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        General Agent Signature
                                    </td>
                                    <td style="width: 6%" width="6%">
                                    </td>
                                    <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                                        height: 40px" width="47%">
                                        Date
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="vertical-align: top; height: 40px; text-align: center">
                                        <em><strong>Office Copy</strong></em>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax

                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    <br />
    <table class="break" border="0" cellpadding="5" cellspacing="0" style="width: 8in;
        height: 10in;" align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Disclosures</span>
                            </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <table cellpadding="0" cellspacing="15" border="0" style="width:100%; font-family:Calibri;">
                    <tr>
                        <td style="width: 10%; vertical-align:top;">
                            <table>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                    <td nowrap="nowrap" style="border-top: black 1px solid; font-size: 8pt; vertical-align: top;">
                                        (Initial Here)
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 90%; vertical-align:top;">
                            By initialing and signing below, you are specifically stating that you would like to have a discussion regarding your personal finances  and to assess if there are any issues as they relate to your family’s future goals, including debt management, retirement, college funding, risk management, and any other possible concern that may arise out of a review of your circumstances.</td>
                    </tr>
                    <tr>
                        <td style="width: 10%; vertical-align:top;">
                            <table>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                    <td nowrap="nowrap" style="border-top: black 1px solid; font-size: 8pt; vertical-align: top;">
                                        (Initial Here)
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 90%; vertical-align:top;">
                            It is understood if any re-aligning of assets or purchase of financial products  is done through a licensed professional, it is possible a commission may be earned.  It is also understood that any suggestions made to alter your family financial circumstances can be done so through any representative of your choosing.  If so requested, we can refer you to a professional.
</td>
                    </tr>
                    <tr>
                        <td style="width: 10%; vertical-align:top;">
                            <table>
                                <tr><td>&nbsp;</td></tr>
</td></tr>
                                <tr>
                                    <td nowrap="nowrap" style="border-top: black 1px solid; font-size: 8pt; vertical-align: top;">
                                        (Initial Here)
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 90%; vertical-align:top;">
                            Further you acknowledge that this review is not part of the fees that you paid to College & Retirement Solutions, LLC.  The fees paid to College & Retirement Solutions are for the services as outlined in your engagement agreement <span style="text-decoration:underline;">only</span>.
                            </td>
                    </tr>
		    <tr>
                        <td style="width: 10%; vertical-align:top;">
                            <table>
                                <tr><td>&nbsp;</td></tr>
</td></tr>
                                <tr>
                                    <td nowrap="nowrap" style="border-top: black 1px solid; font-size: 8pt; vertical-align: top;">
                                        (Initial Here)
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 90%; vertical-align:top;">
				I acknowledge that College & Retirement Solutions, LLC will record all client meetings and take handwritten notes to ensure that all concerns and comments are duly noted. Information will be shared with all support staff, third party providers, and anyone deemed by College and Retirement Solutions, LLC as an integral participant.
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="5" cellspacing="0" style="width: 100%; font-family: Calibri;">
                    <tr>
                        <td style="height: 40px" colspan="3">&nbsp;
                            
                        </td>
                    </tr>
                    <tr>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            Client/Parent Signature
                        </td>
                        <td style="width: 6%" width="6%">
                        </td>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            Date
                        </td>
                    </tr>
                    <tr>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            Representative Signature
                        </td>
                        <td style="width: 6%" width="6%">
                        </td>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            Date
                        </td>
                    </tr>
                    <tr>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            General Agent Signature
                        </td>
                        <td style="width: 6%" width="6%">
                        </td>
                        <td style="border-top: black 1px solid; font-size: 8pt; vertical-align: top; width: 47%;
                            height: 40px" width="47%">
                            Date
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" style="vertical-align: top; height: 40px; text-align: center">
                            <em><strong>Office Copy</strong></em>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>        
    <br />
    <table border="0" cellpadding="5" cellspacing="0" style="width: 8in; height: 10in;"
        align="center">
        <tr>
            <td style="border-bottom: black 1px solid; height: 1%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td rowspan="2" valign="top">
                            <span style="font-size: 16pt; font-family: Calibri">Payment Authorization Form</span>
                        </td>
                        <td style="padding-right: 5px; text-align: right; font-size: 9pt;" nowrap="noWrap"
                            valign="top" width="1%">
                            <span style="font-family: Calibri">College &amp; Retirement Solutions<br />
                                667 Shunpike Rd, Suite 3<br />
                                Chatham, NJ 07928<br />
                                (973) 514-2002</span>
                        </td>
                        <td style="text-align: right; font-size: 12pt; color: #0000ff; text-decoration: underline;"
                            width="100">
                            <img src="../Images/CRS3.gif" width="100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="2" valign="top">
                            <span style="font-family: Calibri; color: #000000; font-size: 9pt;">www.college-retirement.com</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left; font-size: 11pt; font-family: Calibri, Arial;" valign="top">
                <table style="width: 100%; height: 8in">
                    <tr>
                        <td valign="top">
                            <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td style="padding-top: 25px" class="PAitem">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td nowrap="nowrap" style="width: 1%; padding-right: 5px; padding-left: 15px;">
                                                    Advisor Name:
                                                </td>
                                                <td style="border-bottom: black 1px solid">
                                                    <img src="../Images/invisible.gif" />
                                                </td>
                                                <td style="width: 49%; border-bottom: black 1px solid;">
                                                    <asp:TextBox ID="TextBox1" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                                </td>
                                                <td nowrap="nowrap" style="width: 1%; padding-right: 5px; padding-left: 15px;">
                                                    Client Name:
                                                </td>
                                                <td style="border-bottom: black 1px solid; width: 49%;">
                                                    <asp:TextBox ID="Label7" runat="server" BorderWidth="0px" Width="95%"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PAhead">
                                        Services
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left" class="PAitem">
                                        <asp:DataList ID="PAserviceList" runat="server" Width="100%" RepeatColumns="2" RepeatDirection="Horizontal">
                                            <ItemTemplate>
                                                •
                                                <asp:Label ID="PA_Item" runat="server" Text='<%# Eval("name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:DataList>
                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td valign="top" width="50">
                                                </td>
                                                <td align="right">
                                                </td>
                                                <td style="width: 1%; padding-top: 15px" align="right" nowrap="noWrap">
                                                    Retail Price:
                                                </td>
                                                <td align="right" style="width: 1%; padding-top: 15px" nowrap="noWrap">
                                                    $<asp:Label ID="retailprice" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" width="50">
                                                </td>
                                                <td align="right">
                                                </td>
                                                <td align="right" nowrap="nowrap" style="width: 1%; border-bottom: black 1px solid;
                                                    color: red;">
                                                    <asp:Label ID="discountName" runat="server">- Discount:</asp:Label>
                                                </td>
                                                <td align="right" style="width: 1%; border-bottom: black 1px solid; color: red;"
                                                    nowrap="noWrap">
                                                    <asp:Label ID="discountbox" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" width="50">
                                                </td>
                                                <td align="right">
                                                </td>
                                                <td align="right" nowrap="nowrap" style="width: 1%; font-weight: bold; font-size: 10pt;">
                                                    <asp:Label ID="priceName" runat="server">Your Price:</asp:Label>
                                                </td>
                                                <td align="right" style="width: 1%; font-weight: bold; font-size: 10pt;" nowrap="noWrap">
                                                    <asp:Label ID="pricebox" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PAhead" style="text-align: left">
                                        Payment Options Summary
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PAitem" style="text-align: left">
                                        The price for these services is payable by any payment schedule listed below. <span
                                            style="font-size: 8pt">(Please check only one)</span><br />
                                        <br />
                                        <input id="Checkbox2" type="checkbox" value="on" />
                                        <asp:Label ID="Label8" runat="server"></asp:Label><br />
                                        <br />
                                        <asp:DataList ID="DataList2" runat="server" RepeatColumns="2" RepeatDirection="Horizontal"
                                            Width="100%">
                                            <HeaderTemplate>
                                                Installment Plans:<br />
                                                <span style="font-size: 8pt">(Payments must be made via Credit Card. Check payment option
                                                    not available for installment plans)</span>
                                            </HeaderTemplate>
                                            <FooterTemplate>
                                                <span style="font-size: 8pt">Please Note: All installment payments shown include an additional monthly service charge of 3.5% per debit (FYI - This is the cost from our credit card payment processor.)</span>
                                            </FooterTemplate>
                                            <ItemTemplate>
                                                <span id='<%# "PMT" + Eval("ID").ToString() %>'>
                                                    <input id="Checkbox1" type="checkbox" />
                                                    <asp:Label ID="Label9" runat="server" Text='<%# Eval("Option") %>'></asp:Label>
                                                    <a class="hide" href='<%# "javascript:hide(" + Eval("ID").ToString() + ");" %>'>X</a>
                                                </span>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PAhead">
                                        Check and Credit Card Information
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PAitem">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td colspan="4">
                                                    If paying by check, please make check payable to <span><span style="text-decoration: underline"><strong>
                                                        College and Retirement Solutions</strong></span>.<br />
                                                    </span>
                                                    <br />
                                                    If paying by credit card, please complete the section below. <strong>Your signature
                                                        is required.</strong><br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="width: 1%">
													<br />
													Credit Card #:
                                                </td>
                                                <td colspan="1" style="border-bottom: black 1px solid" valign="bottom">
                                                    &nbsp;
                                                </td>
												<td nowrap="nowrap" style="width: 1%" align="right">
                                                    <br />
                                                    CVV #:
                                                </td>
												<td colspan="1" style="border-bottom: black 1px solid" valign="bottom">
													&nbsp;
												</td>
                                                <td nowrap="nowrap" style="width: 1%" align="right">
                                                    <br />
                                                    Zip Code:
                                                </td>
                                                <td colspan="1" style="border-bottom: black 1px solid" valign="bottom">
                                                    <asp:TextBox ID="zipCode" runat="server" BorderWidth="0px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" nowrap="nowrap" style="width: 1%" valign="bottom">
                                                    <br />
                                                    Expiration Date:
                                                </td>
                                                <td style="width: 49%; border-bottom: black 1px solid" valign="bottom">
                                                    &nbsp;
                                                </td>
                                                <td align="right" nowrap="nowrap" style="width: 1%" valign="bottom">
                                                    <br />
                                                    Card Type:
                                                </td>
                                                <td style="width: 49%" valign="bottom">
                                                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatColumns="3" Width="100%">
                                                        <asp:ListItem>Visa</asp:ListItem>
                                                        <asp:ListItem>MasterCard</asp:ListItem>
                                                        <asp:ListItem>Discover</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                        </table>
                                        
										<p><br />I hereby authorize College &amp; Retirement Solutions to charge my credit card fees
                                        for services in the amount and description of the payment plan described above.</p>
										
										<table
                                            border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td nowrap="nowrap" style="padding-right: 10px; width: 1%">
                                                    <br />
                                                    Authorized Signature:
                                                </td>
                                                <td style="border-bottom: black 1px solid; width: 60%;">
                                                    <img src="../Images/invisible.gif" />
                                                </td>
                                                <td nowrap="nowrap" style="width: 1%">
                                                    <br />
                                                    &nbsp; &nbsp; &nbsp; Date:
                                                </td>
                                                <td style="border-bottom: black 1px solid">
                                                    <img src="../Images/invisible.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding-right: 10px; width: 1%">
                                                    <br />
                                                    Print Name:
                                                </td>
                                                <td style="border-bottom: black 1px solid; width: 60%;">
                                                    <img src="../Images/invisible.gif" />
                                                </td>
                                                <td style="width: 1%">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-top: black 1px solid; text-align: center; height: 25px;" valign="top">
                <span style="font-size: 7pt; color: #A9A9A9; font-family: Calibri">If investment, financial,
                    mortgage or insurance planning and/or products are required, College and Retirement
                    Solutions, LLC may refer you to other firms/companies. Any discussion of the Tax
                    implications of planning is strictly for general purposes. Neither "CRS" nor its
                    representatives may give specific tax advice. One should seek the advice and counsel
                    of their accountant and/or tax advisor for information regarding their particular
                    situation.</span>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
