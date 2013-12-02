<?php

class NotifyController extends Controller {

	function moreInfo($id) {
		$profile = Profile::with('user')->find($id);


		if (!$profile) return Rest::notFound();

		Event::fire('profile.moreInfoRequired', [$profile->toArray()]);
	}
}