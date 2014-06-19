<?php namespace GMA\Controllers\Admin;


use GMA\Data\Models\Profile;
use GMA\Controllers\Base;
use \Rest;


class ProspectController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
            //var_dump($this->sortableColumns());
            //var_dump(Input::get('sort'));
            $query = Profile::prospect()->withSortables($this->sortableColumns)->paginate(30);
            return Rest::okay($query);
        } else {

            $sortableColumns = [['column' => 'created_at',
                    'order' => 'DESC']];
                    
            $profiles = Profile::prospect()->withSortables($sortableColumns)->paginate(30);
            return Rest::okay($profiles);
        }
    }

    public function get($id)
    {
        $profile = Profile::prospect()->with('user')->find($id);

        if ($profile) {
            return Rest::okay($profile);
        } else {
            return Rest::notFound();
        }
    }
}
