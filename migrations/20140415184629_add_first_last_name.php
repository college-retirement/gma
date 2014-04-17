<?php

use Phinx\Migration\AbstractMigration;

class AddFirstLastName extends AbstractMigration
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
        $table->addColumn('first_name', 'string', array('null' => true))
              ->addColumn('last_name', 'string', array('null' => true))
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