<?php namespace GMA\Controllers;

use Input;
use Rest;
use Session;
use GMA\Data\Models\Profile;
use GMA\Data\Models\Log;

class ProfileController extends Base
{
    protected $exceptions = ['user', 'created', 'updated', 'has_profile_school'];

    /**
     * Create a Profile instance
     * @return Response
     */
    public function create()
    {   
        $profile2 = Profile::where('prospect', false)->orderBy('client_id', 'DESC')->get()->first();
       
        $input = array_merge(Input::except($this->exceptions), ['user_id' => Session::get('currentUser'), 'client_id' => $profile2->client_id + 1]);
        $profile = Profile::create($input);

        if ($profile) {
        
            $log = new Log;
            $log->action = 'Add';
            $log->details = "New Profile Created";
            $log->user_id =Session::get('currentUser');
            $log->save();

            return Rest::created($profile);
        
        } else {

            return Rest::withErrors(['unknown' => 'An unkown error occured while saving this profile.'])->error();

        }
    }

    /**
     * Read a Profile instance
     * @param  varchar $id MongoID
     * @return Response
     */
    public function read($id)
    {
        $profile = Profile::find($id);

        if ($profile) {
            if ($profile->user_id !== Session::get('currentUser')) {
             
                return Rest::forbidden();
            
            } else {
            
                return Rest::okay($profile);
            
            }
        
        } else {
        
            return Rest::notFound();
        
        }

    }

    /**
     * Update a Profile instance
     * @param  varchar $id MongoID
     * @return Response
     */
    public function update($id)
    {
        $profile = Profile::find($id);

        if ($profile) {
        
            $profile->fill(Input::except($this->exceptions));

            if ($profile->save()) {
                
                $log = new Log;
                $log->action = 'Update';
                $log->details = 'Profile Update';
                $log->user_id = Session::get('currentUser');
                $log->save();

                return Rest::okay(Input::all());
            
            } else {
            
                return Rest::error();
            
            }
        
        } else {
        
            return Rest::notFound();
        
        }
    }

    /**
     * Delete a Profile instance
     * @param  varchar $id MongoID
     * @return Response
     */
    public function delete($id)
    {
        $profile = Profile::find($id);

        if ($profile) {

            if ($profile->user_id !== Session::get('currentUser')) {
                
                return Rest::forbidden();
            
            } else {

                if ($profile->delete()) {
                    $log = new Log;
                    $log->action = "Deleted";
                    $log->details = "Profile Deleted";
                    $log->user_id = Session::get('currentUser');
                    $log->save();

                    return Rest::gone();

                } else {

                    return Rest::error();

                }

            }

        } else {

            return Rest::notFound();

        }
    }
}
