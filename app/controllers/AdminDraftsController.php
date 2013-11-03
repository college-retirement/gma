<?php

class AdminDraftsController extends Controller {
	
	function drafts() {
		$page = Input::get('page') ?: 1;
		$total = Draft::count();
		$pagesCount = ceil($total / 20);

		$offset = (($page - 1) * 20);
		$offset = ($offset >= 20) ? $offset : 0;
		
		$drafts = Draft::with('user')->skip($offset)->take(20)->get();

		return Rest::currentPage($page)->of($pagesCount)->limited(20)->totalItems($total)->okay($drafts->toArray());
	}

	function draft($id) {
		$draft = Draft::with('user')->find($id);

		if (!$draft) return Rest::notFound();

		return Rest::okay($draft->toArray());
	}

	function saveDraft($id) {
		$draft = Draft::with('user')->find($id);

		if (!$draft)  Rest::notFound();

		$update = $draft->update(Input::except(['_id', 'user']));

		if ($update) {
			return Rest::okay($draft->toArray());
		}
		else {
			return Rest::withErrors(['not_saved' => 'Unable to save draft.'])->conflict();
		}
	}

	function deleteDraft($id) {
		$draft = Draft::find($id);

		if (!$draft) Rest::notFound();

		if ($draft->delete()) {
			return Rest::gone();
		}

		else {
			return Rest::withErrors(['not_deleted' => 'Unable to delete draft.'])->conflict();
		}
	}
}