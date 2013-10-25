angular.module('gmaApp').controller('DraftCtrl', function($scope, $http, Persona, $location, states, $route){
	Persona.status();


	$scope.states = states;
	$scope.currentSchool = null;
	$scope.collegeList = {};
	$scope.collegesLoading = false;
	
	$scope.$watch('currentSchool', function(){
		if ($scope.currentSchool != "" && typeof $scope.currentSchool !== "object") {
			
			$scope.collegesLoading = true;

			$http.post('/colleges.json', {name: $scope.currentSchool}).then(function(obj){
				$scope.collegeList = obj.data;
				$scope.collegesLoading = false;
			});
		}
	});

	
	$scope.ownershipTypes = [
		'Personally',
		'Jointly',
		'LLC',
		'S-Corp',
		'Partnership',
		'C-Corp',
		'Other'
	];

	$scope.liabilityTypes = [
		'Car Loan',
		'Credit Card',
		'First Mortgage',
		'Home Equity Line Of Credit',
		'Life Insurance Premium',
		'Other',
		'Second Mortgage'
	];

	$scope.assetTypes = [
		'Annuities (Non Qualified - Not Retirement)',
		'Bonds (including Tax - Exempt)',
		'Business Assets',
		'Cash, Savings',
		'Certificates of Deposit',
		'Checking',
		'Money Market Funds',
		'Mutual Funds',
		'Other Assets',
		'Pre-Paid Tuition Accounts (529 Plans)',
		'Sibling Assets Held By Parents',
		'Stocks',
		'Treasury Bills'
	];

	$scope.retirementTypes = [
		'401(k)',
		'403(b)',
		'IRA',
		'Keogh/SEP/Simple',
		'Pension Fund',
		'Qualified Annuities',
		'Rollover'
	];
	
	$scope.student = {
		email: Persona.getUser().email,
		schools: [],
		family: {
			members: [],
			realEstate: [],
			assets: [],
			liabilities: [],
			retirement: []
		}
	};

	console.log($route);

	$http.get('/drafts/' + $route.current.params.draft).then(function(obj){
		$scope.student = obj.data;
		$scope.continue = true;
		$scope.draftLoaded = true;
	});


	$scope.addSchool = function() {
		$scope.student.schools.push($scope.currentSchool);
		$scope.currentSchool = null;
	};

	$scope.updateSchool = function(school, index) {
		$scope.currentSchool = school;
		// $scope.currentSchool.profile = true;
		// $scope.currentSchool.ncProfile = false;
		// $scope.currentSchool.idoc = true;
	};

	$scope.updateOrCreateAccount = function() {
		var User = {
			email: Persona.getUser().email || $scope.student.email,
			name: {
				first: $scope.student.name.first,
				middle: $scope.student.name.middle,
				last: $scope.student.name.last
			},
			gender: $scope.student.gender,
			phone: $scope.student.phone
		};
		$http.put('/account', User).then(function(){

		});
	};
	$scope.saveDraft = function() {
		$http.put('/drafts', $scope.student);
	};

	$scope.addFamily = function() {
		$scope.student.family.members.push({student: false});
	};

	$scope.addProperty = function() {
		$scope.student.family.realEstate.push({});
	};

	$scope.addAsset = function() {
		$scope.student.family.assets.push({});
	};

	$scope.addLiability = function() {
		$scope.student.family.liabilities.push({});
	};

	$scope.addRetirement = function() {
		$scope.student.family.retirement.push({});
	}

	$scope.submitProfile = function() {
		jQuery('.has-error').removeClass('has-error');
		
		jQuery(".ng-invalid").each(function(e){
			jQuery(this).parent('.control').parent('.form-group').addClass('has-error');
		});
		
		jQuery(".btn.ng-invalid").each(function(e){
			jQuery(this).parent('.btn-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery('.input-group>.ng-invalid').each(function(e){
			jQuery(this).parent('.input-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery(".ng-invalid:not(form)").first().focus();
		$scope.submit = true;

		if (!jQuery('form').hasClass('.ng-invalid')) {
			$http.post('/profiles', $scope.student);
		}
	};
});