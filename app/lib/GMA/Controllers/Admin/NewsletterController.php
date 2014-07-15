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

        $profile = Profile::client()->where("_id" , $id)->get()->first();
        var_dump($profile);die();
            $variables['ID'] = $profile['_id'] ;
            $variables['CaseID'] = $profile['client_id'];
            $variables['StudentFName'] = $profile['name']['first'] ;
            $variables['StudentLName'] = $profile['name']['last'];
            if (isset($profile['parents']['father'])) {
                $variables['ParentFName'] = $profile['parents']['father']['name']['first'];
                $variables['ParentLName'] = $profile['parents']['father']['name']['first'];
            } elseif (isset($profile['parents']['mother'])) {
                $variables['ParentFName'] = $profile['parents']['mother']['name']['first'];
                $variables['ParentLName'] = $profile['parents']['mother']['name']['first'];
            } else {
                $variables['ParentFName'] = "";
                $variables['ParentLName'] = "";
            }
            $variables['Address'] =  $profile['address']['line1'];
            $variables['City'] = $profile['address']['city'];
            $variables['State'] = $profile['address']['state'];
            $variables['Zip'] = $profile['address']['zipcode'];
            $variables['EmailAddress'] = $profile['email'] ;
            $variables['GradYear'] = $profile['hsGrad'];
            $variables['HighSchool'] = '';
            if (isset($profile['school']) && isset($profile['school']['name']))
                $variables['HighSchool'] = $profile['school']['name'];
             $variables['HomePhone'] = $profile['phone'];

             //rest of the template are unknown now so just initialize it

             $variables['ApptDate'] = '';
             $variables['ApptLocation'] = '';
             $variables['ApptGoToMeetingID'] = '';
             $variables['Password'] ='';
             $variables['DataformLink'] = '';
             $variables['LearningStyleLink'] = '';
             $variables['WebinarDate'] = '';
             $variables['WebinarName'] = '';
             $variables['WebinarGoToMeetingID'] = '';
             $variables['WorkPhone1'] = '';
             $variables['WorkPhone2'] = '';
             $variables['BackEndScheduleLink'] = '';

              
         var_dump($variables);die();
            

            $sortableColumns = [['column' => 'templateType',
                    'order' => 'DESC']];
                    
            $query= Template::withSortables($sortableColumns)->paginate(70);

            foreach ($query as $key => $value) {
                 $templates[] = [
                        '_id' => $value['_id'],
                        'created' => $value['created'],
                        'isMasterTemplate' => $value['isMasterTemplate'],
                        'templateBody' => $this->parsetemplate($variables, $value['templateBody']),
                        'templateID' => $value['templateID'],
                        'templateName' => $value['templateName'],
                        'templateSubject' => $value['templateSubject'],
                        'templateType' => $value['templateType'],
                        'updated' => $value['updated'],
                        'updated_at' => $value['updated_at'],
                        'useMasterTemplate' => $value['useMasterTemplate']
                    ];
              }
            return Rest::okay($templates);
        
    }

    public function parsetemplate($variables, $template)
    {
        var_dump($variables);die();
        foreach($variables as $key => $val)
        {
            $template = str_replace('{'.$key.'}', $val, $template);
        }

        return $template;
    }
}
