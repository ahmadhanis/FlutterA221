<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$userid = $_POST['userid'];
  $prname= addslashes($_POST['prname']);
	$prdesc= addslashes($_POST['prdesc']);
	$prprice= $_POST['prprice'];
  $delivery= $_POST['delivery'];
  $qty= $_POST['qty'];
  $state= addslashes($_POST['state']);
  $local= addslashes($_POST['local']);
  $lat= $_POST['lat'];
  $lon= $_POST['lon'];
  $image= $_POST['image'];
	
	$sqlinsert = "INSERT INTO `tbl_products`(`user_id`, `product_name`, `product_desc`, `product_price`, `product_delivery`, `product_qty`, `product_state`, `product_local`, `product_lat`, `product_lng`) VALUES ('$userid','$prname','$prdesc',$prprice,$delivery,$qty,'$state','$local','$lat','$lon')";
	
  try {
		if ($conn->query($sqlinsert) === TRUE) {
			$decoded_string = base64_decode($image);
			$filename = mysqli_insert_id($conn);
			$path = '../assets/productimages/'.$filename.'.png';
			file_put_contents($path, $decoded_string);
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>