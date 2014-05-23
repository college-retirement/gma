<?php namespace GMA\Data\Security;

trait OwnedByUser {
    public function ownedByUser($query)
    {
        return $query->where('user_id', Auth::user()->id);
    }
}
