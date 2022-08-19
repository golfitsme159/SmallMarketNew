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

		$result = mysqli_query($link, "SELECT l.L_ID,l.L_Name,p.Price,z.Z_Name,t.T_Name FROM locks l JOIN price p ON l.P_ID = p.P_ID JOIN zone z ON p.Z_ID = z.Z_ID JOIN producttype t ON p.T_ID = t.T_ID;");

		if ($result) {

			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;

			}	// while

			echo json_encode($output);

		} //if

	} else echo "Welcome Project!!";	// if2
   
}	// if1


	mysqli_close($link);
?>