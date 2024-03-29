<?php

class AdminNewslettersController extends Controller {

    public function newsletters()
    {
        $newsletter = Newsletter::orderBy('templateType', 'desc')->get();

        return Rest::okay($newsletter->toArray());
    }

    public function newsletter($id)
    {
        $newsletter = Newsletter::find($id);

        if (!$newsletter) {
            return Rest::notFound();
        }
        return Rest::okay($newsletter->toArray());
    }

    public function saveNewsletter($id)
    {

        $newsletter = Newsletter::find($id);
        if (!$newsletter) {

            return Rest::notFound();
        } else {
            $newsletter->templateSubject = Input::get('templateSubject');
            $newsletter->templateBody = Input::get('templateBody');
            $newsletter->templateName = Input::get('templateName');

            if ($newsletter->save()) {
                return Rest::okay($newsletter->toArray());
            }
        }
    }

    public function deleteNewsletter($id)
    {

        $newsletter = Newsletter::find($id);

        if (!$newsletter) {
            return Rest::notFound();
        }

        if ($newsletter->delete()) {
            return Rest::gone();
        } else {
            return Rest::withErrors(['not_deleted' => 'Unable to delete draft.'])->conflict();
        }
    }

}