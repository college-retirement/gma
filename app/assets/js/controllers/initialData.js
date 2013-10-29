angular.module('gmaApp.controllers', []);
angular.module('gmaApp.controllers').controller("InitialDataController", function($rootScope, $scope, states, $http, Persona){
	Persona.status();
	$scope.getUser = function() {
		return Persona.getUser();
	};

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
		email: null,
		dependents: 0,
		livingArrangement: null,
		income: {
			earnedIncome: 0,
			unearnedIncome: 0,
			taxPaid: 0,
			agi: 0,
			itemizedDeductions: 0,
			ssBenefits: 0,
			iraContribution: 0
		},
		schools: [],
		family: {
			monthlyHouseholdExpense: 0,
			contributionAbility: 0,
			members: [],
			realEstate: [],
			assets: [],
			liabilities: [],
			retirement: [],
			home: {
				price: 0,
				value: 0,
				propertyTax: 0
			}
		},
		guardian: {
			income: {
				current: 0,
				anticipated: 0,
				retirement: 0,
				ssBenefits: 0
			}
		},
		parents: {
			income: {
				father: {
					current: 0,
					anticipated: 0,
					retirement: 0,
					ssBenefits: 0
				},
				mother: {
					current: 0,
					anticipated: 0,
					retirement: 0,
					ssBenefits: 0
				},
				combined: {
					other: 0,
					untaxed: 0,
					childSupport: {
						received: 0,
						paid: 0
					},
					housing: 0,
					medical: 0,
					deductions: 0,
					taxPaid: 0,
					agi: 0
				}
			}
		}
	};


	$scope.addSchool = function() {
		$scope.student.schools.push($scope.currentSchool);
		$scope.currentSchool = null;
	};

	$scope.deleteSchool = function(index) {
		$scope.student.schools.splice(index, 1);
	}

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
		$http.post('/drafts', $scope.student).success(function(){
			toastr.success("Draft saved successfully!");
		}).error(function(){
			toastr.warning("There were issues saving your draft.");
		});
	};

	$scope.addFamily = function() {
		$scope.student.family.members.push({student: false});
	};

	$scope.deleteFamily = function(index) {
		$scope.student.family.members.splice(index, 1);
	}

	$scope.addProperty = function() {
		$scope.student.family.realEstate.push({});
	};

	$scope.deleteProperty = function(index) {
		$scope.student.family.realEstate.splice(index, 1);
	}

	$scope.addAsset = function() {
		$scope.student.family.assets.push({});
	};

	$scope.deleteAsset = function(index) {
		$scope.student.family.assets.splice(index, 1);
	}

	$scope.addLiability = function() {
		$scope.student.family.liabilities.push({});
	};

	$scope.deleteLiability = function(index) {
		$scope.student.family.liabilities.splice(index, 1);
	};

	$scope.addRetirement = function() {
		$scope.student.family.retirement.push({});
	};

	$scope.deleteRetirement = function(index) {
		$scope.student.family.retirement.splice(index, 1);
	};

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
			$http.post('/profiles', $scope.student).success(function(){
				$scope.finished = true;
			}).error(function(){
				toastr.error("Unable to submit profile.");
			})
		}
	};
});