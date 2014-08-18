<%@ Page Language="C#" AutoEventWireup="true" CodeFile="step3.aspx.cs" Inherits="step3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="dist_userheader.ascx" TagName="dist_userheader" TagPrefix="uc4" %>
<%@ Register Src="user_header.ascx" TagName="user_header" TagPrefix="uc1" %>
<%@ Register Src="leftside.ascx" TagName="leftside" TagPrefix="uc2" %>
<%@ Register Src="bottom.ascx" TagName="bottom" TagPrefix="uc3" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
   <title>Waldor</title>
 
     <script language="javascript" type="text/javascript">
    function click()
    {
    
   alert("blank");
   alert(document.getElementById('FirstSideImprintUpload').value); 
   }
//    if( document.forms[0]['FirstSideImprintUpload'].value!="" || document.forms[0]['SecondImprintFileUpload'].value!="")
//    {
//    if( document.forms[0]['ArtworkContactName'].value=="" || document.forms[0]['Email'].value=="")
//    {
//    document.forms[0]['HiddenField1'].value==0;
//   
//    
//    }
//     
//    }
   
 // }
   </script>
    
  

    
    
  

    <link id="User_header1_Link1" href="js/dropdownstyle.css" rel="stylesheet" type="text/css" />
    <link href="js/dropdownstyle.css" rel="stylesheet" type="text/css" />
    <link id="Link1" href="js/dropdownstyle.css" rel="stylesheet" type="text/css" />
    
  

    
    
  
