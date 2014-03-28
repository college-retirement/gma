<?php

namespace Application\Form;

use Application\Model\User;
use Aura\Filter;

class Register {

    protected $user;
    protected $validator;

    public function __construct(User\User $user, Filter\RuleCollection $validator) {
        $this->user = $user;
        $this->initValidation($validator);
    }

    public function initValidation($validator) {
        $validator->addSoftRule('email', $validator::IS, 'email');

        $validator->addSoftRule('password', $validator::IS, 'strlenMin', 6);
        $validator->addSoftRule('password_confirm', $validator::IS, 'equalToField', 'password');

        $this->validator = $validator;
        return $this;
    }

    public function validate(array $data = array()) {
        $status = $this->validator->values($data);
        $this->user->configure($data);
        $this->user->setNewPassword($data['password']);
        return $status;
    }

    public function getUser() {
        return $this->user;
    }

    public function getErrors() {
        return $this->validator->getMessages();
    }

    public function getError($field) {
        return $this->validator->getMessages($field);
    }
}