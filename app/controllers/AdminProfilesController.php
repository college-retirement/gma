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

	function save() {
		$id = Input::get('_id');
		
		$profile = Profile::find($id);

		if (!$profile) return Rest::notFound();

		$updatedAt = new DateTime();
		$strong = (Input::has('stronghold')) ? Input::get('stronghold') : array();
		$box = new Stronghold($strong);
		$update = [
			'updated_at' => $updatedAt->format('c'),
			'stronghold' => $box->encryptAll()->toArray()
		];

		$update = DB::table('profiles')->where('_id', $id)->update(array_merge(Input::except(array('_id', 'updated_at', 'stronghold', 'user')), $update));
		$updatedProfile = Profile::find($id);

		if ($update) {
			return Rest::okay($updatedProfile->toArray());
		}
		else {
			return Rest::withErrors(['database_save' => 'Unable to update profile in database'])->conflict();
		}
	}
}