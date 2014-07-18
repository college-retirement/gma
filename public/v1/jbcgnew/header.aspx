<SCRIPT LANGUAGE="JavaScript">
  <!-- 

  Rollimage = new Array();

  Rollimage[0]= new Image(106,25);
  Rollimage[0].src = "<%= Session["imagedir"] %>\\home.gif";

  Rollimage[1] = new Image(106,25);
  Rollimage[1].src = "<%= Session["imagedir"] %>\\home_sel.gif";

  Rollimage[2]= new Image(106,25);
  Rollimage[2].src = "<%= Session["imagedir"] %>\\new_leads.gif";

  Rollimage[3] = new Image(106,25);
  Rollimage[3].src = "<%= Session["imagedir"] %>\\new_leads_sel.gif"; 

  Rollimage[4]= new Image(106,25);
  Rollimage[4].src = "<%= Session["imagedir"] %>\\view_cases.gif";

  Rollimage[5] = new Image(106,25);
  Rollimage[5].src = "<%= Session["imagedir"] %>\\view_cases_sel.gif"; 

  var newwindow = '';
  function popitup(url, w, h) {
    if (newwindow.location && !newwindow.closed) {
      newwindow.location.href = url; 
      newwindow.focus(); 
    }else {
      day = new Date();
      id = day.getTime();
      var configstr = 'toolbar=0,scrollbars=1,location=1,statusbar=0,menubar=0,resizable=1,width=' + w + ',height=' + h + ',left = 0,top = 0';
      newwindow = window.open(url, id, configstr);
    }
  }
  
//--> 
</SCRIPT>
<table border="0" cellpadding="0" cellspacing="0" width="772" align="center">
<tr>
	<td colspan="5" height="20">&nbsp;</td>
</tr>
<tr>
  	<td colspan="5" align="center" width="100%"><img src="<%= Session["imagedir"] %>header.gif" border="0"></td>
</tr>
<tr valign="bottom">
  	<td width="1">
		<% //Response.Write(Page.Page); %>
		<img src="<%= Session["imagedir"] %>grey_bar.gif">
	</td>
  	<td width="25"></td>
  	<td align="left" width="600">
    		<% if(Page.Page.ToString().IndexOf("home") != -1) { %>
    			<a href="./home.aspx"  onmouseover="document.home.src = Rollimage[1].src;" onmouseout="document.home.src = Rollimage[1].src;">
    			<img name="home" src="<%= Session["imagedir"] %>home_sel.gif" border="0"></a>
		<% }else{ %>
    			<a href="./home.aspx"  onmouseover="document.home.src = Rollimage[1].src;" onmouseout="document.home.src = Rollimage[0].src;">
    			<img name="home" src="<%= Session["imagedir"] %>home.gif" border="0"></a>
		<% } %>
    		<% if(Page.Page.ToString().IndexOf("new_leads") != -1) { %>
		    <a href="./new_leads.aspx" onmouseover="document.new_leads.src = Rollimage[3].src;" onmouseout="document.new_leads.src = Rollimage[3].src;">
		    <img name="new_leads" src="<%= Session["imagedir"] %>new_leads_sel.gif" border="0"></a>
		<% }else{ %>
		    <a href="./new_leads.aspx" onmouseover="document.new_leads.src = Rollimage[3].src;" onmouseout="document.new_leads.src = Rollimage[2].src;">
		    <img name="new_leads" src="<%= Session["imagedir"] %>new_leads.gif" border="0"></a>
		<% } %>
    <a href="./default.aspx" onmouseover="document.view_cases.src = Rollimage[5].src;" onmouseout="document.view_cases.src = Rollimage[4].src;">
    <img name="view_cases" src="<%= Session["imagedir"] %>view_cases.gif" border="0"></a>
  </td>
  <td width="145"></td>
  <td width="1" align="left"><img src="<%= Session["imagedir"] %>grey_bar.gif"></td> 
</tr>
</table>