<?php

class DraftsController extends Controller
{
    
    public function all()
    {
        if (Session::get('currentUser')) {
            $user = User::with('drafts')->find(Session::get('currentUser'));
            return Response::json(array('drafts' => $user->drafts->toArray()));
        } else {
            return Response::json(array(), 401);
        }
    }

    public function create()
    {
        if (Session::get('currentUser')) {
            if (Input::get('_id')) {
                $draft = DB::table('drafts')->where('_id', Input::get('_id'))->get();
                if ($draft) {
                    $updatedAt = new DateTime();
                    $strong = (Input::has('stronghold')) ? Input::get('stronghold') : array();
                    $box = new Stronghold($strong);
                    $update = [
                        'updated_at' => $updatedAt->format('c'),
                        'stronghold' => $box->encryptAll()->toArray()
                    ];
                    $update = DB::table('drafts')->where('_id', Input::get('_id'))->update(array_merge(Input::except(array('_id', 'updated_at', 'stronghold')), $update));

                    $newDraft = Draft::find(Input::get('_id'));

                    $log = new UserLog;
                    $log->action = 'Update';
                    $log->details = "Draft Updated";
                    $log->user_id = Session::get('currentUser');
                    $log->save();


                    return Response::json($newDraft, 200);
                }
            } else {
                Draft::unguard();
                $draft = Draft::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
                $log = new UserLog;
                $log->action = 'Create';
                $log->details = "New Draft Create";
                $log->user_id = Session::get('currentUser');
                $log->save();
                return Response::json($draft, 201);
            }
        } else {
            return Response::json(array(), 401);
        }
    }

    public function show($id)
    {
        if (Session::get('currentUser')) {
            $draft = Draft::where('user_id', Session::get('currentUser'))->where('_id', $id)->get()->first();
            return Response::json($draft);
        } else {
            return Response::json(array(), 401);
        }
    }

    public function delete($id)
    {
        if (Session::get('currentUser')) {
            Draft::where('_id', $id)->where('user_id', Session::get('currentUser'))->delete();
            $log = new UserLog;
            $log->action = 'Delete';
            $log->details = "Draft Deleted";
            $log->user_id = Session::get('currentUser');
            $log->save();
            return Response::json(array(), 200);
        } else {
            return Response::json(array(), 401);
        }
    }

    public function updateOwner($id)
    {
        $userId = Input::get('user_id');

        if ($userId == null || $userId == '') {
            return Rest::withErrors(['invalid_user' => '`user_id` field required.'])->badRequest();
        }

        $user = User::find($userId);

        if (!$user) {
            return Rest::withErrors(['invalid_user' => "User ID '$userId' not found."])->notFound();
        } else {
            $draft = Draft::find($id);

            if (!$draft) {
                return Rest::withErrors(['invalid_id' => "Draft ID '$id' not found."])->notFound();
            }

            $draft->user_id = $userId;

            if ($draft->save()) {
                return Rest::okay($draft->toArray());
            } else {
                return Rest::withErrors(['unable_to_save' => 'Unable to save Draft.'])->conflict();
            }
        }

        return Rest::okay([$userId]);
    }
}
