<?php namespace GMA\Controllers\Admin;

use \Controller;
use GMA\Data\Models\Profile;
use \Rest;

class ProfileController extends Controller
{
    public function all()
    {
        return Rest::okay(Profile::paginate(60));
    }
}
