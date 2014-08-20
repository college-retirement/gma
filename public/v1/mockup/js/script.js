/*------------------- 
File Name : "script.js"
--------------------*/

$(document).ready(function() {
	$('.toggle-btn').click(function(){
	  $(".nav-wrap .nav").slideToggle('slow');
	});

	
	//==================== Placeholder's code ====================	
    $('input, textarea').addClass('magic-placeholder').parent().addClass('place-holder-wrap');;

    // add span on document load
	$('.magic-placeholder').each(function(){
		var $this = $(this),
			inputPlaceholder = $this.data('placeholder');

		$('.magic-placeholder').attr('placeholder', '');
		$this.attr('autocomplete','off');
		if (typeof inputPlaceholder == 'undefined') {
	     	inputPlaceholder = '';
	    };
	    $('<span class="magic-placeholder-text">' + inputPlaceholder + '</span>').insertAfter($this);
	    if($this.val().length > 0){
			$this.siblings('.magic-placeholder-text').hide();
		}

	});
	
	// click on span
	$('.magic-placeholder-text').on('click', function(){
		var $this = $(this),
			selectedInput = $this.siblings('.magic-placeholder');
		if(!selectedInput.is(':disabled')) {
			selectedInput.focus();
			$this.hide();
		}
	});
	
	// focus on input
	$('.magic-placeholder').on('focus', function(){
		$(this).siblings('.magic-placeholder-text').hide();
	});
	
	// blur from input
	$('.magic-placeholder').on('blur', function(){
		if($(this).val().length < 1){
			$(this).siblings('.magic-placeholder-text').show();
		}
	});

	//---- 
	$('#more-link').on('click', function(){
		$('.record-wrapper').slideToggle();
		$('#scrollLinks').css('visibility', 'visible');
	});
	// if ($(window).width() <= 780) {
	// 		$('.record-wrapper').addClass('hide');
	// 	}
	
	//==================== Ends of placeholder's code ====================


}); // jQuery End