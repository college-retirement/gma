angular.module('gmaApp.filters').filter('ssn', function(){
	return function(input, length) {
		if (input != undefined) {
			var ssn = input;
			return ssn.substr(0, 3) + '-' + ssn.substr(3, 2) + '-' + ssn.substr(5);
		}
	};
});