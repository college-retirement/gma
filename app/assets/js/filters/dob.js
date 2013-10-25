angular.module('gmaApp.filters').filter('dob', function(){
	return function(input, length) {
		var dob = input;
		return dob.substr(0, 2) + '/' + dob.substr(2, 2) + '/' + dob.substr(4);
	};
});