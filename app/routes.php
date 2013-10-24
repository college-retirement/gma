<?php
use Mozilla\Persona\Verifier;
use Mozilla\Persona\Identity;

App::singleton('persona.verifier', function($app, $endpoint){
	$audience = sprintf('%s://%s:%u', Request::getScheme(), Request::getHost(), Request::getPort());
	return (empty($endpoint)) ? new Verifier($audience) : new Verifier($audience, $endpoint);
});

App::bind('persona.identity', function($app, $assertion){
	return new Identity($assertion);
});

/**
 * Index/Main Application View
 */
Route::get('/', function()
{
	return View::make('hello');
});

/**
 * Provides college search for Typeahead
 */
Route::post('colleges.json', function(){
	$q = College::where('name', 'like', '%' . Input::get('name') . '%')->orderBy('name', 'asc')->limit(10)->get();
	$res = array();

	foreach ($q as $row) {
		$res[] = array(
			'name' => $row->name,
			'city' => $row->city,
			'state' => $row->state
		);
	}

	return Response::json($res);
});

/**
 * Persona - Verifies assertions made by Persona JS and returns the
 * user account or creates it for them.
 */
Route::post('persona/verify', function(){
	$identity = App::make('persona.identity', Input::get('assertion'));
	$verifier = App::make('persona.verifier');
	$verifier->verify($identity);

	if ($identity->getStatus() !== 'okay') {
		return Response::json(array('status' => $identity->getStatus()));
	}
	else {
		$user = User::where('email', $identity->getEmail())->get()->first();
		if ($user) {
			Session::put('currentUser', $user->_id);
			return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
		}
		else {
			$user = new User;
			$user->email = $identity->getEmail();

			if ($user->save()) {
				Session::put('currentUser', $user->_id);
				return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
			}
			else {
				return Response::json(array('error' => 'Unable to create account.'), 500);
			}
		}
	}
});

/**
 * Determines if the user has an existing session or not
 */
Route::post('persona/status', function(){
	if (Session::has('currentUser')) {
		$user = User::find(Session::get('currentUser'));
		return Response::json(array('user' => $user->toArray()));
	}
	else {
		return Response::json(array('user' => null), 401);
	}
});

/**
 * Persona Logout - Removes user session
 */
Route::post('persona/logout', function(){
	Session::forget('currentUser');
	return Response::json();
});

Route::put('/account', function(){
	$user = User::where('email', Input::get('email'))->get()->first();

	if ($user) {
		$user->name = Input::get('name');
		$user->gender = Input::get('gender');
		$user->phone = Input::get('phone');

		$user->save();

		return Response::json($user, 200);
	}

	else {
		$user = User::create(Input::all());
		return Response::json(array('user' => $user->toArray()), 201);
	}
});

Route::get('/drafts', function() {
	if (Session::get('currentUser')) {
		$user = User::with('drafts')->find(Session::get('currentUser'));
		return Response::json(array('drafts' => $user->drafts->toArray()));
	}
	else {
		return Response::json(array(), 401);
	}
});

Route::get('/drafts/{id}', function($id){
	if (Session::get('currentUser')) {
		$draft = Draft::where('user_id', Session::get('currentUser'))->where('_id', $id)->get()->first();
		return Response::json($draft);
	}
	else {
		return Response::json(array(), 401);
	}
});

Route::post('/drafts', function(){
	if (Session::get('currentUser')) {
		Draft::unguard();
		$draft = Draft::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
		return Response::json($draft, 201);
	}
	else {
		return Response::json(array(), 401);
	}	
});

Route::put('/drafts', function(){
	if (Session::get('currentUser')) {
		Draft::unguard();

		$draft = Draft::where('_id', Input::get('_id'));
		$draft->update(Input::except('_id'));

		return Response::json($draft, 200);
	}
	else{
		return Response::json(array(), 401);
	}
});