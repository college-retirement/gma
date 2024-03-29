angular.module('gmaApp.filters').filter('marital', function(){
	return function(input, length) {
		if (input != undefined) {
			switch (input) {
				case '0':
				case 0:
					return 'Never Married';
				break;

				case 1:
				case '1':
					return 'Separated';
				break;

				case 2:
				case '2':
					return 'Widowed';
				break;

				case 3:
				case '3':
					return "Divorced";
				break;

				case 4:
				case '4':
					return 'Remarried';
				break;

				case 5:
				case '5':
					return 'Married';
				break;
			}
		}
	};
});