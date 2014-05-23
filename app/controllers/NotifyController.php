<?php

class NotifyController extends Controller {

	function moreInfo($id) {
		$profile = Profile::with('user')->find($id);
		$profile->prospect = false;
		$profile->status = "More Info Requested";
		$profile->save();


		if (!$profile) return Rest::notFound();

		Event::fire('profile.moreInfoRequired', [$profile->toArray()]);

		return Rest::okay($profile->toArray());
	}
}