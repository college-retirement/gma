<?php

use Illuminate\Database\Migrations\Migration;

class Init extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('users', function($collection){
			$collection->unique('email');
		});

		Schema::create('drafts', function($collection){
			$collection->index('last_modified');
		});

		Schema::create('profiles', function($collection){
			$collection->index('user_id');
			$collection->index('last_modified');
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('users');
		Schema::drop('drafts');
		Schema::drop('profiles');
	}

}