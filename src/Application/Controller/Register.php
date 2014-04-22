<?php

namespace Application\Controller;

use Application\Model\User\Student;

use Modus\Controller;
use Application\Form;

class Register extends Controller\Base {

    protected $form;

    public function index() {
        $this->template->setData([
            'messages' => [],
        ]);
        $this->template->setInnerView('register.php');
        $this->template->setData(['user' => $this->form->getUser(),'student'=>$this->form->getStudent()]);
        $this->response->setContent($this->template->render());
        return $this->response;
    }

    public function register() {
        $data = $this->context->getPost();
        $gateway = $this->getModel('user');
        $result = $gateway->handleRegistration($data);        
        if(!$result['valid']) {        	
        	$form = $result['data'];
            $this->template->setInnerView('register.php');
            $this->template->setData([
                'user' => $form->getUser(),
            	'student'=>$form->getStudent(),
                'error' => $form->getErrors(),
            ]);
            $this->response->setContent($this->template->render());
            return $this->response;
        }else{        	
     		// Handle the redirection/email verification or just log the user in
        	$this->response->setRedirect('/');
        }
    }

    public function setForm(Form\Register $form) {
        $this->form = $form;
    }

}