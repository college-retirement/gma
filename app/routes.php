<?php
use Jyggen\Persona\Verifier;
use Jyggen\Persona\Identity;

// Set domain namespace for namespaced controllers
$GmaControllers = "GMA\Controllers\\";

/**
 * Setup application bindings for Persona
 */
App::singleton('persona.verifier', function ($app, $endpoint) {
    $audience = sprintf('%s://%s:%u', Request::getScheme(), Request::getHost(), Request::getPort());
    return (empty($endpoint)) ? new Verifier($audience) : new Verifier($audience, $endpoint);
});

App::bind('persona.identity', function ($app, $assertion) {
    return new Identity($assertion);
});


/**
 * Begin Routing
 */
Route::get('/', function () {
    if (App::environment() == 'production' && !Request::secure()) {
        return Redirect::to('http://' . Request::getHost() . '/');
    }
    return View::make('hello');
});

 

/**
 * Enforce HTTPS on all API routes in production
 */
Route::group(['before' => 'secure'], function () use ($GmaControllers) {

    /**
    *  For password Reminder
    */
    Route::get('reset/{token}', ['uses' => 'AccountsController@getReset']);
    Route::post('reset/{token}', ['uses' => 'AccountsController@postReset']);
    /**
     * Provides college search for Typeahead
     */
    Route::post('colleges.json', ['uses' => 'CollegesController@findCollege']);

    Route::get('colleges/{cb_id}', ['uses' => 'CollegesController@collegeInfo']);

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
     * Account forgot password
     */
    Route::post('forgot', ['uses' => 'AccountsController@forgot']);

     /**
     *  Test Route
     */
    Route::get('/mtest', function () {
        
         $pro = Profile::first();
         var_dump($pro->_id);

         $pro2 = Profile::client()->orderBy('client_id','desc')->first();
         var_dump($pro2->_id. " ". $pro2->client_id);

        $prospects = Profile::client()->orderBy('client_id','desc')->get();
        $i = 12500;
        foreach ($prospects as $key => $prospect) {
            //$prospect->client_id = $i;
            //echo $prospect->_id;
            echo $prospect->client_id. "<br />";
            ++$i;
           // var_dump($prospect->save());
        }
        return "Hello";
    });

    /**
     * Accounts (For Future Use)
     */
    // Route::get('accounts', ['uses' => $GmaControllers . 'AccountsController@showAll']);
    // Route::get('accounts/{id}', ['uses' => $GmaControllers . 'AccountsController@show']);
    // Route::put('accounts/{id}', ['uses' => $GmaControllers . 'AccountsController@update']);
    // Route::delete('accounts/{id}', ['uses' => $GmaControllers . 'AccountsController@delete']);

    /**
     * Drafts REST Routes
     */
    Route::get('drafts', ['before' => 'validUser', 'uses' => 'DraftsController@all']);
    Route::get('drafts/{id}', ['before' => 'validUser', 'uses' => 'DraftsController@show']);
    Route::post('drafts', ['before' => 'validUser', 'uses' => 'DraftsController@create']);
    Route::delete('drafts/{id}', ['before' => 'validUser', 'uses' => 'DraftsController@delete']);

    /**
     * Profiles REST Routes
     */
    Route::post('profiles', ['before' => 'validUser', 'uses' => $GmaControllers . 'ProfileController@create']);
    Route::get('profiles/{id}', ['before' => 'validUser', 'uses' => $GmaControllers . 'ProfileController@read']);
    Route::put('profiles/{id}', ['before' => 'validUser', 'uses' => $GmaControllers . 'ProfileController@update']);

    /**
     * Begin admin routes
     * (Prefixed by /admin)
     */
    Route::group(['prefix' => 'admin', 'before' => 'validUser|adminUser'], function () use ($GmaControllers) {
        Route::get('profiles', ['uses' => $GmaControllers . 'Admin\ProfileController@all']);
        Route::post('profiles', ['uses' => 'AdminProfilesController@create']);
        Route::put('profiles', ['uses' => 'AdminProfilesController@save']);
        
        Route::get('profiles/{id}', ['uses' => 'AdminProfilesController@view']);

        
        Route::get('prospects', ['uses' => $GmaControllers . 'Admin\ProspectController@all']);
        Route::get('prospects/{id}', ['uses' => 'AdminProspectsController@get']);
        Route::put('prospects/{id}', ['uses' => 'AdminProspectsController@update']);
        Route::delete('prospects/{id}', ['uses' => 'AdminProspectsController@delete']);

        Route::get('clients', ['uses' => $GmaControllers . 'Admin\ClientController@all']);
        Route::get('clients/{id}', ['uses' => 'AdminClientsController@get']);
        Route::put('clients/{id}', ['uses' => 'AdminClientsController@update']);
        Route::delete('clients/{id}', ['uses' => 'AdminClientsController@delete']);

        Route::get('drafts', ['uses' => $GmaControllers . 'Admin\DraftController@all']);
        Route::post('drafts', ['uses' => 'AdminDraftsController@createDraft']);
        Route::get('drafts/{id}', ['uses' => 'AdminDraftsController@draft']);
        Route::put('drafts', ['uses' => 'AdminDraftsController@saveDraftByInput']);
        Route::put('drafts/{id}', ['uses' => 'AdminDraftsController@saveDraft']);
        Route::patch('drafts/{id}', ['before' => 'validUser|adminUser', 'uses' => 'DraftsController@updateOwner']);
        Route::delete('drafts/{id}', ['uses' => 'AdminDraftsController@deleteDraft']);

        Route::get('newsletters', ['uses' => $GmaControllers .'Admin\NewsletterController@all']);
        Route::get('newsletter/{id}', ['uses' => 'AdminNewslettersController@newsletter']);
        Route::put('newsletter/{id}', ['uses' => 'AdminNewslettersController@saveNewsletter']);
        Route::delete('newsletter/{id}', ['uses' => 'AdminNewslettersController@deleteNewsletter']);

        Route::get('logs', ['uses' => $GmaControllers . 'Admin\LogController@all']);

        Route::get('users', ['uses' => $GmaControllers . 'Admin\UserController@all']);
        Route::get('users/{id}', ['uses' => 'AdminUsersController@user']);
        Route::put('users/{id}', ['uses' => 'AdminUsersController@editUser']);

        Route::get('dl/{id}', function ($id) {
            $profile = Profile::find($id);
           
            if($profile):
                $filename = $profile->name['last'] . '-' . $profile->name['first'] . '.csv';
                $path = storage_path() . '/' . $filename;

                $export = new GMA\Data\Export\ExportCSV($profile, $path);
                $export->export();

                return Response::download($path);
            else:
                return Rest::notFound();
            endif;
        });

        Route::get('notify/moreinfo/{id}', ['uses' => 'NotifyController@moreInfo']);
        Route::post('notify/moreinfo', ['uses' => 'NotifyController@notifyUser']);
    });

});
