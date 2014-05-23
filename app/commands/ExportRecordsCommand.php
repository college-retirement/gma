<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class ExportRecordsCommand extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'crs:export-colleges';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Export basic college details into Mongo.';

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
		$this->info('Getting records and placing them in Mongo. Please be patient, this can take several minutes'); 
		$conn = r\connect('localhost');
		$batchSize = 500;
		$count = r\db('gma')->table('colleges')->count()->run($conn)->toNative();
		$iterations = round($count / $batchSize);
		$counter = 0;

		$dump = array();

		for($ii = 0; $ii < $iterations; ++$ii)
		{
			$result = r\db('gma')->table('colleges')->orderBy(array('cb_name'))->pluck(array('cb_id', 'cb_name', 'contact_info'))->skip($batchSize * $ii)->limit($batchSize)->run($conn)->toNative();
			foreach ($result as $doc) {
				$counter += 1;
				$college = new College;
				$college->cb_id = $doc['cb_id'];
				$college->name = $doc['cb_name'];
				$college->city = $doc['contact_info']['main']['address']['locality'];
				$college->state = $doc['contact_info']['main']['address']['region'];

				$college->save();

			}
		}

		$this->info('Total count: '. $count);
	}

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */
	protected function getArguments()
	{
		return array(
			//array('example', InputArgument::REQUIRED, 'An example argument.'),
		);
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */
	protected function getOptions()
	{
		return array(
			//array('example', null, InputOption::VALUE_OPTIONAL, 'An example option.', null),
		);
	}

}