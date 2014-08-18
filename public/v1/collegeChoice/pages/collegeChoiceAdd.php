<?php
session_start();

$collegeNotes=$_POST["hidCollegeNotes"];
$collegeNotesIds=explode(",",$collegeNotes);

for ($i=0; $i<count($collegeNotesIds); $i++)
{
	$id=$collegeNotesIds[$i];
	$_SESSION["notes".$id]=$_POST["txtNotes".$id];
}

header("location:collegeChoiceStudentDataForm.php");

?>