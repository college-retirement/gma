<?php

class ProfilesController extends Controller {
	
	function create() {
		if (Session::get('currentUser')) {
			Profile::unguard();
			$profile = Profile::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
			return Response::json($profile, 201);
		}
		else {
			return Response::json(array(), 401);
		}

	}
}