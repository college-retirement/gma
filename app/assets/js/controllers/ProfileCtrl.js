angular.module('gmaApp').controller('ProfileCtrl', function($scope, $http, $route, $location, Persona, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes, moreInfo, profile, isDraft){
	// Persona
	Persona.status();
	$scope.getUser = function() {
		return Persona.getUser();
	};

	$scope.moreInfo = moreInfo;

	if ($route.current.params.hasOwnProperty('draft')) {
		$http.get('/drafts/' + $route.current.params.draft).then(function(obj){
			$scope.student = obj.data;
			$scope.continue = true;
			$scope.draftLoaded = true;
		});
	}


	// States for state selection
	$scope.states = states;

	// Typeahead college name stuff
	$scope.currentSchool = null;
	$scope.currentSibSchool = null;
	$scope.collegeList = {};
	$scope.collegesLoading = false;

	// Defined types
	$scope.ownershipTypes = OwnershipTypes;
	$scope.liabilityTypes = LiabilityTypes;
	$scope.assetTypes = AssetTypes;
	$scope.retirementTypes = RetirementTypes;

	$scope.stronghold = {};

	if (profile == false) {
		$scope.makeNew = true;
		$scope.student = {
			prospect: true,
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
			siblings: {
				schools: []
			},
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
			},
			school: {
				current: false,
				name: null,
				grade: null,
				parentContribution: 0
			}
		};
	}
	else if (isDraft) {
		$scope.student = profile;
		$scope.makeNew = true;
	}
	else {
		$scope.student = profile;
		$scope.student.status = "Additional Information Received";
		$scope.makeNew = false;
	}

	$scope.$watch('currentSchool', function(){
		if ($scope.currentSchool != "" && typeof $scope.currentSchool !== "object") {
			
			$scope.collegesLoading = true;

			$http.post('/colleges.json', {name: $scope.currentSchool}).then(function(obj){
				$scope.collegeList = obj.data;
				$scope.collegesLoading = false;
			});
		}
	});

	$scope.$watch('currentSibSchool', function(){
		if ($scope.currentSibSchool != "" && typeof $scope.currentSibSchool !== "object") {
			
			$scope.collegesLoading = true;

			$http.post('/colleges.json', {name: $scope.currentSibSchool}).then(function(obj){
				$scope.collegeSibList = obj.data;
				$scope.collegesLoading = false;
			});
		}
	});

	$scope.addSchool = function(siblings) {
		if (siblings === true) {
			$scope.student.siblings.schools.push($scope.currentSibSchool);
			$scope.currentSibSchool = null;
		}
		else {
			$scope.student.schools.push($scope.currentSchool);
			$scope.currentSchool = null;
		}

	};

	$scope.updateSchool = function(school, index, siblings) {
		if (siblings === true) {
			$scope.currentSibSchool = school;
		}
		else {
			$scope.currentSchool = school;
		}
	};
	
	$scope.deleteSchool = function(index, siblings) {
		if (siblings) {
			$scope.student.siblings.schools.splice(index, 1);
		}
		else {
			$scope.student.schools.splice(index, 1);
		}
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
		$scope.submit = true;

		if (!errors) {
			if ($scope.makeNew) {
				$http.post('/profiles', $scope.student).success(function(){
					$scope.finished = true;
				}).error(function(){
					toastr.error("Unable to submit profile.");
				});
			}
			else {
				$http.put('/profiles/' + $scope.student._id, $scope.student).success(function(){
					$scope.finished = true;
				}).error(function(){
					toastr.error("Unable to submit profile.");
				});
			}
		}
	};

	$scope.saveDraft = function() {
		$http.post('/drafts', $scope.student).success(function(data){
			toastr.success("Draft saved successfully!");
			$scope.student = data;
		}).error(function(){
			toastr.warning("There were issues saving your draft.");
		});
	};


});