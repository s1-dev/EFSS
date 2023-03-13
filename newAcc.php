<html lang="en">
<head>
    <title>EFFS</title>
    <meta charset="utf-8">
    <meta name="EFFS"
    content="width=device-width", initial-scale="1.0">
    <link rel="stylesheet" href="./main.css">
</head>
<body>
    <h1>Directory Creation</h1>
    <p>Please fill in this form to create a directory</p>
    <hr>
    <form method="post">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="ttl"><b>Dir Time to Live</b></label>
    <input type="text" placeholder="Enter TTL in Hours" name="ttl" required> 
    <br> 
    <br>
    <label for="pw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password or 'np'" name="pw" required>
	
    <label for="pwc"><b>Repeat Password</b></label>
    <input type="password" placeholder="Repeat Password or 'np'" name="pwc" required>
    <br>
    <br>
    <button type="button" class="cancelbtn"><a href="./index.html">Return Home</a></button>
    <button type="submit" class="signupbtn">Create Directory</button>
</form>

    <p>Notes: Directory name/username must be only letters and will be converted to lowercase. In addition, 
    it can only be between 4 and 10 characters. Dir time to live must be an entry of a single whole 
    number in between 0 and 25 (non-inclusive). 

    If you wish to have your temporary directory <strong>NOT</strong> password protected, then type the two chars '<strong>np</strong>' for both password fields. 
    Otherwise, inputted passwords must
    satisify the following password complexity stipulations:</p>
    <ul>
	<li>Must be at least 8 and no more than 50 characters in length</li>
	<li>Must contain one uppercase letter</li>
	<li>Must contain one lowercase letter</li>
	<li>Must contain one numeric character</li>
	<li>Must contain one of the following symbols: '#', '%', '^', '&', '*'</li>
    </ul>


<?php
if ($_POST) {
   echo "<br>";
   $usern=$_POST['uname'];
   $ttl=$_POST['ttl'];
   $passw=$_POST['pw'];
   $check=$_POST['pwc'];
   $valid = True;  
   system("sudo ./scripts/checkDirCount.sh", $ret);
   if($ret == 1){
     echo "There are already 20 directories in use. Please wait until they expire or add files to existing dir<br>";
     $valid = False;
   }
   system("sudo ./scripts/checkAcc.sh $usern 0", $ret);
   if($ret == 1){
     $valid = False;
     echo "<br>";
   }
   if($passw != $check){
     echo "ERROR: Passwords do not match!";
     $valid = False;
   }
   else{
     $output = system("sudo ./scripts/checkAcc.sh $passw 1", $ret);
     if($ret == 1){
       $valid = False;
       echo "<br>";
     }
   }
   $output = system("sudo ./scripts/checkAcc.sh $ttl 2", $ret);
   if($ret == 1){
     $valid = False;
     echo "<br>";
   }

   if($valid == True){
     system("sudo ./scripts/createDir.sh $usern $passw $ttl", $ret);
     if($ret == 1){
      echo "ERROR: Dir not properly created try again.";
     }
     else{
      echo "Directory created! <br>";
      $un = strtolower($usern);
      echo "<button><a href='./ActiveFiles/$un/'>View New Dir</a></button>";
      echo "<button><a href='./upload.php'>Upload a File</a></button>";
    }
 
   }
}
?>

</body>
</html>
