 <?php
 include_once '../../commonPhp/csrNewHeader.php';
 ?>

<br>
<a href="uploadCompetingColleges.php">Back to Upload Competing Colleges</a>
<br><br>

<?php
include("../../commonPhp/mySqlConnect.php");

$whichTable=$_POST["radTable"];
$fileName=$_FILES['spreadsheetUpload']['tmp_name'];

echo "The following errors were thrown when trying to insert the spreadsheet into the database.<br>";
echo "You may want to copy them into a Word document for saving before correcting them.<br>";
echo "You can either correct the errors manually by using the Competing Colleges page, or correct the problem schools and put them into a new spreadsheet to upload.<br>";
echo "<br><hr width=\"90%\"><br>";

require_once 'excelReader.php';

$xls=new Spreadsheet_Excel_Reader($fileName);

$colCount=$xls->colcount();
$rowCount=$xls->rowCount();

for ($i=1; $i<=$colCount; $i++)
{
	$name=trim($xls->val(1,$i));

	if ($name!="")
	{
		$nameLower=strtolower($name);

		$sql="SELECT COLLEGE_ID FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME)='$nameLower'";
		$result=mysql_query($sql);

		if ($result)
		{
			$mainCollegeId="";

			$row=mysql_fetch_array($result);
			$mainCollegeId=$row["COLLEGE_ID"];
			
			if ($mainCollegeId!="")
			{
				for ($j=2; $j<=$rowCount; $j++)
				{
					$competingCollegeName=trim($xls->val($j,$i));

					if ($competingCollegeName!="")
					{
						$competingCollegeNameLower=strtoLower($competingCollegeName);
						
						$sql="SELECT COLLEGE_ID FROM TCOLLEGE WHERE LOWER(COLLEGE_NAME)='$competingCollegeNameLower'";
						$result=mysql_query($sql);

						if ($result)
						{
							$competingCollegeId="";

							$row=mysql_fetch_array($result);
							$competingCollegeId=$row["COLLEGE_ID"];
							
							if ($competingCollegeId!="")
							{
								//$sql="INSERT INTO TCOLLEGE_COMPETE (COLLEGE_ID, COMPETE_COLLEGE_ID, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ($mainCollegeId, $competingCollegeId, NOW(), 'admin', NOW(), 'admin')";
								$sql="INSERT INTO $whichTable (COLLEGE_ID, COMPETE_COLLEGE_ID, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ($mainCollegeId, $competingCollegeId, NOW(), 'admin', NOW(), 'admin')";
								$result=mysql_query($sql);
							
								if (!$result)
									echo "<b>Insert problem (most likely a duplicate competing school)\n<br>\nError message:</b>\n<br>\n" . mysql_error() . "\n<br>\n<b>Main college name:</b>\n<br>\n$name\n<br>\n<b>Competing college name:</b>\n<br>\n$competingCollegeName\n<br>\n<b>SQL:</b>\n<br>\n" . $sql . "\n<br><br>\n";
							}
							else
								echo "<b>No match for competing college:</b> $competingCollegeName <b>(main college is $name)</b>\n<br><br>\n";
						}
						else
							echo "<b>No match for competing college:</b> $competingCollegeName <b>(main college is $name)</b>\n<br><br>\n";
					}				
				}
			}
			else
				echo "<b>No match for main college:</b> $name\n<br><br>\n";
		}
		else
			echo "<b>No match for main college:</b> $name\n<br><br>\n";
	}
}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/crsNewFooter.php';
?>
