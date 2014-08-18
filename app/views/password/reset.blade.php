<!doctype html>
<html lang="en" ng-app="gmaApp">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title>College & Retirement Solutions</title>
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
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
                <img src="http://gma.dev/assets/img/crs-logo.png" alt="College & Retirement Solutions"  class="logo">
                College & Retirement Solutions
            </a>
          </div>
      </nav>

      @if(Session::has('error'))
    <div class="alert-box error">
        <h2>{{ Session::get('error') }}</h2>
    </div>
   @endif

 {{ Form::open(['method' => 'post']) }}


    <div class="form-group">
        <label for="email"> Email: </label>
        <input type="hidden" name="token" value="{{ $token }}">
        <input type="email" name="email" class="form-control">

    </div>

    <div class="form-group">
        <label for="password"> Password: </label>
        <input type="password" name="password" class="form-control">
    </div>

    <div class="form-group">
        <label for="password_confirmation"> Password Confirmation: </label>
        <input type="password" name="password_confirmation" class="form-control">
    </div>



    <input type="submit" value="Reset Password" class="btn btn-default">
    
 {{  Form::close() }}


  </div>
</body>