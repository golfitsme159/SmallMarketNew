<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$M_ID = $_GET['M_ID'];
		$RE_ID = $_GET['RE_ID'];
		$RE_FDate = $_GET['RE_FDate'];
		$RE_EDate = $_GET['RE_EDate'];
		$L_ID = $_GET['L_ID'];
		$RES_ID = $_GET['RES_ID'];
							
		$sql = "INSERT INTO `reserve` (`RE_ID`, `RE_FDate`, `RE_EDate`, `L_ID`, `RES_ID`, `M_ID`) VALUES ('$RE_ID', '$RE_FDate', '$RE_EDate', '$L_ID', '$RES_ID', '$M_ID')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome To Project";
   
}
	mysqli_close($link);
?>