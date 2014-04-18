<?php

namespace Application\Model\User;

use Modus\Common\Model\Storage as DBStorage;

class Storage extends DBStorage\Database {

	public function saveUser($data,$user_id=null){
		if($user_id){
			return $this->updateUser($data,$user_id);
		}else{
			return $this->saveNewUser($data);
		}

	}

	public function saveStudent($data,$user_id = null,$student_id=null){
		if($student_id){
			return $this->updateStudent($data, $student_id);
		}else{
			return $this->saveNewStudent($data, $user_id);
		}
	}

	public function checkEmailExists($email){
		$sql = "select count(*) as usercount from users where email=:email";
		$data = [
		'email'=>$email
		];
		$result = $this->master->fetchOne($sql,$data);
		if($result['usercount']){
			return TRUE;
		}else{
			return FALSE;
		}
	}

	protected function saveNewUser($data){
		$sql = "Insert into users (
		email,
		password,
		role,
		created_on,
		is_admin,
		first_name,
		last_name
		) VALUES (
		:email,
		:password,
		:role,
		NOW(),
		:is_admin,
		:first_name,
		:last_name
		)";
		$result = $this->master->query($sql,$data);
		if($result){
			return $this->master->lastInsertId('users','id');
		}
	}

	protected function saveNewStudent($data,$user_id){
		$sql = "Insert into student (
		first_name,
		middle_name,
		last_name,
		gender,
		phone,
		updated_at,
		created_at
		) VALUES (
		:first_name,
		:middle_name,
		:last_name,
		:gender,
		:primary_phone,
		NOW(),
		NOW()
		)";
		$result = $this->master->query($sql,$data);
		if($result){
			$student_id = $this->master->lastInsertId('student','id');
			$sql = "Insert into user_students (
			user_id,
			student_id
			) VALUES (
			:user_id,
			:student_id
			)";
			$user_student_data = [
			'user_id' =>$user_id,
			'student_id'=>$student_id
			];
			$user_student_result = $this->master->query($sql,$user_student_data);
			if($user_student_result){
				return $student_id;
			}
		}
	}

	protected function updateUser($data, $user_id){
		// To be implemented later
	}

	protected function updateStudent($data, $student_id){
		// To be implemented later
	}
}