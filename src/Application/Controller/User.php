<?php

namespace Application\Controller;

use Modus\Controller;

class User extends Controller\Base {

    public function login() {
        $this->template->getRawTemplate()->styles()->add('/assets/css/user.css');
        $this->template->setInnerView('user/login.php');
        $this->response->setContent($this->template->render());
        return $this->response;
    }

}