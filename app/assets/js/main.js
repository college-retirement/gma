angular.module('gmaApp', ['gmaApp.filters', 'ngRoute',  'ngAnimate', 'ui.utils', 'ui.bootstrap', 'persona', 'colleges']);
angular.module('gmaApp.filters', []);

angular.module('gmaApp').config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider){
	$routeProvider.when('/', {
		templateUrl: "assets/views/home.html",
		controller: "MainCtrl"
	}).when('/profile', {
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl",
		resolve: {
			isDraft: function() {
				return true;
			},
			moreInfo: function() {
				return false;
			},
			profile: function() {
				return false;
			}
		}
	}).when('/moreinfo/:profileid', {
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl",
		resolve: {
			isDraft: function() {
				return false;
			},
			moreInfo: function() {
				return true;
			},
			profile: ['$route', '$http', function($route, $http) {
				return $http.get('/profiles/' + $route.current.params.profileid).then(function(obj){
					return obj.data.result;
				});
			}]
		}
	}).when('/register', {
		templateUrl: "assets/views/register.html",
		controller: "RegisterCtrl"
	}).when('/forgot', {
		templateUrl: "assets/views/forgot.html",
		controller: "ForgotPasswordCtrl"
	}).when('/reset/:token', {
		templateUrl: "assets/views/reset.html",
		controller: "ResetCtrl"
	}).when('/drafts/:draft',{
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl",
		resolve: {
			isDraft: function() {
				return true;
			},
			moreInfo: function() {
				return false;
			},
			profile: ['$route', '$http', function($route, $http){
				return $http.get('/drafts/' + $route.current.params.draft).then(function(obj){
					return obj.data;
				});
			}]
		}
	}).when('/admin', {
		templateUrl: "assets/views/admin/home.html",
		controller: "AdminCtrl"
	}).when('/admin/list', {
		templateUrl: "assets/views/admin/profiles/list.html",
		controller: "AdminListCtrl"
	}).when('/admin/search', {
		templateUrl: "assets/views/admin/profiles/search.html",
		controller: "AdminSearchCtrl"
		
	}).when('/admin/profiles/:profile', {
		templateUrl: "assets/views/admin/profiles/view.html",
		controller: "AdminViewCtrl",
		reloadOnSearch: false
	}).when('/admin/drafts/:profile', {
		templateUrl: "assets/views/admin/drafts/view.html",
		controller: "AdminDraftViewCtrl"
	}).when('/admin/drafts', {
		templateUrl: "assets/views/admin/drafts/list.html",
		controller: "AdminDraftListCtrl",
		reloadOnSearch: false
	}).when('/admin/users', {
		templateUrl: "assets/views/admin/users/list.html",
		controller: "AdminUserListCtrl"
	}).when('/admin/users/:user', {
		templateUrl: "assets/views/admin/users/view.html",
		controller: "AdminUserViewCtrl"
	}).when('/admin/logs', {
		templateUrl: "assets/views/admin/users/logs.html",
		controller: "AdminUserLogCtrl"
	}).when('/admin/templates', {
		templateUrl: "assets/views/admin/template/list.html",
		controller: "AdminTemplateListCtrl"
	}).when('/admin/templates/:template', {
		templateUrl: "assets/views/admin/template/view.html",
		controller: "AdminTemplateViewCtrl"
	}).otherwise('/');
	
	$httpProvider.interceptors.push('UnauthorizedXHRInterceptor');
}]);


angular.module('gmaApp').factory('UnauthorizedXHRInterceptor', function($location, $q){
	return {
		'responseError': function(o) {

			if (o.url !== '/persona/status'  && o.status == 401) {
				
				$q.reject(o);
				$location.path('/');
			}
			return $q.reject(o);
		}
	};
});

angular.module('gmaApp').controller('AppCtrl', function($rootScope, $scope, Persona){

});

angular.module('gmaApp').controller("MainCtrl", function($rootScope, $scope, Persona, $timeout, $http){
	Persona.status();

	$scope.drafts = [];

	$scope.login = function() {
		$scope.$emit('loginClick');
	};

	$scope.getUser = function() {
		return Persona.getUser();
	};

	$scope.getDrafts = function() {
		$http.get('/drafts').then(function(obj){
			$scope.drafts = obj.data.drafts;
		});
	};

	if ($scope.getUser() !== false) {
		$scope.getDrafts();
	}


	$scope.$watch("getUser()", function(o){
		if (o !== false) {
			$scope.getDrafts();
		}
	});


	$scope.draftDelete = function(draft) {
		$http.delete('/drafts/' + draft._id).then(function(obj){
			toastr.success("Draft deleted successfully.");
			$http.get('/drafts').then(function(obj){
				$scope.drafts = obj.data.drafts;
			});
		});
	};
});






angular.module('gmaApp').controller('ModalInstanceCtrl', ['$scope', '$modalInstance', 'items','$location','Persona', function ($scope, $modalInstance, items,$location,Persona) {
  $scope.items = items;
  $scope.login = {};

  $scope.done = false;
    $scope.selected = {
        item: $scope.items[0]
    };
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

  $scope.submit = function () {
  	    var errors = false;

		jQuery('.has-error').removeClass('has-error');
		
		jQuery(".ng-invalid").each(function(e){
			errors = true;
			jQuery(this).parent('.control').parent('.form-group').addClass('has-error');
		});
		
		jQuery(".btn.ng-invalid").each(function(e){
			errors = true;
			jQuery(this).parent('.btn-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery('.input-group>.ng-invalid').each(function(e){
			errors = true;
			jQuery(this).parent('.input-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery(".ng-invalid:not(form)").first().focus();
		$scope.submitted = true;
		
		
		if (!errors) {
			
			var promise = Persona.verify($scope.login);
			promise.then(function(greeting) {
				$modalInstance.close();
				console.log(Persona.getUser().is_admin);
				if(Persona.getUser().is_admin == true){
					$location.path('/admin/list');
				}
				else{
					$location.path('/');
				}
    			
		    
		  }, function(reason) {
		  	toastr.error("email or password are not correct");
		    
		  }
			
		)};
    };

}]);

angular.module('gmaApp').controller('ModalDemoCtrl', ['$rootScope','$scope', '$modal', '$log', 
 function ($rootScope,$scope, $modal, $log) {
 	$scope.items = ['item1', 'item2', 'item3'];
 	
  $scope.open = function (size) {
  	
    var modalInstance = $modal.open({
      templateUrl: 'myModalContent.html',
      controller: 'ModalInstanceCtrl',
      size: 'sm',
      resolve: {
            items: function () {
            return $scope.items;
            }
        }
    });

    modalInstance.result.then(function (selectedItem) {
      $scope.selected = selectedItem;
    }, function () {
      
    });
  };
  
   
  $rootScope.$on('loginClick', function(){
		$scope.open('sm');
	});
 }]);



angular.module('gmaApp').controller("PersonaCtrl", function($rootScope, $scope, Persona){
	
	$scope.login = function() {
		$scope.$emit('loginClick');
	};

	$scope.logout = function() {
		Persona.logout();
	};

	$scope.status = function() {
		Persona.status();
	};

	$scope.getUser = function() {
		return Persona.getUser();
	};
	


});