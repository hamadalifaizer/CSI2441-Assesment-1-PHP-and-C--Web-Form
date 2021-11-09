<%@ Page Language ="C#" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<script runat="server">

    string yearOfGames, cityOfGames, commenceDate, endDate;

    string[][] dataValidation = new string[25][];
    ArrayList medalsByCountry = new ArrayList();

    // Get primary input details
    public void Get_InputDetails()
    {
        yearOfGames = Request.Form["YearOfGames"];
        cityOfGames = Request.Form["CityOfGames"];
        commenceDate = Request.Form["CommenceDate"];
        endDate = Request.Form["EndDate"];

    }

    // Primary input details validation
    public int Primary_InputValidation()
    {
        
        int errorcode = 0;

        if (Request.Form["YearOfGames"] == "")
        {
            Response.Write("<p style = 'color:black'> The Year of games cannot be left blank");
            errorcode = 1;
        }
        else if(!Regex.IsMatch(Request.Form["YearOfGames"], @"^\d{4}$"))
        {
            Response.Write("<p style = 'color:black'> The Year of games should contain 4 digitis ");
            errorcode = 1;
        }

        if (Request.Form["CityOfGames"] == "")
        {
            Response.Write("<p style = 'color:black'> The city of games cannot be left blank");
            errorcode = 1;
        }
        else if(!Regex.IsMatch(Request.Form["CityOfGames"], @"^[a-zA-Z]+$"))
        {
            Response.Write("<p style = 'color:black'> The city of games can only contain letters");
            errorcode = 1;
        }

        if (Request.Form["CommenceDate"] == "")
        {
            Response.Write("<p style = 'color:black'> The commence date cannot be left blank");
            errorcode = 1;
        }
        else if(!Regex.IsMatch(Request.Form["CommenceDate"], @"^(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$" ))
        {
            Response.Write("<p style = 'color:black'> The commence date must be in dd/mm/yyyy format");
            errorcode = 1;
        }

        if (Request.Form["EndDate"] == "")
        {
            Response.Write("<p style = 'color:black'> The end date cannot be left blank");
            errorcode = 1;
        }
        else if(!Regex.IsMatch(Request.Form["EndDate"], @"^(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$" ))
        {
            Response.Write("<p style = 'color:black'> The end date must be in dd/mm/yyyy format");
            errorcode = 1;
        }

        if (errorcode == 1)
        {
            return errorcode;
        }

        DateTime commencingDate = Convert.ToDateTime(Request.Form["CommenceDate"]);
        DateTime endingDate = Convert.ToDateTime(Request.Form["EndDate"]);

        TimeSpan difference = endingDate.Subtract(commencingDate);
        if (difference.Days < 0)
        {
            Response.Write("<p style = 'color:black'> The commence date and end date range is invalid");
            errorcode = 1;
        }

        return errorcode;
    }


    // Table input validation
    public int Table_InputValidation()
    {
        int errorcode1 = 0;
        int row = 0;
        int tempvar3 = 0;
        int tempvar5 = 0;
        int tempvar4 = 0;

        List<string> errors = new List<string>();

        for (int i = 1; i <= 25; i++)
        {
            if ((Request.Form["CompName_R_" + i] != "") || (Request.Form["MedalWon_R_" + i] != "") || (Request.Form["WorldRecord_R_" + i] != ""))
            {
                if (Request.Form["CompName_R_" + i] == "")
                {
                    errors.Add("<p style = 'color:black'> The competitor name cannot be left blank");
                    errorcode1 = 1;
                }
                else if (int.TryParse(Request.Form["CompName_R_" + i], out tempvar3))
                {
                    errors.Add("<p style = 'color:black'> The Competitor Name can only contain letters");
                    errorcode1 = 1;
                }
                else
                {
                    if (Request.Form["CompName_R_" + i].Length < 5)
                    {
                        errors.Add("<p style = 'color:black'> The competitor name should be more than 5 letters");
                        errorcode1 = 1;
                    }

                }

                if (Request.Form["MedalWon_R_" + i] == "")
                {
                    errors.Add("<p style = 'color:black'> fill the Medal Won in the row number: " + i);
                    errorcode1 = 1;
                }
                else if (int.TryParse(Request.Form["MedalWon_R_" + i], out tempvar4))
                {
                    errors.Add("<p style = 'color:black'> The Won Medal should not consists any Numerics");
                    errorcode1 = 1;
                }
                else
                {
                    if (!(Request.Form["MedalWon_R_" + i].Equals("G") || Request.Form["MedalWon_R_" + i].Equals("S") || Request.Form["MedalWon_R_" + i].Equals("B")))
                    {
                        errors.Add("<p style = 'color:black'> The Medal won should either be G, S, B ");
                        errorcode1 = 1;
                    }

                }

                if (Request.Form["WorldRecord_R_" + i] == "")
                {
                    errors.Add("<p style = 'color:black'> fill the World Record in the row number: " + i);
                    errorcode1 = 1;
                }
                else if (int.TryParse(Request.Form["WorldRecord_R_" + i], out  tempvar5))
                {
                    errors.Add("<p style = 'color:black'> The World Record should not contain any numbers");
                    errorcode1 = 1;
                }
                else
                {
                    if (!(Request.Form["WorldRecord_R_" + i].Equals("Y") || Request.Form["WorldRecord_R_" + i].Equals("N")))
                    {
                        errors.Add("<p style = 'color:black'> The World Record should either be Y or N");
                        errorcode1 = 1;
                    }

                }
            }
            else if ((Request.Form["CompName_R_" + i] == "") && (Request.Form["MedalWon_R_" + i] == "") && (Request.Form["WorldRecord_R_" + i] == ""))
            {
                row++;
            }
        }


        if (row == 25)
        {
            errors = new List<string>();
            errors.Add("<p style = 'color:black'> No Records are found in the table");
            errorcode1 = 1;
        }

        foreach (string item in errors)
        {
            Response.Write(item);
        }

        return errorcode1;
    }

    //Setting the Table Data into an Array and Displaying the output of Countries with their Medal Count and the World Record Athletes
    public void Read_TableDetails()
    {
        for (int i =1; i <= 25; i++)
        {
            if ((Request.Form["CompName_R_" + i].Trim() != "") || (Request.Form["MedalWon_R_" + i].Trim() != "") || (Request.Form["WorldRecord_R_" + i].Trim() != ""))
            {
                string compName = Request.Form["CompName_R_"+i];
                string countryList = Request.Form["CountryList_R_" + i];
                string eventList = Request.Form["Event_R_" + i];
                string medalWon = Request.Form["MedalWon_R_" + i];
                string worldRecord = Request.Form["WorldRecord_R_" + i];
                string[] tableInput = new string[] { compName, countryList, eventList, medalWon, worldRecord };
                dataValidation[i - 1] = tableInput;

            }
        }

        List<string> countries = new List<string>();

        foreach (string[] worldRecord in dataValidation)
        {
            if (worldRecord != null && worldRecord[0] != "")
            {
                string countryList = worldRecord[1];
                var medalWon = worldRecord[3];
                int item = 0, index = -1, modify = -1;
                foreach (ArrayList mentioned in medalsByCountry)
                {
                    index++;
                    if ((string)mentioned[0] == countryList)
                    {
                        item = 1;
                        modify = index;
                    }
                }

                if (item == 0)
                {
                    countries.Add(countryList);

                    if (medalWon == "G")
                    {
                        medalsByCountry.Add(new ArrayList { countryList, 1, 0, 0, 1 });
                    }
                    else if (medalWon == "S")
                    {
                        medalsByCountry.Add(new ArrayList { countryList, 0, 1, 0, 1 });
                    }
                    else if (medalWon == "B")
                    {
                        medalsByCountry.Add(new ArrayList { countryList, 0, 0, 1, 1 });
                    }
                }
                else
                {
                    if (medalWon == "G")
                    {
                        int goldMedal = (int)((ArrayList)medalsByCountry[modify])[1];
                        goldMedal++;
                        ((ArrayList)medalsByCountry[modify])[1] = goldMedal;
                    }
                    else if (medalWon == "S")
                    {
                        int silverMedal = (int)((ArrayList)medalsByCountry[modify])[2];
                        silverMedal++;
                        ((ArrayList)medalsByCountry[modify])[2] = silverMedal;
                    }
                    else if (medalWon == "B")
                    {
                        int bronzeMedal = (int)((ArrayList)medalsByCountry[modify])[3];
                        bronzeMedal++;
                        ((ArrayList)medalsByCountry[modify])[3] = bronzeMedal;
                    }
                    var total = (int)((ArrayList)medalsByCountry[modify])[4];
                    total++;
                    ((ArrayList)medalsByCountry[modify])[4] = total;

                }
            }
        }





        countries.Sort();
        countries.Reverse();


        //Displaying the outputs
        Response.Write("<h2> Total Medals won by each Country </h2>");
        Response.Write("<table>");
        Response.Write("<table width = '750' border = '2.0'>");
        Response.Write("<tr>");
        Response.Write("<td> Country </td>");
        Response.Write("<td> Place </td>");
        Response.Write("<td> Gold Medals Won </td>");
        Response.Write("<td> Silver Medals Won </td>");
        Response.Write("<td> Bronze Medals Won </td>");
        Response.Write("<td> Total Medals Won </td>");
        Response.Write("</tr>");


        int place = 0;

        foreach (string country in countries)
        {
            ArrayList countryAndMedals = new ArrayList();
            foreach (ArrayList countryAndMedal in medalsByCountry)
            {
                if (countryAndMedal[0].Equals(country))
                {
                    place++;
                    countryAndMedals = countryAndMedal;
                    break;
                }
            }



            Response.Write("<tr>");
            Response.Write("<td align = 'center'>" + (string)countryAndMedals[0] + "</td>");
            Response.Write("<td align = 'center'>" + place + "</td>");
            Response.Write("<td align = 'center'>" + (int)countryAndMedals[1] + "</td>");
            Response.Write("<td align = 'center'>" + (int)countryAndMedals[2] + "</td>");
            Response.Write("<td align = 'center'>" + (int)countryAndMedals[3] + "</td>");
            Response.Write("<td align = 'center'>" + (int)countryAndMedals[4] + "</td>");
            Response.Write("</tr>");
        }



        Response.Write("</table>");

        Response.Write("<h3> World Record Athletes </h3>");
        Response.Write("<table>");
        Response.Write("<table width = '500' border = '2.0'>");
        Response.Write("<tr>");
        Response.Write("<td> World Record Athlete </td>");
        Response.Write("<td> Event </td>");
        Response.Write("</tr>");

        foreach(string[] tableInput in dataValidation)
        {
            if (tableInput != null && tableInput[4] == "Y")
            {
                Response.Write("<tr>");
                Response.Write("<td align = 'center'>" + tableInput[0] + "</td>");
                Response.Write("<td align = 'center'>" + tableInput[2] + "</td>");
                Response.Write("</tr>");
            }
        }
        Response.Write("</table>");
    }

</script>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Olympic Score Analyser</title>
</head>
<body>
    <%
        int errorcode = Primary_InputValidation();
        if (errorcode == 0)
        {
            Get_InputDetails();
            int error = Table_InputValidation();
            if (error == 0)
            {
                Read_TableDetails();
            }
        }
            %>
</body>
</html>