<?php namespace GMA\Controllers\Admin;

use \Controller;
use GMA\Data\Models\Profile;
use \Rest;

class ProfileController extends Controller
{
    public function all()
    {
        return Rest::okay(Profile::paginate(20));
    }

    public function create()
    {
        $profile = Profile::create(Input::except(['_id', 'updated_at', 'stronghold', 'user']));
        $pro2 = Profile::client()->orderBy('client_id', 'desc')->first();
        $last_client_id = $pro2->client_id;
        $profile->client_id =  $last_client_id + 1;


        if ($profile->save()) {
            $log = new UserLog;
            $log->action = "Admin Create";
            $log->details = "New Profile Created";
            $log->user_id = Session::get('currentUser');
            $log->save();

            return Rest::created($profile->toArray());
        } else {
            return Rest::conflict();
        }
    }
}
