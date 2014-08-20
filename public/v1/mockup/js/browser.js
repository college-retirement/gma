/*------------------- 
File Name : "browser.js"
--------------------*/

$(document).ready(function(){
	checkBrowser();
});

function checkBrowser(){
	var val = navigator.userAgent.toLowerCase();
		if(val.indexOf("firefox") > -1){
			$('body').addClass('firefox');
		}
		else if(val.indexOf("opera") > -1){
			$('body').addClass('opera');
		}
		else if(val.indexOf("msie") > -1){
			$('body').addClass('ie');		
			// get ie version
			version = parseFloat(navigator.appVersion.split("MSIE")[1]);
			$('body').addClass('ie'+version);
		}	
		else if(val.match('chrome') != null){
			$('body').addClass('chrome');
		}
		else if(val.indexOf("safari") > -1){
			$('body').addClass('safari');
		}	
}
