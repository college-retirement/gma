<?php

namespace Application\Model\User;

use Application\Form;
use Aura\Filter;
use Modus\Common\Model;

class Gateway extends Model\Gateway\Base{

	protected $validator;

	public function setFilter(Filter\RuleCollection $validator) {
		$this->validator = $validator;
	}

	public function handleRegistration($data) {
		$form = new Form\Register(new User, $this->validator);
		$result = $form->validate($data);
		if(!$result) {
			$return = [
			'valid'=>false,
			'data'=>$form
			];
			return $return;
		}
		
		$user = $form->getUser();
		$email_exists = $this->storage->checkEmailExists($user->email);		
		$this->validator->addMessages('email',['Email already exists']);
		if($email_exists){
			$return = [
			'valid'=>false,
			'data'=>$form
			];
			return $return;
		}
		$user->setAdmin(0);		
		$user_id = $this->storage->saveUser($user->getData());
		//Save student and link
		$student = new Student();
		$student->configure($data['student']);
		if($user_id){
			$student = $this->storage->saveStudent($student->getData(),$user_id);
		}
		$return = [
		'valid'=>true,
		'data'=>$user_id
		];
		return $return;

	}

}