<?php

// Default Command Imports
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

use Guzzle\Http\Client;

class GetCollegeFinAid extends Command
{

    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'crs:collegeFinAid';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Checks all Drafts and submitted Profiles to ensure Financial Aid data is available.';

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
    }

    public function processDrafts()
    {
        $draft_count = Draft::count();

        $drafts = Draft::all();

        $this->info("$draft_count Drafts to process.");

        $results = $this->iterate($drafts);

        $this->info($results->processed  . " Drafts processed.");
        $this->info($results->updated . " Drafts updated.");
    }

    public function processProfiles()
    {
        $profile_count = Profile::count();
        $profiles = Profile::all();

        $this->info("$profile_count Profiles to process.");

        $results = $this->iterate($profiles);

        $this->info($results->processed . ' Profiles processed.');
        $this->info($results->updated . ' Profiles updated.');
    }

    public function iterate($collection)
    {
        $processed = 0;
        $updated = 0;

        foreach ($collection as &$item) {
            $item_array = $item->toArray();
            $update = false;

            if (array_key_exists('schools', $item_array)) {

                $schools = $item_array['schools'];

                foreach ($item_array['schools'] as $key => &$school) {
                    if (array_key_exists('cb_id', $school) && !array_key_exists('finAid', $school)) {

                        if (Cache::has('school_info_' . $school['cb_id'])) {
                            $college = Cache::get('school_info_' . $school['cb_id']);
                            
                        } else {
                            $client = new Client("http://api.getmoreaid.com/colleges/");
                            $college = $client->get($school['cb_id'] . '.json')->send()->json();

                            Cache::forever('school_info_' . $school['cb_id'], $college);
                        }
                        
                        $update = true;
                        $requirements = $college['college']['financial_aid']['requirements'];
                        $school['finAid'] = $requirements;

                    } else {
                        $name = get_class($item) . ' ID ' . $item_array['_id'];
                        $this->error("$name has a school with no CollegeBoard ID. Unable to fetch Financial Aid Data.");
                    }
                }
            }
            if ($update) {
                try {
                    $item->update($item_array);
                    $updated++;
                       
                } catch (Exception $e) {
                    $this->error($e->message());
                }
            }
            $processed++;
        }

        return (object) ['processed' => $processed, 'updated' => $updated];
    }
}
