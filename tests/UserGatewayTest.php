<?php

use Application\Model\User;
use Application\Form;
use Aura\Filter;
class UserGatewayTest extends PHPUnit_Framework_TestCase
{
	public function testInvalidHandleRegistration(){
		$storage = Mockery::mock('Modus\Common\Model\Storage\Database');			
		$storage->shouldReceive('checkEmailExists')->andReturn(TRUE);
		$gateway = new User\Gateway($storage);
		$form = Mockery::mock('Application\Form\Register');
		$form->shouldReceive('validate')->andReturn(FALSE);
		$gateway->setForm($form);
		$result = $gateway->handleRegistration($this->getInvalidData());
		$this->assertEquals($result['valid'], FALSE);			
	}	
	
	public function testValidHandleRegistration(){
		$storage = Mockery::mock('Modus\Common\Model\Storage\Database');
		$storage->shouldReceive('checkEmailExists')->andReturn(TRUE);
		$storage->shouldReceive('saveUser')->andReturn('5');
		$storage->shouldReceive('saveStudent')->andReturn('10');
		$gateway = new User\Gateway($storage);
		$form = Mockery::mock('Application\Form\Register');
		$form->shouldReceive('validate')->andReturn(TRUE);
		$gateway->setForm($form);
		$result = $gateway->handleRegistration($this->getInvalidData());
		$this->assertEquals($result['valid'], TRUE);
	}
	public function tearDown() {
		Mockery::close();
	}
	
	public function getValidData(){
		return [
		'first_name'=>'First Name',
		'last_name'=>'Last Name',
		'email'=>'myemail@email.com',
		'password'=>'123456',
		'confirm_password'=>'123456',
		'role'=>'Student',
		'student_first_name'=>'Student First Name',
		'student_last_name' => 'Student Last Name',
		'student_middle_name'=>'Student Middle Name',
		'student_primary_phone'	=> '988761220',
		'student_gender'=>'M'
		];
	}
	
	public function getInvalidData(){
		return [
		'first_name'=>'First Name',
		'last_name'=>'Last Name',
		'email'=>'',
		'password'=>'123456',
		'confirm_password'=>'123',
		'role'=>'Student',
		'student_first_name'=>'Student First Name',
		'student_last_name' => 'Student Last Name',
		'student_middle_name'=>'Student Middle Name',
		'student_primary_phone'	=> '988761220',
		'student_gender'=>'M'
		];
	}
	
}
?>