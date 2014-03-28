<?php

namespace Application\Controller;

use Modus\Controller;

class Index extends Controller\Base {

    public function index() {
        $this->template->getRawTemplate()->styles()->add('/assets/css/dashboard.css');
        $this->template->setInnerView('dashboard.php');
        $this->response->setContent($this->template->render());
        return $this->response;

    }

}