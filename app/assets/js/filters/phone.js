angular.module('gmaApp.filters').filter('phone', function(){
	return function(input, length) {
		if (input != undefined) {
			var phone = input;
			return '(' + phone.substr(0,3) + ') ' + phone.substr(3, 3) + '-' + phone.substr(6);
		}
	};
});