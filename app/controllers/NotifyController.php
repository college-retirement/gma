<?php

class NotifyController extends Controller {

	function moreInfo($id) {
		$profile = Profile::with('user')->find($id);
		$profile->prospect = false;
		$profile->status = "More Info Requested";
		$profile->save();


		if (!$profile) return Rest::notFound();

		$event = $profile->toArray();
		$d['user']['name'] = $event['name']['first']." ".$event['name']['last'];
		$d['_id'] = $event['_id'];
		$d['user']['email'] = $event['email'];

		Event::fire('profile.moreInfoRequired', [$d]);

		

		

		//Event::fire('mmm.test', [$d]);
		

		return Rest::okay($profile->toArray());
	}
}