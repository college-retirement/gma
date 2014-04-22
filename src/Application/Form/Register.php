<?php

namespace Application\Form;

use Application\Model\User;
use Aura\Filter;

class Register {

    protected $user;
    protected $student;
    protected $validator;

    public function __construct(User\User $user, User\Student $student, Filter\RuleCollection $validator) {
        $this->user = $user;
        $this->student = $student;
        $this->initValidation($validator);
    }

    public function initValidation($validator) {
        $validator->addSoftRule('email', $validator::IS, 'email');
        $validator->addSoftRule('password', $validator::IS, 'strlenMin', 6);
        $validator->addSoftRule('password_confirm', $validator::IS, 'equalToField', 'password');
        $validator->addSoftRule('first_name', $validator::IS_NOT, 'blank');
        $validator->addSoftRule('last_name', $validator::IS_NOT, 'blank');
        $validator->addSoftRule('student_last_name', $validator::IS_NOT, 'blank');
        $validator->addSoftRule('student_first_name', $validator::IS_NOT, 'blank');
        $validator->addSoftRule('student_primary_phone', $validator::IS_NOT, 'blank');
        $this->validator = $validator;
        return $this;
    }

    public function validate(array $data = array()) {
    	$status = $this->validator->values($data);
        $this->user->configure($data);
        $this->user->setNewPassword($data['password']);
        $this->student->configure($data);
        return $status;
    }

    public function getUser() {
        return $this->user;
    }
    
    public function getStudent() {
    	return $this->student;
    }

    public function getErrors() {
        return $this->validator->getMessages();
    }

    public function getError($field) {
        return $this->validator->getMessages($field);
    }
}