<?php

class AdminProfilesController extends Controller {
	
	function all() {
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
	}

	function view($profile) {
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
	}
}