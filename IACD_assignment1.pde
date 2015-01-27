/* This assignments was created voor the Interactive Art & Computational Design
 course as part of the CMU curriculum. The teacher was Golan Levin, with the help of
 David Newbury and Dan Wilco. This assignment is created with the help of Temboo. It
 is based on their example for analyzing similar artists from lastFM.
 
 The goal (next to the educational goal) of this program is the scrape data and
 prepare it for visualization. This specific program scrapes data from LastFM.
 Starting out with the famous band The Eagles the program gets the 5 most similar
 bands (according to lastFM) and lists them together with their similarity factor.
 After this it is done for the five artists found this is a continuing process
 till 1000 artists have been found (greating a set of 1000 comparisons, which 
 results in 2281 different bands (not all were further analyzed) with a factor
 
 The results are exported in cvs format
 
 The program is created by Thomas Langerak
 */



import com.temboo.core.*;
import com.temboo.Library.LastFm.Artist.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("tlangerak", "IACD", "temboo");
String artist_input;
String amountReturned = "5";//amount of similar artists looked for.
String[][] artist = new String[10000][6]; //array for new found artists and their top 5 corresponding. 
int numberOfArtists = 0;//to update string length

Table table;//table for exporting

void setup() {
  //table setup
  table = new Table(); 
  table.addColumn("name");
  //set first artist
  artist[0][0]="the Eagles";
  // Run the GetSimilar Choreo function
  for (int j = 0; j < 1000; j++) {
    artist_input = artist[j][0]; 
    runGetSimilarChoreo(artist_input, j);
  }
  TableRow row = table.getRow(0); //setting the first artist in the table
  row.setString("name", artist[0][0]);
  //for debugging 
//  for (int j =0; j<numberOfArtists; j++) {
//    for (int i=0; i < 6; i++) {      
//      print(artist[j][i]);
//    }
//    println();
//  }
  saveTable(table, "data/IACD.csv"); //after everyting is done export table. 
}

void runGetSimilarChoreo(String currentArtist, int x) { //main function
  delay(250);//be polite for the server
  println(x);
  GetSimilar getSimilarChoreo = new GetSimilar(session); // Create the Choreo object using your Temboo session
  // Set inputs
  getSimilarChoreo.setAPIKey("API");//APIkey
  getSimilarChoreo.setArtist(currentArtist); //set artist
  getSimilarChoreo.setLimit(amountReturned); //set the amount returned

    //only get the necessary things
  getSimilarChoreo.addOutputFilter("name", "//artist/name", "Response");  //the name
  getSimilarChoreo.addOutputFilter("match", "//artist/match", "Response");//how well they match
  GetSimilarResultSet getSimilarResults = getSimilarChoreo.run();// Run the Choreo and store the results

  for (int i = 0; i < getSimilarResults.getResultList ("name").size(); i++) {     
    artist[x][i+1]=getSimilarResults.getResultList("name").getString(i)+"|"+getSimilarResults.getResultList("match").getString(i);//save in array (for debugging)
    TableRow row = table.getRow(x); //get correct row to enter names
    row.setString("Related"+i, getSimilarResults.getResultList("name").getString(i)); //5 corresponding artists and their factor put in table
    row.setString("Match"+i, getSimilarResults.getResultList("match").getString(i)); 

    if (!artistCheck(getSimilarResults.getResultList("name").getString(i))) { //check whether the artist has been previously listed
      numberOfArtists++; //add 1 to arraylength
      artist[numberOfArtists][0]=getSimilarResults.getResultList("name").getString(i);//make new array entry with new name
      TableRow newRow = table.addRow();  //add new row for new artist
      newRow.setString("name", getSimilarResults.getResultList("name").getString(i)); //enter name
    } else {
      println("Alread exists"); //debugging
    }
  }
}

boolean artistCheck(String c) { //check whether artist is already in table. 

  for (int n=0; n<=numberOfArtists; n++) {
//    println("is " + c + " the same as " + artist[n][0] + "?"); //debugging
    if (c.equals(artist[n][0])) { //return and break if same artist is found. 
      return true;
    }
  }
  return false; //after complete array is checked without similar artist return false
}

