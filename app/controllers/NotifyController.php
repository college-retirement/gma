<?php

class NotifyController extends Controller {

    public function moreInfo($id)
    {
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

        $log = new UserLog;
        $log->action = "Update";
        $log->details = "More Info Requested";
        $log->user_id = Session::get('currentUser');
        $log->save();

        return Rest::okay($profile->toArray());
    }

    public function notifyUser()
    {
    	$id = Input::get('userid');
    	$profile = Profile::with('user')->where('_id', $id)->get()->first();
        var_dump($profile);
        

    }
}
