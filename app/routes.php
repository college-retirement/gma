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
	if (!Request::secure()) {
		return Redirect::to('https://' . Request::getHost() . '/');
	}
	return View::make('hello');
});

/**
 * Provides college search for Typeahead
 */
Route::post('colleges.json', array('https', function(){
	$q = College::where('name', 'like', '%' . Input::get('name') . '%')->orderBy('name', 'asc')->limit(100)->get();
	$res = array();

	foreach ($q as $row) {
		$res[] = array(
			'name' => $row->name,
			'cb_id' => $row->cb_id,
			'city' => $row->city,
			'state' => $row->state
		);
	}

	return Response::json($res);
}));

/**
 * Persona - Verifies assertions made by Persona JS and returns the
 * user account or creates it for them.
 */
Route::post('persona/verify', array('https', function(){
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
}));

/**
 * Determines if the user has an existing session or not
 */
Route::post('persona/status', array('https', function(){
	if (Session::has('currentUser')) {
		$user = User::find(Session::get('currentUser'));
		return Response::json(array('user' => $user->toArray()));
	}
	else {
		return Response::json(array('user' => null), 401);
	}
}));

/**
 * Persona Logout - Removes user session
 */
Route::post('persona/logout', array('https', function(){
	Session::forget('currentUser');
	return Response::json();
}));

Route::put('/account', array('https', function(){
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
}));

Route::get('/drafts', array('https', function() {
	if (Session::get('currentUser')) {
		$user = User::with('drafts')->find(Session::get('currentUser'));
		return Response::json(array('drafts' => $user->drafts->toArray()));
	}
	else {
		return Response::json(array(), 401);
	}
}));

Route::get('/drafts/{id}', array('https', function($id){
	if (Session::get('currentUser')) {
		$draft = Draft::where('user_id', Session::get('currentUser'))->where('_id', $id)->get()->first();
		return Response::json($draft);
	}
	else {
		return Response::json(array(), 401);
	}
}));

Route::post('/drafts', array('https', function(){
	if (Session::get('currentUser')) {
		if (Input::get('_id')) {
			$draft = DB::table('drafts')->where('_id', Input::get('_id'))->get();
			if ($draft) {
				$updatedAt = new DateTime();
				$box = new Stronghold(Input::get('stronghold'));
				$update = [
					'updated_at' => $updatedAt->format('c'),
					'stronghold' => $box->encryptAll()->toArray()
				];
				$update = DB::table('drafts')->where('_id', Input::get('_id'))->update(array_merge(Input::except(array('_id', 'updated_at', 'stronghold')), $update));

				$newDraft = Draft::find(Input::get('_id'));


				return Response::json($newDraft, 200);
			}
		}
		else {
			Draft::unguard();
			$draft = Draft::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
			return Response::json($draft, 201);
		}
	}
	else {
		return Response::json(array(), 401);
	}	
}));

Route::put('/drafts', array('https', function(){
	if (Session::get('currentUser')) {
		Draft::unguard();

		$draft = Draft::where('_id', Input::get('_id'))->get()->first();
		$draft->update(Input::except('_id'));

		return Response::json($draft, 200);
	}
	else{
		return Response::json(array(), 401);
	}
}));

Route::delete('/drafts/{id}', array('https', function($id){
	if (Session::get('currentUser')) {
		Draft::where('_id', $id)->where('user_id', Session::get('currentUser'))->delete();
		return Response::json(array(), 200);
	}
	else {
		return Response::json(array(), 401);
	}
}));
Route::post('/profiles', array('https', function(){
	if (Session::get('currentUser')) {
		Profile::unguard();
		$profile = Profile::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
		return Response::json($profile, 201);
	}
	else {
		return Response::json(array(), 401);
	}
}));


Route::get('/admin/profiles', array('https', function(){
	if (Session::get('currentUser')) {
		$user = User::find(Session::get('currentUser'));

		if ($user->is_admin) {
			$profiles = Profile::all();
			return $profiles;
		}
		else {
			return Response::json(array(), 403);
		}
	}
	else {
		return Response::json(array(), 401);
	}
}));

Route::get('/admin/profiles/{profile}', array('https', function($profile){
	if (Session::get('currentUser')) {
		$user = User::find(Session::get('currentUser'));

		if ($user->is_admin) {
			$profile = Profile::where('_id', $profile)->get()->first();
			return Response::json($profile);
		}
		else {
			return Response::json(array(), 403);
		}
	}
	else {
		return Response::json(array(), 401);
	}
}));

Route::post('accounts', ['https', 'uses' => 'AccountsController@register']);

Route::get('test', function(){
	$box = new Stronghold([
			'student' => [
				'fafsa' => 12345
			],
			'parent' => [
				'fafsa' => 14405
			]
		]);
	$enc = $box->encryptAll()->toArray();

	var_dump($enc);

	$encBox = new Stronghold($enc);
	var_dump($box->decryptAll()->toArray());
	return Response::json($box->encryptAll());
});