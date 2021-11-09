    <html>
    <head>
    <title> PHP Script </title>
    </head>
    <body>
    <h1>PHP Script for Olympic Form </h1>
    <tr>
    <th></th>
    <th></th>
    </tr>
<?php
error_reporting(0);
if (isset($_POST["button"]))
{
    $YearOfGames = $_POST['YearOfGames'];
    $CityOfGames = $_POST['CityOfGames'];
    $CommenceDate = $_POST['CommenceDate'];
    $EndDate = $_POST['EndDate'];
    if (strlen($YearOfGames) != 4)
    {
        print_r('<label for="inputText3" class="col-form-label"> <font color="#F80004">The Year of Games cannot not be left blank and should only consist four Numerics!</font></label>');
        return;
    }
    $pattern = "/^[a-zA-Z]+$/";
    if (strlen($CityOfGames) == 0 || preg_match($pattern, $CityOfGames) == 0)
    {
        print_r('<label for="inputText3" class="col-form-label"> <font color="#F80004">The City of Games cannot not be left blank and should only consist Text.</font></label>');
        return;
    }
    $pattern = "/^(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$/";

    if (strlen($CommenceDate) == 0 || !preg_match("/^(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$/", $CommenceDate))
    {
        print_r('<label for="inputText3" class="col-form-label"> <font color="#F80004">The Commence Date cannot not be left blank and should be in Standard Format.</font></label>');
        return;
    }

    if (strlen($EndDate) == 0 || !preg_match("/^(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$/", $EndDate))
    {
        print_r('<label for="inputText3" class="col-form-label"> <font color="#F80004">The End Date cannot not be left blank and should be in Standard Format.</font></label>');
        return;
    }
    $date1 = strtr($_REQUEST['CommenceDate'], '/', '-');
    $date2 = strtr($_REQUEST['EndDate'], '/', '-');
    $cDate = date('Y-m-d', strtotime($date1));
    $eDate = date('Y-m-d', strtotime($date2));
    if ($cDate >= $eDate)
    {
        print_r('<label for="inputText3" class="col-form-label"> <font color="#F80004">The Input Date Ranges are invalid.</font></label>');
        return;
    }

    $records = array();
    $worldRecords = array();
    $CompName_R_1 = $_POST['CompName_R_1'];
    $CountryList_R_1 = $_POST['CountryList_R_1'];
    $Event_R_1 = $_POST['Event_R_1'];
    $MedalWon_R_1 = $_POST['MedalWon_R_1'];
    $WorldRecord_R_1 = $_POST['WorldRecord_R_1'];

    if (!checkRowValiation($CompName_R_1, $MedalWon_R_1, $WorldRecord_R_1))
    {
        return;
    }
    else
    {

        $records = calculateMedal($records, $CountryList_R_1, $MedalWon_R_1);
        if ($WorldRecord_R_1 == "Y")
        {
            $wrecord = $CompName_R_1 . "," . $Event_R_1;
            array_push($worldRecords, $wrecord);

        }
    }

    for ($x = 2;$x <= 24;$x++)
    {

        $CompName_R_1 = $_POST['CompName_R_' . $x];
        $CountryList_R_1 = $_POST['CountryList_R_' . $x];
        $Event_R_1 = $_POST['Event_R_' . $x];
        $MedalWon_R_1 = $_POST['MedalWon_R_' . $x];
        $WorldRecord_R_1 = $_POST['WorldRecord_R_' . $x];

        if (($CompName_R_1 == ""))
        {
			  if (($MedalWon_R_1 == ""))
        	{
				 if (($WorldRecord_R_1 == ""))
        		{
					break;
					
				}
			}
			             
        }

        if (!checkRowValiation($CompName_R_1, $MedalWon_R_1, $WorldRecord_R_1))
        {
            return;
        }
        else
        {

            $records = calculateMedal($records, $CountryList_R_1, $MedalWon_R_1);

            if ($WorldRecord_R_1 == "Y")
            {
                $wrecord = $CompName_R_1 . "," . $Event_R_1;
                array_push($worldRecords, $wrecord);

            }

        }

    }
    echo "<h2>Medals won by Countries</h2>";
    rsort($records);
    $count = 0;
    $ptotal = 0;
    foreach ($records as $item)
    {

        $tempTotal = explode(",", $item) [0];
        $G = explode(":", explode(",", $item) [2]) [1];
        $S = explode(":", explode(",", $item) [3]) [1];
        $B = explode(":", explode(",", $item) [4]) [1];

        if ($tempTotal != $ptotal)
        {
            $count++;
        }
        $ii = $count . explode(",", $item) [1] . " Gold: " . $G . " Silver: " . $S . " Bronze: " . $B . " Total: " . explode(",", $item) [0];
        if ($tempTotal == $ptotal)
        {
            $count = $count + 1;
        }
        echo "<table border='1'
        <tr>
        <th>$ii</th>
        </tr>
        </table>";

    }
    echo "<table border='1'
    <tr>
    <h2>World Record Athletes</h2>
    </tr>";
    
    foreach ($worldRecords as $item)
    {
        $wrecord = "Competitor Name: " . explode(",", $item) [0];
        $wevent = "Event: " . explode(",", $item) [1];

        echo "<table border='1'
        <tr>
        <td>$wrecord</td><br>  </br><td>$wevent</td>
        </tr>
        </table>";

    }

}

function calculateMedal($records, $CountryList, $Medal)
{

    $or = $records;
    $S = 0;
    $G = 0;
    $B = 0;
    $index = - 1;
    $count = 0;
    $total = 0;
    foreach ($records as $item)
    {
        // $items = explode(',',$item)item.Split(',');
        if (explode(",", $item) [1] == $CountryList)
        {

            $index = $count;
            $G = explode(":", explode(",", $item) [2]) [1];
            $S = explode(":", explode(",", $item) [3]) [1];
            $B = explode(":", explode(",", $item) [4]) [1];
            break;

        }
        $count++;
    }

    if ($Medal == "G")
    {
        $G++;
    }
    else if ($Medal == "S")
    {
        $S++;
    }
    else if ($Medal == "B")
    {
        $B++;
    }
    $total = $G + $S + $B;
    $record = $total . "," . $CountryList . ",G:" . $G . ",S:" . $S . ",B:" . $B;

    if ($index != - 1)
    {
        array_splice($records, $index, 1);
        array_push($records, $record);
        
    }
    else
    {

        array_push($records, $record);
        
    }

    return $records;
}


function checkRowValiation($compName, $Medal, $Worldrec)
{
    $returnValue = true;

    $NamePattern = "/^[a-zA-Z]+$/";
    if (strlen($compName) < 5 || preg_match($NamePattern, $compName) == 0)
    {
        $returnValue = false;
        echo "The Competitor Name cannot not be left Blank and should be a text with more than five characters.";
    }
    if (strlen($Medal) !== 1 || !(strcmp($Medal, "G") === 0 || strcmp($Medal, "S") === 0 || strcmp($Medal, "B") === 0))
    {
        $returnValue = false;
        echo "The Medal Won cannot not be left Blank and should be either G, S or B.";
    }
    if (strlen($Worldrec) != 1 || !($Worldrec == "Y" || $Worldrec == "N"))
    {
        $returnValue = false;
        echo "The World Record cannot not be left Blank and should be either Y or N.";
    }

    return $returnValue;
}

?>
</table>
  </form>
</p>
</body>
</html>