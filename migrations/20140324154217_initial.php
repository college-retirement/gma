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
              ->addColumn('gender', 'string', ['limit' => 1])
              ->addColumn('first_name', 'string')
              ->addColumn('middle_name', 'string')
              ->addColumn('last_name', 'string')
              ->addColumn('phone', 'string')
              ->addColumn('role', 'string')
              ->addColumn('updated_at', 'datetime')
              ->addColumn('created_at', 'datetime')
              ->addColumn('is_admin', 'boolean')
              ->addIndex(['email'], ['unique' => true])
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