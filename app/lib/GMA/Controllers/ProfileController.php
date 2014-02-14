<?php namespace GMA\Controllers;

use Input;
use Rest;
use Session;
use GMA\Data\Models\Profile;

class ProfileController extends Base
{
    protected $exceptions = ['user', 'created', 'updated', 'has_profile_school'];

    /**
     * Create a Profile instance
     * @return Response
     */
    public function create()
    {
        $input = array_merge(Input::except($this->exceptions), ['user_id' => Session::get('currentUser')]);
        $profile = Profile::create($input);

        if ($profile) {
        
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
