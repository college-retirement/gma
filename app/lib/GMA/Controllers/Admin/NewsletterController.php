<?php
namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Template;
use Rest;
use GMA\Data\Models\Profile;

class NewsletterController extends Base {

    public function all()
    {
        // $profile['name']['first'] $profile['name']['last'] $profile['_id']
        //ParentFName   ApptDate
        if ($this->isSorting()) {
            
            $query = Template::withSortables($this->sortableColumns())->paginate(70);
            return Rest::okay($query);
        } else {

            $sortableColumns = [['column' => 'templateType',
                    'order' => 'DESC']];
                    
            $templates = Template::withSortables($sortableColumns)->paginate(70);
            return Rest::okay($templates);
        }
    }

     public function profile($id)
    {
        // $profile['name']['first'] $profile['name']['last'] $profile['_id']
        //ParentFName   ApptDate {CaseID}
        // {Address}
        // {City}
        // {State}
        // {Zip}
        // {ApptDate}
        // {ApptLocation}
        // {ApptGoToMeetingID}
        // {Password}
        // {EmailAddress}
        // {HighSchool}
        // {GradYear}
        // {DataformLink}
        // {LearningStyleLink}
        // {WebinarDate}
        // {WebinarName}
        // {WebinarGoToMeetingID}
        // {HomePhone}
        // {WorkPhone1}
        // {WorkPhone2}
        // {BackEndScheduleLink}

        $profiles = Profile::client()->with('user')->where("_id" , $id)->take(2)->get();
        foreach ($profiles as $key => $profile) {
            echo $profile['_id'] ."<br />";
            echo $profile['client_id'] ."<br />";
            echo $profile['name']['first'] ."<br />";
            echo $profile['name']['last'] ."<br />";
            if (isset($profile['parents']['father'])) {
                echo $profile['parents']['father']['name']['first'];
            } elseif (isset($profile['parents']['mother'])) {
                echo $profile['parents']['mother']['name']['first'];
            } else {
                echo "no parents";
            }
            echo $profile['address']['city'] ."<br />";
            echo $profile['address']['state'] ."<br />";
            echo $profile['address']['zipcode'] ."<br />";
            echo $profile['email'] ."<br />";
            echo $profile['hsGrad'] ."<br />";
            if (isset($profile['school']) && isset($profile['school']['name']))
                echo $profile['school']['name']."<br />";
             echo $profile['phone'] ."<br />";
        }
        die('ty');

        if ($this->isSorting()) {
            
            $query = Template::withSortables($this->sortableColumns())->paginate(70);
            return Rest::okay($query);
        } else {

            $sortableColumns = [['column' => 'templateType',
                    'order' => 'DESC']];
                    
            $templates = Template::withSortables($sortableColumns)->paginate(70);
            return Rest::okay($templates);
        }
    }
}
