<?php
//stop the direct browsing to this file - let index.php handle which files get displayed
checkLogin();

$expenseaccountobj = new expenseaccount();

#get the invoice id
$id = $_GET['id'];

$expense_account = $expenseaccountobj->select($id);

$smarty -> assign('expense_account',$expense_account);
$smarty -> assign('pageActive', 'expense_account');
$subPageActive = $_GET['action'] =="view"  ? "view" : "edit" ;
$smarty -> assign('subPageActive', $subPageActive);
$smarty -> assign('active_tab', '#money');
?>
