<html lang="en">
<head>
    <title>EFFS</title>
    <meta charset="utf-8">
    <meta name="EFFS"
    content="width=device-width", initial-scale="1.0">
    <link rel="stylesheet" href="./main.css">
</head>
<body>
    <h1>Upload Files</h1>
    <p>Use this form to login and upload files</p>
    <hr>

<form action="" method="post" enctype="multipart/form-data">
<label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <br> 
    <br>
    <label for="pw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password or 'np'" name="pw" required>
    <br>
    <br>

<p>Select File You Want to Upload:
<input type="file" name="file" />
<input type="submit" value="Upload File" />

</p>
</form>
<button type="button" class="cancelbtn"><a href="./index.html">Return Home</a></button>

<?php
   if($_POST){
	echo "<br>";
	echo "<br>";
	$usern=$_POST['uname'];
  	$passw=$_POST['pw'];
	$un = strtolower($usern);
	system("sudo /var/www/html/scripts/checkCreds.sh $usern $passw", $ret);
	if($ret != 0){
		echo "Username or password incorrect. File was not uploaded.<br>";
                exit();
	}
	$ftmp = $_FILES["file"]["tmp_name"];
	$fname = $_FILES["file"]["name"];
	$fsize = $_FILES["file"]["size"];
	if(file_exists("/var/www/html/ActiveFiles/$un/$fname")){
		echo "A file with this name already exists in your dir. Please change the name of the file you're trying to upload.<br>";
		exit();
	}
	$valid = True;	
	if($fsize > 2000000){
		echo "ERROR: File size can't be greater than 2MB<br>";
		$valid = False;
	}
	if($valid == True){
	move_uploaded_file($ftmp, "/var/www/html/uploads/$fname");
	system("sudo /var/www/html/scripts/sanData.sh $fname $un", $ret);
	if($ret == 1){
		echo "<br>File was not uploaded. Please try again.<br>";
	}else{
		echo "<br>File successfully uploaded!<br>";
		echo "<button><a href='./ActiveFiles/$un/'>View Your Dir</a></button>";
	}
   }
}
?>

</body>
</html>
