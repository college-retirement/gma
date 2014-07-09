<!doctype html>
<html lang="en" ng-app="gmaApp">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<title>College & Retirement Solutions</title>
	<!-- <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet"> -->
	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.min.css">
	<link rel="stylesheet" href="/assets/css/app.css">
</head>
<body ng-controller="AppCtrl">
	<div class="container">
		
		<nav class="navbar navbar-default" role="navigation">
		  <!-- Brand and toggle get grouped for better mobile display -->
		  <div class="navbar-header">
		    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
		      <span class="sr-only">Toggle navigation</span>
		      <span class="icon-bar"></span>
		      <span class="icon-bar"></span>
		      <span class="icon-bar"></span>
		    </button>
		    <a class="navbar-brand" href="#">
		    	<img src="assets/img/crs-logo.png" alt="College & Retirement Solutions"  class="logo">
			    College & Retirement Solutions
		    </a>
		  </div>

		  <!-- Collect the nav links, forms, and other content for toggling -->
		  <div class="collapse navbar-collapse navbar-ex1-collapse">
		    <ul class="nav navbar-nav">
		      </li>
		    </ul>
		    <div ng-controller="PersonaCtrl">
			    <div class="navbar-right" ng-show="getUser() == false">
			    	<a class="persona-button dark" ng-click="login()">
			    		<span>Sign In</span>
			    	</a>
			    	<a class="persona-button dark" href="#/forgot">
			    		<span>Forgot Password</span>
			    	</a>
			    </div>
		    	<ul class="nav navbar-nav navbar-right" ng-cloak ng-hide="getUser() == false">
		    		
		    		<li class="dropdown" ng-show="getUser().is_admin == true">
		    			<a class="dropdown-toggle" data-toggle="dropdown">Change Level
		    				<b class="caret"></b>
		    			</a>
		    			

		    			<ul class="dropdown-menu">
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#/admin/list?clients=false">Prospects</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#/admin/list?clients=true">Clients</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#/admin/search">Search page</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#/admin/drafts">Drafts</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#admin/users">Users</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#admin/logs">Logs</a>
		    				</li>
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#admin/templates">Templates</a>
		    				</li>
		    			</ul>	
		    		</li>	
		    		<li class="dropdown">
		    			
		    			
		    			
		    			
		    			
		    			<a class="dropdown-toggle" data-toggle="dropdown">
		    				Logged in as {{getUser().name.first}} {{getUser().name.last}}
		    				<b class="caret"></b>
		    			</a>
		    			<ul class="dropdown-menu">
		    				<li ng-cloak ng-show="getUser().is_admin == true">
		    					<a href="#/admin">Admin</a>
		    				</li>
		    				<li>
		    					<a ng-click="logout()">Logout</a>
		    				</li>
		    			</ul>
		    		</li>
		    	</ul>
		    </div>
<!-- 		    <ul class="nav navbar-nav navbar-right">
		      <li><a class="persona-button dark"><span>Sign In</a></li>
		      <li class="dropdown">
		        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
		        <ul class="dropdown-menu">
		          <li><a href="#">Action</a></li>
		          <li><a href="#">Another action</a></li>
		          <li><a href="#">Something else here</a></li>
		          <li><a href="#">Separated link</a></li>
		        </ul>
		      </li>
		    </ul> -->
		  </div><!-- /.navbar-collapse -->
		</nav>
	</div>
	<div ng-view>

	</div>
	<?php if (App::environment() == "local"): ?>
		<script src="//localhost:35729/livereload.js"></script>
	<?php endif; ?>
	<script src="//code.jquery.com/jquery-1.9.1.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/js/toastr.min.js"></script>
	<script src="/assets/js/vendor/jquery.masked.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.4/angular.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.4/angular-route.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.4/angular-animate.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/angular-ui/0.4.0/angular-ui.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.6.0/ui-bootstrap-tpls.min.js"></script>
	<script src="/assets/js/vendor/angular-ui-utils.min.js"></script>
	
	<!-- <script src="https://login.persona.org/include.js"></script> -->
	<script src="/assets/js/application.min.js"></script>
</body>
</html>
