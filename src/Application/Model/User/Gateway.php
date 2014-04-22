<?php

namespace Application\Model\User;

use Application\Form;
use Aura\Filter;
use Modus\Common\Model;

class Gateway extends Model\Gateway\Base{

	protected $form;
	public function setForm(Form\Register $form){
		$this->form = $form;
	}

	public function handleRegistration($data) {
		$form = $this->form;
		$result = $form->validate($data);
		if(!$result) {
			$return = [
			'valid'=>false,
			'data'=>$form
			];
			return $return;
		}
		
		$user = $form->getUser();	
		if($this->storage->checkEmailExists($user->email)){
			$this->validator->addMessages('email',['Email already exists']);
			$return = [
			'valid'=>false,
			'data'=>$form
			];
			return $return;
		}
		$user->setAdmin(0);		
		$user_id = $this->storage->saveUser($user->getData());
		//Save student and link		
		if($user_id){
			$student = $form->getStudent();
			$student = $this->storage->saveStudent($student->getData(),$user_id);
		}
		$return = [
		'valid'=>true,
		'data'=>$user_id
		];
		return $return;

	}

}