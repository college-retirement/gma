<?php
use Jyggen\Persona\Verifier;
use Jyggen\Persona\Identity;

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
	if (App::environment() == 'production' && !Request::secure()) {
		return Redirect::to('https://' . Request::getHost() . '/');
	}
	return View::make('hello');
});


Route::group(['before' => 'secure'], function(){

	/**
	 * Provides college search for Typeahead
	 */
	Route::post('colleges.json', ['uses' => 'CollegesController@findCollege']);

	/**
	 * Persona - Verifies assertions made by Persona JS and returns the
	 * user account or creates it for them.
	 */
	Route::post('persona/verify', ['uses' => 'AccountsController@personaVerify']);

	/**
	 * Determines if the user has an existing session or not
	 */
	Route::post('persona/status', ['uses' => 'AccountsController@personaStatus']);

	/**
	 * Persona Logout - Removes user session
	 */
	Route::post('persona/logout', ['uses' => 'AccountsController@personaLogout']);

	
	Route::get('drafts', ['uses' => 'DraftsController@all']);
	Route::get('drafts/{id}', ['uses' => 'DraftsController@show']);
	Route::post('drafts', ['uses' => 'DraftsController@create']);
	Route::delete('drafts/{id}', ['uses' => 'DraftsController@delete']);

	Route::post('profiles', ['uses' => 'ProfilesController@create']);


	Route::get('/admin/profiles', ['uses' => 'AdminProfilesController@all']);
	Route::get('/admin/profiles/{profile}', ['uses' => 'AdminProfilesController@view']);

	Route::get('admin/drafts', ['before' => 'validUser|adminUser', 'uses' => 'AdminDraftsController@drafts']);
	Route::get('admin/drafts/{id}', ['before' => 'validUser|adminUser', 'uses' => 'AdminDraftsController@draft']);
	Route::put('admin/drafts/{id}', ['before' => 'validUser|adminUser', 'uses' => 'AdminDraftsController@saveDraft']);
	Route::delete('admin/drafts/{id}', ['before' => 'validUser|adminUser', 'uses' => 'AdminDraftsController@deleteDraft']);

	Route::post('accounts', ['uses' => 'AccountsController@register']);

	Route::get('dl/{id}', function($id){
		$profile = Profile::find($id);
		$filename = $profile->name['last'] . '-' . $profile->name['first'] . '.csv';
		$path = storage_path() . '/' . $filename;

		$export = new GMA\Data\Export\ExportCSV($profile, $path);
		$export->export();

		return Response::download($path);
	});

	Route::post('git/CJPapwjQaeM7mGk', function(){
		return Artisan::call('deploy');
	});
});