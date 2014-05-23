<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class CheckCollegeFinAid extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'crs:checkFinAid';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Checks all Drafts and submitted Profiles to see if there are CB_IDs associated with the schools.';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return void
     */
    public function fire()
    {
        $this->info('Processing local Drafts collection...');
        $this->processDrafts();

        $this->info('Processing local Profiles collection...');
        $this->processProfiles();

        $this->info('Done');
    }

    public function processDrafts()
    {
        $draft_count = Draft::count();

        $drafts = Draft::all();

        $this->info("$draft_count Drafts to process.");

        $results = $this->iterate($drafts);
    }

    public function processProfiles()
    {
        $profile_count = Profile::count();
        $profiles = Profile::all();

        $this->info("$profile_count Profiles to process.");

        $results = $this->iterate($profiles);
    }

    public function iterate($collection) {
        $processed = 0;

        foreach ($collection as &$item) {
            $item_array = $item->toArray();

            if (array_key_exists('schools', $item_array)) {

                $schools = $item_array['schools'];

                foreach ($item_array['schools'] as $key => &$school) {
                    if (!array_key_exists('cb_id', $school)) {
                        $this->error(get_class($item) . " ID " . $item_array['_id'] . ' has a school with no CollegeBoard ID.');
                    }
                }
            }
            $processed++;
        }

        return (object) ['processed' => $processed];
    }
}
