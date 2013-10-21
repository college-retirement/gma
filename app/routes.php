<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

Route::get('/', function()
{
	return View::make('hello');
});

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