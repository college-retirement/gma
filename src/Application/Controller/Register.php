<?php

namespace Application\Controller;

use Modus\Controller;
use Application\Form;

class Register extends Controller\Base {

    protected $form;

    public function index() {
        $this->template->setData([
            'messages' => [],
        ]);
        $this->template->setInnerView('register.php');
        $this->template->setData(['user' => $this->form->getUser()]);
        $this->response->setContent($this->template->render());
        return $this->response;
    }

    public function register() {
        $data = $this->context->getPost();
        $valid = $this->form->validate($data);
        if(!$valid) {
            $this->template->setInnerView('register.php');
            $this->template->setData([
                'user' => $this->form->getUser(),
                'messages' => $this->form->getErrors(),
            ]);
            $this->response->setContent($this->template->render());
            return $this->response;
        }
    }

    public function setForm(Form\Register $form) {
        $this->form = $form;
    }

}