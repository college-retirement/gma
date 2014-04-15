<?php

use Phinx\Migration\AbstractMigration;

class Initial extends AbstractMigration
{
    /**
     * Change Method.
     *
     * More information on this method is available here:
     * http://docs.phinx.org/en/latest/migrations.html#the-change-method
     *
     * Uncomment this method if you would like to use it.
     */
    public function change()
    {
        $table = $this->table('users');
        $table->addColumn('email', 'string')
              ->addColumn('password', 'string', ['length' => 60])
              ->addColumn('role', 'string')
              ->addColumn('created_on', 'datetime')
              ->addColumn('is_admin', 'boolean')
              ->addIndex(['email'], ['unique' => true])
              ->save();

        $table = $this->table('student');
        $table->addColumn('first_name', 'string')
              ->addColumn('middle_name', 'string')
              ->addColumn('last_name', 'string')
              ->addColumn('gender', 'string', ['limit' => 1])
              ->addColumn('phone', 'string')
              ->addColumn('updated_at', 'datetime')
              ->addColumn('created_at', 'datetime')
              ->save();

        $table = $this->table('user_students');
        $table->addColumn('user_id', 'integer')
              ->addColumn('student_id', 'integer')
              ->addIndex(['user_id', 'student_id'], ['unique' => true])
              ->addForeignKey('user_id', 'users', 'id', array('delete' => 'CASCADE'))
              ->addForeignKey('student_id', 'student', 'id', array('delete' => 'CASCADE'))
              ->save();
    }

    
    /**
     * Migrate Up.
     */
    public function up()
    {
    
    }

    /**
     * Migrate Down.
     */
    public function down()
    {

    }
}