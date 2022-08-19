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
				
		$M_User = $_GET['M_User'];
		$M_Pass = $_GET['M_Pass'];		
		$M_Name = $_GET['M_Name'];
		$M_Phonenumber = $_GET['M_Phonenumber'];
		
		
							
		$sql = "INSERT INTO `member`(`M_ID`, `M_User`, `M_Pass`, `M_Name`, `M_Phonenumber`) VALUES (NULL,'$M_User','$M_Pass','$M_Name','$M_Phonenumber')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Project!!";
   
}
	mysqli_close($link);
?>