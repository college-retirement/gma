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

        $query = Profile::client()->with('user')->where("_id" , $id)->paginate(1);
        var_dump(Rest::okay($query));die();

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
