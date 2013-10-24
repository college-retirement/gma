angular.module('gmaApp', [
  'gmaApp.filters',
  'gmaApp.controllers',
  'ngRoute',
  'ngAnimate',
  'ui.utils',
  'ui.bootstrap',
  'persona'
]).config([
  '$routeProvider',
  function ($routeProvider) {
    $routeProvider.when('/', {
      templateUrl: 'assets/views/home.html',
      controller: 'MainCtrl'
    }).when('/initial', {
      templateUrl: 'assets/views/initialData.html',
      controller: 'InitialDataController'
    }).when('/drafts/:draft', {
      templateUrl: 'assets/views/initialData.html',
      controller: 'DraftCtrl'
    }).otherwise('/');
  }
]);
angular.module('gmaApp').controller('AppCtrl', [
  '$rootScope',
  '$scope',
  'Persona',
  function ($rootScope, $scope, Persona) {
  }
]);
angular.module('gmaApp').controller('MainCtrl', [
  '$rootScope',
  '$scope',
  'Persona',
  '$timeout',
  '$http',
  function ($rootScope, $scope, Persona, $timeout, $http) {
    Persona.status();
    $scope.drafts = [];
    $scope.login = function () {
      $scope.$emit('loginClick');
    };
    $scope.getUser = function () {
      return Persona.getUser();
    };
    $http.get('/drafts').then(function (obj) {
      $scope.drafts = obj.data.drafts;
    });
  }
]);
angular.module('gmaApp').controller('PersonaCtrl', [
  '$rootScope',
  '$scope',
  'Persona',
  function ($rootScope, $scope, Persona) {
    $scope.login = function () {
      Persona.verify();
    };
    $scope.logout = function () {
      Persona.logout();
    };
    $scope.status = function () {
      Persona.status();
    };
    $scope.dumpStatus = function () {
      console.log($scope.status());
    };
    $scope.getUser = function () {
      return Persona.getUser();
    };
    $rootScope.$on('loginClick', function () {
      $scope.login();
    });
  }
]);
angular.module('gmaApp').controller('ExtendedProfileController', [
  '$rootScope',
  '$scope',
  function ($rootScope, $scope) {
  }
]);angular.module('gmaApp').controller('DraftCtrl', [
  '$scope',
  '$http',
  'Persona',
  '$location',
  'states',
  '$route',
  function ($scope, $http, Persona, $location, states, $route) {
    Persona.status();
    $scope.states = states;
    $scope.currentSchool = null;
    $scope.collegeList = {};
    $scope.collegesLoading = false;
    $scope.$watch('currentSchool', function () {
      if ($scope.currentSchool != '' && typeof $scope.currentSchool !== 'object') {
        $scope.collegesLoading = true;
        $http.post('/colleges.json', { name: $scope.currentSchool }).then(function (obj) {
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
    $http.get('/drafts/' + $route.current.params.draft).then(function (obj) {
      $scope.student = obj.data;
      $scope.continue = true;
      $scope.draftLoaded = true;
    });
    $scope.addSchool = function () {
      $scope.student.schools.push($scope.currentSchool);
      $scope.currentSchool = null;
    };
    $scope.updateSchool = function (school, index) {
      $scope.currentSchool = school;
    };
    $scope.updateOrCreateAccount = function () {
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
      $http.put('/account', User).then(function () {
      });
    };
    $scope.saveDraft = function () {
      $http.put('/drafts', $scope.student);
    };
    $scope.addFamily = function () {
      $scope.student.family.members.push({ student: false });
    };
    $scope.addProperty = function () {
      $scope.student.family.realEstate.push({});
    };
    $scope.addAsset = function () {
      $scope.student.family.assets.push({});
    };
    $scope.addLiability = function () {
      $scope.student.family.liabilities.push({});
    };
    $scope.addRetirement = function () {
      $scope.student.family.retirement.push({});
    };
  }
]);angular.module('gmaApp.controllers', []);
angular.module('gmaApp.controllers').controller('InitialDataController', [
  '$rootScope',
  '$scope',
  'states',
  '$http',
  'Persona',
  function ($rootScope, $scope, states, $http, Persona) {
    Persona.status();
    $scope.getUser = function () {
      return Persona.getUser();
    };
    $scope.states = states;
    $scope.currentSchool = null;
    $scope.collegeList = {};
    $scope.collegesLoading = false;
    $scope.$watch('currentSchool', function () {
      if ($scope.currentSchool != '' && typeof $scope.currentSchool !== 'object') {
        $scope.collegesLoading = true;
        $http.post('/colleges.json', { name: $scope.currentSchool }).then(function (obj) {
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
      email: $scope.getUser().email,
      schools: [],
      family: {
        members: [],
        realEstate: [],
        assets: [],
        liabilities: [],
        retirement: []
      }
    };
    $scope.addSchool = function () {
      $scope.student.schools.push($scope.currentSchool);
      $scope.currentSchool = null;
    };
    $scope.updateSchool = function (school, index) {
      $scope.currentSchool = school;
    };
    $scope.updateOrCreateAccount = function () {
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
      $http.put('/account', User).then(function () {
      });
    };
    $scope.saveDraft = function () {
      $http.post('/drafts', $scope.student);
    };
    $scope.addFamily = function () {
      $scope.student.family.members.push({ student: false });
    };
    $scope.addProperty = function () {
      $scope.student.family.realEstate.push({});
    };
    $scope.addAsset = function () {
      $scope.student.family.assets.push({});
    };
    $scope.addLiability = function () {
      $scope.student.family.liabilities.push({});
    };
    $scope.addRetirement = function () {
      $scope.student.family.retirement.push({});
    };
  }
]);angular.module('gmaApp.filters', []).filter('fullState', function () {
  return function (input, length) {
    var usStates = [
        {
          name: 'Alabama',
          abbreviation: 'AL'
        },
        {
          name: 'Alaska',
          abbreviation: 'AK'
        },
        {
          name: 'American Samoa',
          abbreviation: 'AS'
        },
        {
          name: 'Arizona',
          abbreviation: 'AZ'
        },
        {
          name: 'Arkansas',
          abbreviation: 'AR'
        },
        {
          name: 'California',
          abbreviation: 'CA'
        },
        {
          name: 'Colorado',
          abbreviation: 'CO'
        },
        {
          name: 'Connecticut',
          abbreviation: 'CT'
        },
        {
          name: 'Delaware',
          abbreviation: 'DE'
        },
        {
          name: 'District Of Columbia',
          abbreviation: 'DC'
        },
        {
          name: 'Federated States Of Micronesia',
          abbreviation: 'FM'
        },
        {
          name: 'Florida',
          abbreviation: 'FL'
        },
        {
          name: 'Georgia',
          abbreviation: 'GA'
        },
        {
          name: 'Guam',
          abbreviation: 'GU'
        },
        {
          name: 'Hawaii',
          abbreviation: 'HI'
        },
        {
          name: 'Idaho',
          abbreviation: 'ID'
        },
        {
          name: 'Illinois',
          abbreviation: 'IL'
        },
        {
          name: 'Indiana',
          abbreviation: 'IN'
        },
        {
          name: 'Iowa',
          abbreviation: 'IA'
        },
        {
          name: 'Kansas',
          abbreviation: 'KS'
        },
        {
          name: 'Kentucky',
          abbreviation: 'KY'
        },
        {
          name: 'Louisiana',
          abbreviation: 'LA'
        },
        {
          name: 'Maine',
          abbreviation: 'ME'
        },
        {
          name: 'Marshall Islands',
          abbreviation: 'MH'
        },
        {
          name: 'Maryland',
          abbreviation: 'MD'
        },
        {
          name: 'Massachusetts',
          abbreviation: 'MA'
        },
        {
          name: 'Michigan',
          abbreviation: 'MI'
        },
        {
          name: 'Minnesota',
          abbreviation: 'MN'
        },
        {
          name: 'Mississippi',
          abbreviation: 'MS'
        },
        {
          name: 'Missouri',
          abbreviation: 'MO'
        },
        {
          name: 'Montana',
          abbreviation: 'MT'
        },
        {
          name: 'Nebraska',
          abbreviation: 'NE'
        },
        {
          name: 'Nevada',
          abbreviation: 'NV'
        },
        {
          name: 'New Hampshire',
          abbreviation: 'NH'
        },
        {
          name: 'New Jersey',
          abbreviation: 'NJ'
        },
        {
          name: 'New Mexico',
          abbreviation: 'NM'
        },
        {
          name: 'New York',
          abbreviation: 'NY'
        },
        {
          name: 'North Carolina',
          abbreviation: 'NC'
        },
        {
          name: 'North Dakota',
          abbreviation: 'ND'
        },
        {
          name: 'Northern Mariana Islands',
          abbreviation: 'MP'
        },
        {
          name: 'Ohio',
          abbreviation: 'OH'
        },
        {
          name: 'Oklahoma',
          abbreviation: 'OK'
        },
        {
          name: 'Oregon',
          abbreviation: 'OR'
        },
        {
          name: 'Palau',
          abbreviation: 'PW'
        },
        {
          name: 'Pennsylvania',
          abbreviation: 'PA'
        },
        {
          name: 'Puerto Rico',
          abbreviation: 'PR'
        },
        {
          name: 'Rhode Island',
          abbreviation: 'RI'
        },
        {
          name: 'South Carolina',
          abbreviation: 'SC'
        },
        {
          name: 'South Dakota',
          abbreviation: 'SD'
        },
        {
          name: 'Tennessee',
          abbreviation: 'TN'
        },
        {
          name: 'Texas',
          abbreviation: 'TX'
        },
        {
          name: 'Utah',
          abbreviation: 'UT'
        },
        {
          name: 'Vermont',
          abbreviation: 'VT'
        },
        {
          name: 'Virgin Islands',
          abbreviation: 'VI'
        },
        {
          name: 'Virginia',
          abbreviation: 'VA'
        },
        {
          name: 'Washington',
          abbreviation: 'WA'
        },
        {
          name: 'West Virginia',
          abbreviation: 'WV'
        },
        {
          name: 'Wisconsin',
          abbreviation: 'WI'
        },
        {
          name: 'Wyoming',
          abbreviation: 'WY'
        }
      ];
    var state = jQuery.grep(usStates, function (e) {
        return e.abbreviation === input;
      });
    if (state.length > 0) {
      return state[0].name;
    } else {
      return 'State';
    }
  };
});angular.module('persona', []);
angular.module('persona').factory('Persona', [
  '$http',
  '$q',
  function ($http, $q) {
    var Persona = {
        user: {},
        getUser: function () {
          if (Persona.user.hasOwnProperty('email')) {
            return Persona.user;
          } else {
            return false;
          }
        },
        verify: function () {
          var deferred = $q.defer();
          navigator.id.get(function (assertion) {
            $http.post('/persona/verify', { assertion: assertion }).then(function (response) {
              if (response.data.status != 'okay') {
                deferred.reject(response.data.reason);
              } else {
                Persona.user = response.data.user;
                deferred.resolve(response.data.email);
              }
            });
          });
          return deferred.promise;
        },
        logout: function () {
          return $http.post('/persona/logout').then(function (response) {
            Persona.user = {};
            if (response.data.status != 'okay') {
              $q.reject(response.data.reason);
            }
            return response.data.email;
          });
        },
        status: function () {
          $http.post('/persona/status').then(function (response) {
            Persona.user = response.data.user;
            return Persona.user;
          });
        }
      };
    Persona.status();
    return Persona;
  }
]);angular.module('gmaApp').service('states', function () {
  var usStates = [
      {
        name: 'Alabama',
        abbreviation: 'AL'
      },
      {
        name: 'Alaska',
        abbreviation: 'AK'
      },
      {
        name: 'American Samoa',
        abbreviation: 'AS'
      },
      {
        name: 'Arizona',
        abbreviation: 'AZ'
      },
      {
        name: 'Arkansas',
        abbreviation: 'AR'
      },
      {
        name: 'California',
        abbreviation: 'CA'
      },
      {
        name: 'Colorado',
        abbreviation: 'CO'
      },
      {
        name: 'Connecticut',
        abbreviation: 'CT'
      },
      {
        name: 'Delaware',
        abbreviation: 'DE'
      },
      {
        name: 'District Of Columbia',
        abbreviation: 'DC'
      },
      {
        name: 'Federated States Of Micronesia',
        abbreviation: 'FM'
      },
      {
        name: 'Florida',
        abbreviation: 'FL'
      },
      {
        name: 'Georgia',
        abbreviation: 'GA'
      },
      {
        name: 'Guam',
        abbreviation: 'GU'
      },
      {
        name: 'Hawaii',
        abbreviation: 'HI'
      },
      {
        name: 'Idaho',
        abbreviation: 'ID'
      },
      {
        name: 'Illinois',
        abbreviation: 'IL'
      },
      {
        name: 'Indiana',
        abbreviation: 'IN'
      },
      {
        name: 'Iowa',
        abbreviation: 'IA'
      },
      {
        name: 'Kansas',
        abbreviation: 'KS'
      },
      {
        name: 'Kentucky',
        abbreviation: 'KY'
      },
      {
        name: 'Louisiana',
        abbreviation: 'LA'
      },
      {
        name: 'Maine',
        abbreviation: 'ME'
      },
      {
        name: 'Marshall Islands',
        abbreviation: 'MH'
      },
      {
        name: 'Maryland',
        abbreviation: 'MD'
      },
      {
        name: 'Massachusetts',
        abbreviation: 'MA'
      },
      {
        name: 'Michigan',
        abbreviation: 'MI'
      },
      {
        name: 'Minnesota',
        abbreviation: 'MN'
      },
      {
        name: 'Mississippi',
        abbreviation: 'MS'
      },
      {
        name: 'Missouri',
        abbreviation: 'MO'
      },
      {
        name: 'Montana',
        abbreviation: 'MT'
      },
      {
        name: 'Nebraska',
        abbreviation: 'NE'
      },
      {
        name: 'Nevada',
        abbreviation: 'NV'
      },
      {
        name: 'New Hampshire',
        abbreviation: 'NH'
      },
      {
        name: 'New Jersey',
        abbreviation: 'NJ'
      },
      {
        name: 'New Mexico',
        abbreviation: 'NM'
      },
      {
        name: 'New York',
        abbreviation: 'NY'
      },
      {
        name: 'North Carolina',
        abbreviation: 'NC'
      },
      {
        name: 'North Dakota',
        abbreviation: 'ND'
      },
      {
        name: 'Northern Mariana Islands',
        abbreviation: 'MP'
      },
      {
        name: 'Ohio',
        abbreviation: 'OH'
      },
      {
        name: 'Oklahoma',
        abbreviation: 'OK'
      },
      {
        name: 'Oregon',
        abbreviation: 'OR'
      },
      {
        name: 'Palau',
        abbreviation: 'PW'
      },
      {
        name: 'Pennsylvania',
        abbreviation: 'PA'
      },
      {
        name: 'Puerto Rico',
        abbreviation: 'PR'
      },
      {
        name: 'Rhode Island',
        abbreviation: 'RI'
      },
      {
        name: 'South Carolina',
        abbreviation: 'SC'
      },
      {
        name: 'South Dakota',
        abbreviation: 'SD'
      },
      {
        name: 'Tennessee',
        abbreviation: 'TN'
      },
      {
        name: 'Texas',
        abbreviation: 'TX'
      },
      {
        name: 'Utah',
        abbreviation: 'UT'
      },
      {
        name: 'Vermont',
        abbreviation: 'VT'
      },
      {
        name: 'Virgin Islands',
        abbreviation: 'VI'
      },
      {
        name: 'Virginia',
        abbreviation: 'VA'
      },
      {
        name: 'Washington',
        abbreviation: 'WA'
      },
      {
        name: 'West Virginia',
        abbreviation: 'WV'
      },
      {
        name: 'Wisconsin',
        abbreviation: 'WI'
      },
      {
        name: 'Wyoming',
        abbreviation: 'WY'
      }
    ];
  return usStates;
});