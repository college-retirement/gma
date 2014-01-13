<?php namespace GMA\Controllers;

use GMA\Data\Models\Accounts;
use Input;
use Rest;
use DB;

class AccountsController extends Base
{

    /**
     * Show all accounts
     * 
     * @return Response
     */
    public function showAll()
    {
        if ($this->isSorting()) {
            $sortable = $this->sortableColumns();
            $query = Accounts::withSortables($sortable)->paginate(10);
            return Rest::okay($query);

        } else {
            $result = Accounts::paginate(1);
            return Rest::okay($result);
        }
    }

    public function show($id)
    {
        $account = Accounts::find($id);

        if ($account) {
            return Rest::okay($account);
        } else {
            return Rest::notFound();
        }
    }

    public function update($id)
    {
        $account = Accounts::find($id);

        if ($account) {

        } else {
            return Rest::notFound();
        }
    }

    public function delete($id)
    {
        $account = Accounts::find($id);

        if ($account) {
            try {
                $account->delete();
                return Rest::okay();
            } catch (Exception $e) {
                return Rest::withErrors(['delete_failed' => 'Unable to delete record.']);
            }
        } else {
            
        }
    }
}
