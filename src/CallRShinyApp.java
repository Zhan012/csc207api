import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class CallRShinyApp {
    public static void main(String[] args) {
        try {
            // Create a BufferedReader to read from stdio
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

            // Prompt the user for input
            System.out.print("Enter Y Value: ");
            String yValue = reader.readLine();

            System.out.print("Enter X Value (comma-separated): ");
            String xValue = reader.readLine();

            // Define the API endpoint URL
            String apiUrl = "http://127.0.0.1:2763?y=" + yValue + "&x=" + xValue;

            // Create a method to invoke the R Shiny API
            String response = invokeRShinyAPI(apiUrl);

            // Display the API response or error message
            System.out.println("API Response: " + response);
        } catch (IOException e) {
            // Handle any IOException that occurs
            e.printStackTrace();
        }
    }

    // Method to invoke the R Shiny API
    public static String invokeRShinyAPI(String apiUrl) throws IOException {
        try {
            // Create a URL object and open a connection
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // Set the request method (e.g., GET)
            conn.setRequestMethod("GET");

            // Get the response code
            int responseCode = conn.getResponseCode();

            // Read the response data
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Handle and process the response data
            if (responseCode == 200) {
                return response.toString();
            } else {
                // Handle error response
                return "Error: API Request failed with response code " + responseCode;
            }
        } catch (IOException e) {
            // Handle any IOException that occurs
            throw e;
        }
    }
}


