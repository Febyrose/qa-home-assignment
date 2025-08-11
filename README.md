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
