<%@ Page Language="C#" AutoEventWireup="true" CodeFile="orderfinal.aspx.cs" Inherits="orderfinal" %>

<%@ Register Assembly="nsoftware.IPWorksWeb" Namespace="nsoftware.IPWorks" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="user_header.ascx" TagName="user_header" TagPrefix="uc1" %>
<%@ Register Src="leftside.ascx" TagName="leftside" TagPrefix="uc2" %>
<%@ Register Src="bottom.ascx" TagName="bottom" TagPrefix="uc3" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
   <title>Waldor</title>

    
</head>
<body>
        <form id="form1" runat="server">
    <div>
        <table cellspacing="0" cellpadding="0" style="z-index: 100; left: 0px; position: absolute; top: 0px;margin-left:0px;margin-top:0px; width:100%">
      <tr style=" height:100px; width:100%">
                <td colspan="3" style="height: 128px">
        <uc1:user_header ID="User_header1" runat="server" /></td>        
        </tr>
             <tr valign="middle" align="left" style="margin-left:0px;margin-top:0px;left: 0px;z-index: 100;">
            <td valign="top" align="left" style="width: 14%; height: 198px;margin-left:0px;margin-top:0px; border-right: #3eafbf thin solid;background-color:#9FCED4">
      <uc2:leftside ID="Leftside1" runat="server" /></td>
      <td width="2" valign="top" bgcolor="00AACB"><img src="WalImages/spacer.gif" width="2" height="1"></td>
      <td valign="top" bgcolor="#FFFFFF" class="WhiteSpace">
    
    <table width="100%" border="0" cellspacing="0" cellpadding="3">
            <tr>
              <td><span class="title">Thank You for Your Order </span></td>
              </tr>
            <tr>
              <td>&nbsp;<asp:Label ID="ErrorLbl" runat="server" ForeColor="#C00000"></asp:Label></td>
              </tr>
			 <tr>
              <td><a href="Default.aspx">Click here to return to our home page.</a><br />
                  <asp:Label ID="Label1" runat="server" Style="position: relative" Width="640px"></asp:Label></td>
              </tr>
              </table>
          <cc1:Htmlmailer ID="htmlmailer1" runat="server">
          </cc1:Htmlmailer>
    
    </td>
      </tr>
    
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