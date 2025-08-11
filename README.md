# Home Assignment

You will be required to write unit tests and automated tests for a payment application to demonstrate your skills. 

# Application information 

It’s an small microservice that validates provided Credit Card data and returns either an error or type of credit card application. 

# API Requirements 

API that validates credit card data. 

Input parameters: Card owner, Credit Card number, issue date and CVC. 

Logic should verify that all fields are provided, card owner does not have credit card information, credit card is not expired, number is valid for specified credit card type, CVC is valid for specified credit card type. 

API should return credit card type in case of success: Master Card, Visa or American Express. 

API should return all validation errors in case of failure. 


# Technical Requirements 

 - Write unit tests that covers 80% of application 
 - Write integration tests (preferably using Reqnroll framework) 
 - As a bonus: 
    - Create a pipeline where unit tests and integration tests are running with help of Docker. 
    - Produce tests execution results. 

# Running the  application 

1. Fork the repository
2. Clone the repository on your local machine 
3. Compile and Run application Visual Studio 2022.

# Set Up

1. This project contain CardValidation.Tests - Unit & integration tests
2. **Docker Compose** setup for running the API and automated tests in containers

# Prerequisites needed for execution

1. .NET 8 SDK installed locally for executing in local.
    Download link - https://dotnet.microsoft.com/en-us/download/dotnet/8.0
2. Docker Desktop installed.  
   Download link - https://www.docker.com/products/docker-desktop/

# HTTPS & Certificate Setup
1. The CardValidation API is running over HTTPS inside Docker for integration Testing.\
   since it is running in HTTPS self-signed development certificate is generated and trusted inside the container at build time.4
   Used Openssl to generate the certoficate and configured ASP.NET cre to use the certificate.
2. The TEST_API_URL environment variable is set to the HTTPS endpoint (https://cardvalidation-api:7135) to avoid modifying the original application code while         enabling secure HTTPS communication in Docker.

# How to run
1. clone the repository using the link
2. Create a folder and open
3. Build the project and run using docker compose- docker compose up --build
4. stop and clean up - docker compose down

# Results
1. Check the results in the app/test-results(html file opens in browser and a .trx file can be opened in the Visual studio)