</head>
<body>
        <form id="form1" runat="server">
    <div>
        <table cellspacing="0" cellpadding="0" style="z-index: 100; left: 0px; position: absolute; top: 0px;margin-left:0px;margin-top:0px; width:100%">
        <%-- <%authent acatp1 = new authent();
           if (acatp1.log())
           { %>--%>
      <tr style=" height:100px; width:100%">
                <td colspan="3" style="height: 128px">
      <uc1:user_header ID="User_header1" runat="server" />
       <%-- <uc4:dist_userheader ID="Dist_userheader1" runat="server" />--%>
        </td>        
        </tr>
        <%--<%}else{ %>
         <tr style=" height:100px; width:100%">
                <td colspan="3" style="height: 128px">
       
        <uc4:dist_userheader ID="Dist_userheader2" runat="server" />
        </td>        
        </tr>
        <%} %>--%>
             <tr valign="middle" align="left" style="margin-left:0px;margin-top:0px;left: 0px;z-index: 100;">
           <%--  <%if (acatp1.log())
               {  %>--%>
            <td valign="top" align="left" style="width: 14%; height: 198px;margin-left:0px;margin-top:0px; border-right: #3eafbf thin solid;background-color:#9FCED4">
          <%--  <%}else{ %>
            <td valign="top" align="left" style="width: 14%; height: 198px;margin-left:0px;margin-top:0px; border-right: #3C1600 thin solid;background-color:#eadec7">
            <%} %>--%>
      <uc2:leftside ID="Leftside1" runat="server" /></td>
     <%-- bgcolor="3C1600"--%><td valign="top" bgcolor="00AACB" style="width: 1px"><img src="WalImages/spacer.gif" width="1" height="1"></td>
      <td valign="top" bgcolor="#FFFFFF" class="WhiteSpace"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="27%"><span class="title">Upload Artwork </span></td>
            <td width="73%"><a href="step1.aspx?style_no=<%=Session["cart_style"]%>">Step 1</a> &gt; <a href="step2.aspx">Step 2</a> &gt; <strong>Step 3</strong> <span class="Grey">&gt; Step 4 &gt; Step 5 &gt; Step 6 
                <asp:Label ID="ErrorLBL" runat="server" ForeColor="Red"></asp:Label></span></td>
          </tr>
        </table>
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td valign="top"><table width="100%" border="0" cellpadding="6" cellspacing="0">
                    <tr>
                      <td colspan="2" class="subtitle">&nbsp;
                          <asp:HiddenField ID="HiddenField1" runat="server" />
                      </td>
                    </tr>
                    <tr>
                      <td valign="top" style="width: 150px; height: 157px;"><strong>Please Enter Text:</strong><br>
                        <em class="tinyGrayText">There is no charge <br>
                        for straight line copy. <br>
                        <br>
                        <a href="general-info.aspx#type" target="_blank">Type Styles Available</a><br>
                        <br>
                        </em></td>
                      <td style="height: 157px">
                          <asp:TextBox ID="FirstSideImprint" runat="server" Rows="8" TextMode="MultiLine" Width="400px"></asp:TextBox></td>
                    </tr>
                    <tr>
                      <td style="width: 150px"><strong>If you are using artwork, <br>
                        please Upload Artwork.
                      </strong></td>
                      <td valign="top">
                          <asp:FileUpload ID="FirstSideImprintUpload" runat="server" /><br>
                          <a href="#">Click here for our artwork policy</a><br />
                          <asp:Label ID="ArtworkUploadedFile" runat="server"></asp:Label></td>
                    </tr>
					<tr>
                      <td colspan="2" valign="top" class="tinyGrayText" style="height: 26px"><em>If artwork is submitted, there is a $32.00 net Die Charge for each imprint. </em></td>
                    </tr>
                    <tr><td colspan="2">
                
                    <asp:Panel ID="SecondImprintPanel" runat="server">
                    <table>
                    <tr>
                      <td valign="top" style="width: 150px" width="150"><strong>Second Imprint:<br>
                        Please Enter Text:</strong><br>
                        <em class="tinyGrayText">There is no charge <br>
                        for straight line copy. </em></td>
                      <td>
                          <asp:TextBox ID="SecondImprintCopy" runat="server" Rows="8" TextMode="MultiLine"
                              Width="400px"></asp:TextBox></td>
                    </tr>
                    <tr>
                      <td valign="top"><strong>Second Imprint:<br> 
                        Please Upload <br>
                        Second Artwork.
                      </strong></td>
                      <td valign="top">
                          <asp:FileUpload ID="SecondImprintFileUpload" runat="server" />
                          <br />
                          <asp:Label ID="SecondImprintUploadedFile" runat="server"></asp:Label></td>
                    </tr>
                    </table>
                    </asp:Panel>
                    </td></tr>
                    <tr>
                      <td valign="top" style="width: 150px"><strong>Special Instructions:</strong></td>
                      <td valign="top">
                          <asp:TextBox ID="SpecialInstructions" runat="server" Rows="5" TextMode="MultiLine"
                              Width="400px"></asp:TextBox></td>
                    </tr>
                    <tr>
                      <td align="left" style="width: 150px"><p><strong>Artwork Contact
                        Name: </strong></p></td>
                        
                        
                      <td>
                          <asp:TextBox ID="ArtworkContactName" runat="server"></asp:TextBox>
                          <span class="required"> 
                              <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ArtworkContactName"
                                  Display="Dynamic" ErrorMessage="RequiredFieldValidator" Enabled="False">Artwork Contact Name is a required field.</asp:RequiredFieldValidator></span></td>
                    </tr>
                    <tr>
                      <td align="left" style="width: 150px"><strong>E-mail:</strong></td>
                      <td>
                          <asp:TextBox ID="Email" runat="server"></asp:TextBox><span class="required">
                              <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Email"
                                  Display="Dynamic" ErrorMessage="RequiredFieldValidator" Enabled="False">Email is a required field</asp:RequiredFieldValidator>
                              <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="Email"
                                  Display="Dynamic" ErrorMessage="Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Invalid Email</asp:RegularExpressionValidator></span></td>
                    </tr>
                    
                    <tr>
                      <td align="right" style="width: 150px">&nbsp;</td>
                      <td>
                          <asp:CheckBox ID="ProvideArtworkLater" runat="server" Text="I will provide my artwork later." /></td>
                    </tr>
                    <tr>
                      <td style="width: 150px">&nbsp;</td>
                      <td>
                          <asp:Label ID="Label1" runat="server" ForeColor="Red"></asp:Label><a href="#" class="tinybrowntext"></a></td>
                    </tr>
                    <tr>
                      <td style="width: 150px">&nbsp;</td>
                      <td><table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="16"  background="Walimages/tiny-bluebutton_01.jpg">&nbsp;</td>
                          <td class="tinybutton" style="FONT-WEIGHT: bold; FONT-SIZE: 11px; BACKGROUND-IMAGE: url(Walimages/tiny-bluebutton_02.jpg); PADDING-BOTTOM: 3px; BACKGROUND-REPEAT: repeat-x; HEIGHT: 30px; TEXT-ALIGN: center"  background="Walimages/tiny-bluebutton_02.jpg"><asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CssClass="whitelink"  PostBackUrl="~/step3.aspx">Next Step</asp:LinkButton>
                          </td>
                          <td width="16" background="Walimages/tiny-bluebutton_04.jpg">&nbsp;</td>
                        </tr>
                      </table></td>
                    </tr>
                </table></td>
                <td align="left" valign="top"><p>&nbsp;</p>
                  <table width="248" height="78" border="0" cellpadding="15" cellspacing="0" bgcolor="#F3ECDE">
                      <tr>
                        <td><strong><a href="product.aspx?style_no=<%=Session["cart_style"]%>"><img src="WalImages/<%=Session["cart_style"]%>_1.gif" width="100" height="110" hspace="5" border="0" align="left" /></a><br>
                          <br>
                          Selected Product <a href="product.aspx?style_no=<%=Session["cart_style"]%>"><%=Session["productName"]%><br>
                            <strong>Style   #<%=Session["cart_style"]%></strong></a></strong></td>
                          </tr>
                    </table></td>
              </tr>
          
        </table>
        </td></tr>
        <tr>
                <td colspan="3">
                    <uc3:bottom ID="Bottom1" runat="server" />
                </td>
            </tr>
        
        
        </table>
       
    </div>
    </form>
</body>
</html>