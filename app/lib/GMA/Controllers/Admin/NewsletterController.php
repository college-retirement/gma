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
        
        // {StudentFName}
        // {Student F Name }
        // {StudentLName}
        // {ParentFName}
        // {ParentLName}
        // {CaseID}
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

        $profile = Profile::client()->with('user')->where("_id" , $id)->get()->first();
        
            $template['ID'] = $profile['_id'] ;
            $template['CaseID'] = $profile['client_id'];
            $template['StudentFName'] = $profile['name']['first'] ;
            $template['StudentLName'] = $profile['name']['last'];
            if (isset($profile['parents']['father'])) {
                $template['ParentFName'] = $profile['parents']['father']['name']['first'];
                $template['ParentLName'] = $profile['parents']['father']['name']['first'];
            } elseif (isset($profile['parents']['mother'])) {
                $template['ParentFName'] = $profile['parents']['mother']['name']['first'];
                $template['ParentLName'] = $profile['parents']['mother']['name']['first'];
            } else {
                $template['ParentFName'] = "";
                $template['ParentLName'] = "";
            }
            $template['Address'] =  $profile['address']['line1'];
            $template['City'] = $profile['address']['city'];
            $template['State'] = $profile['address']['state'];
            $template['Zip'] = $profile['address']['zipcode'];
            $template['EmailAddress'] = $profile['email'] ;
            $template['GradYear'] = $profile['hsGrad'];
            $template['HighSchool'] = '';
            if (isset($profile['school']) && isset($profile['school']['name']))
                $template['HighSchool'] = $profile['school']['name'];
             $template['HomePhone'] = $profile['phone'];

             //rest of the template are unknown now so just initialize it

             $template['ApptDate'] = '';
             $template['ApptLocation'] = '';
             $template['ApptGoToMeetingID'] = '';
             $template['Password'] ='';
             $template['DataformLink'] = '';
             $template['LearningStyleLink'] = '';
             $template['WebinarDate'] = '';
             $template['WebinarName'] = '';
             $template['WebinarGoToMeetingID'] = '';
             $template['WorkPhone1'] = '';
             $template['WorkPhone2'] = '';
             $template['BackEndScheduleLink'] = '';

              $query = Template::withSortables($this->sortableColumns())->paginate(2);

              foreach ($query as $key => $value) {
                 var_dump($value);
              }
        
            die();

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
