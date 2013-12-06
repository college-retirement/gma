<?php

class AdminProspectsController extends Controller {
	
	function all() {
		$page = Input::get('page') ?: 1;
		$total = Profile::prospect()->count();
		$pagesCount = ceil($total / 20);

		$offset = (($page - 1) * 20);
		$offset = ($offset >= 20) ? $offset : 0;
		
		$prospects = Profile::prospect()->with('user')->skip($offset)->take(20)->get();

		return Rest::currentPage($page)->of($pagesCount)->limited(20)->totalItems($total)->okay($prospects->toArray());
	}

	function get($id) {
		$prospect = Profile::prospect()->find($id)->first();

		if (!$prospect) return Rest::notFound();

		return Rest::okay($prospect->toArray());
	}

	function update($id) {
		$profile = Profile::prospect()->with('user')->find($id);

		if (!$profile)  return Rest::notFound();

		$updatedAt = new DateTime();
		$box = new Stronghold(Input::get('stronghold'));
		
		$update = [
				'updated_at' => $updatedAt->format('c'),
				'stronghold' => $box->encryptAll()->toArray()
		];

		$update = DB::table('profiles')->where('_id', Input::get('_id'))->update(array_merge(Input::except(array('_id', 'updated_at', 'stronghold')), $update));
		$newProfile = Profile::find($id);

		if ($update) {
			return Rest::okay($newProfile->toArray());
		}
		else {
			return Rest::withErrors(['not_saved' => 'Unable to save profile.'])->conflict();
		}
	}

	function delete($id) {
		$profile = Profile::prospect()->find($id);

		if (!$profile) return Rest::notFound();

		if ($profile->delete()) {
			return Rest::okay([]);
		}
		else {
			return Rest::conflict();
		}
	}
}