<?php

class AdminProfilesController extends Controller {
	
	function all() {
		return Profile::all();
	}

	function create() {
		$profile = Profile::create(Input::except(['_id', 'updated_at', 'stronghold', 'user']));

		if ($profile) {
			return Rest::created($profile->toArray());
		}

		else {
			return Rest::conflict();
		}
	}

	function view($profile) {
		$profile = Profile::where('_id', $profile)->get()->first();
		return Response::json($profile);
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