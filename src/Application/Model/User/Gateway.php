<?php

namespace Application\Model\User;

use Application\Form;
use Aura\Filter;

class Gateway {

    protected $validator;

    public function setFilter(Filter\RuleCollection $validator) {
        $this->validator = $validator;
    }

    public function handleRegistration($data) {
        $form = new Form\Register(new User, $this->validator);
        $result = $form->validate($data);
        if(!$result) {
            return $form;
        }
    }


}