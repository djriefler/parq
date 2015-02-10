<?php

      /*   Connection to bluehost database/website   */  
    $dbh=mysql_connect ("localhost", "cpUsername_dbUsername", "password")
        or die ('I cannot connect to the database.');
    mysql_select_db ("cpUsername_dbName");
        or die("Could not find database: " . mysql_error());
?>