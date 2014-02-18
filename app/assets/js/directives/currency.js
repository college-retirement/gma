angular.module('gmaApp').directive('currency', function() {
	return {
		restrict: 'A',
		require: 'ngModel',
		scope: {
			ngModel: '=',
			ngDisabled: '=',
			ngRequired: '='
		},
		template: '<div class="input-prepend input-append input-group"><span class="input-group-addon">$</span><input type="text" ng-model="ngModel" ng-disabled="ngDisabled" ng-required="ngRequired" class="form-control currency" required><span class="input-group-addon">.00</span></div>',
		link: function(scope, element, attrs) {
			jQuery(element).keypress(function(e){
				var a = [];
				var k = e.which;
    
				for (i = 48; i < 58; i++) {
					a.push(i);
				}
    
				if (!(a.indexOf(k)>=0)) {
					e.preventDefault();
				}
			});
		}

	};
});