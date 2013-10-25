angular.module('gmaApp.filters').filter('phone', function(){
	return function(input, length) {
		var phone = input;
		return '(' + phone.substr(0,3) + ') ' + phone.substr(3, 3) + '-' + phone.substr(6);
	};
});