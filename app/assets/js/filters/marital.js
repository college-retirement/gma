angular.module('gmaApp.filters').filter('marital', function(){
	return function(input, length) {
		if (input != undefined) {
			switch (input) {
				case 0:
					return 'Never Married';
				break;

				case 1:
					return 'Separated';
				break;

				case 2:
					return 'Widowed';
				break;

				case 3:
					return "Divorced";
				break;

				case 4:
					return 'Remarried';
				break;

				case 5:
					return 'Married';
				break;
			}
		}
	};
});