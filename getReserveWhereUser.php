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

		$result = mysqli_query($link, "SELECT r.RE_ID,r.RE_FDate,r.RE_EDate,
			l.L_Name,re.RES_Name,m.M_Name,p.Price,t.T_Name,z.Z_Name 
			FROM reserve r 
			JOIN locks l ON r.L_ID = l.L_ID
			JOIN reservestatus re ON r.RES_ID = re.RES_ID
			JOIN member m ON r.M_ID = m.M_ID
			JOIN price p ON l.P_ID = p.P_ID
			JOIN producttype t ON p.T_ID = t.T_ID
			JOIN zone z ON p.Z_ID = z.Z_ID
			WHERE r.M_ID = '$M_ID'");

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