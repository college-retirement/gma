<?php

class ProfilesController extends Controller {
	
	function create() {
		Profile::unguard();
		$profile = Profile::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
		return Response::json($profile, 201);
	}

	function get($id) {
		$profile = Profile::find($id);

		if (!$profile) return Rest::notFound();

		if ($profile->user_id !== Session::get('currentUser')) {
			return Rest::forbidden();
		}

		return Rest::okay($profile->toArray());
	}

	function update($id) {
		$profile = Profile::find($id);

		if (!$profile) return Rest::notFound();

		if ($profile->user_id !== Session::get('currentUser')) {
			return Rest::forbidden();
		}


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
			if (Input::get('status') == 'Additional Information Received') {
				Event::fire('profile.moreInfoRcd', $profile);
			}
			return Rest::okay($updatedProfile->toArray());
		}
		else {
			return Rest::withErrors(['database_save' => 'Unable to update profile in database'])->conflict();
		}
	}
}