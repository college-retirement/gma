<?php
namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Template;
use Rest;

class NewsletterController extends Base {

    public function all()
    {
        if ($this->isSorting()) {
            
            $query = Template::withSortables($this->sortableColumns())->paginate(30);
            return Rest::okay($query);
        } else {

            $sortableColumns = [['column' => 'created_at',
                    'order' => 'DESC']];
                    
            $templates = Template::withSortables($sortableColumns)->paginate(30);
            return Rest::okay($templates);
        }
    }
}
