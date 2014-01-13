<?php namespace GMA\Data\Models;


class Account extends SortableModel
{
    protected $collection = "accounts";
    protected $softDelete = true;
    protected $guarded = ['_id'];
    public $timestamps = true;
}
