<?php
namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Template;
use Rest;

class NewsletterController extends Base {

    public function all()
    {
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
