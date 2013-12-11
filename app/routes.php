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

	/**
	 * Account registration
	 */
	Route::post('accounts', ['uses' => 'AccountsController@register']);

	/**
	 * Drafts REST Routes
	 */
	Route::get('drafts', ['before' => 'validUser', 'uses' => 'DraftsController@all']);
	Route::get('drafts/{id}', ['before' => 'validUser', 'uses' => 'DraftsController@show']);
	Route::post('drafts', ['before' => 'validUser', 'uses' => 'DraftsController@create']);
	Route::delete('drafts/{id}', ['before' => 'validUser', 'uses' => 'DraftsController@delete']);
	Route::patch('drafts/{id}', ['before' => 'validUser|adminUser', 'uses' => 'DraftsController@updateOwner']);

	/**
	 * Profiles REST Routes
	 */
	Route::post('profiles', ['before' => 'validUser', 'uses' => 'ProfilesController@create']);
	Route::get('profiles/{id}', ['before' => 'validUser', 'uses' => 'ProfilesController@get']);
	Route::put('profiles/{id}', ['before' => 'validUser', 'uses' => 'ProfilesController@update']);




	Route::group(['prefix' => 'admin', 'before' => 'validUser|adminUser'], function(){
		Route::get('profiles', ['uses' => 'AdminProfilesController@all']);
		Route::get('profiles/{profile}', ['uses' => 'AdminProfilesController@view']);
		Route::put('profiles', ['uses' => 'AdminProfilesController@save']);

		Route::get('prospects', ['uses' => 'AdminProspectsController@all']);
		Route::get('prospects/{id}', ['uses' => 'AdminProspectsController@get']);
		Route::put('prospects/{id}', ['uses' => 'AdminProspectsController@update']);
		Route::delete('prospects/{id}', ['uses' => 'AdminProspectsController@delete']);

		Route::get('clients', ['uses' => 'AdminClientsController@all']);
		Route::get('clients/{id}', ['uses' => 'AdminClientsController@get']);
		Route::put('clients/{id}', ['uses' => 'AdminClientsController@update']);
		Route::delete('clients/{id}', ['uses' => 'AdminClientsController@delete']);

		Route::get('drafts', ['uses' => 'AdminDraftsController@drafts']);
		Route::put('drafts', ['uses' => 'AdminDraftsController@saveDraftByInput']);
		Route::get('drafts/{id}', ['uses' => 'AdminDraftsController@draft']);
		Route::put('drafts/{id}', ['uses' => 'AdminDraftsController@saveDraft']);
		Route::delete('drafts/{id}', ['uses' => 'AdminDraftsController@deleteDraft']);

		Route::get('users', ['uses' => 'AdminUsersController@users']);
		Route::get('users/{id}', ['uses' => 'AdminUsersController@user']);
		Route::put('users/{id}', ['uses' => 'AdminUsersController@editUser']);

		Route::get('dl/{id}', function($id){
			$profile = Profile::find($id);
			$filename = $profile->name['last'] . '-' . $profile->name['first'] . '.csv';
			$path = storage_path() . '/' . $filename;

			$export = new GMA\Data\Export\ExportCSV($profile, $path);
			$export->export();

			return Response::download($path);
		});

		Route::get('notify/moreinfo/{id}', ['uses' => 'NotifyController@moreInfo']);
	});


	Route::any('git/CJPapwjQaeM7mGk', function(){
		if (Artisan::call('deploy') == 0) {
			return Rest::okay(null);
		}
		else {
			return Rest::conflict();
		}
	});

});
