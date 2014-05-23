angular.module('gmaApp.filters').filter('gender', function(){
	return function(input, length) {
		var gender = input;
		return (gender == 'M') ? 'Male' : 'Female'
	};
});