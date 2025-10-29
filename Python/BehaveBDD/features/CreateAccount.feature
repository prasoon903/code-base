Feature: Create Account 
    
    Scenario: Create Account and Verify Account Number
        Given Start CI AppServer
        Given Take DB Backup
        
        Given Create Account 
            |JsonTag    |Value      |
            |ProductID  |7131       |
            |StoreName  |CookieStore|
        When Verify API response is OK
        Then Verify Account Number in Database 
        And Save tag into variable
            |TagName        |VariableName      |
            |AccountNumber  |MyAccountnUmber   |
            |CardNumber     |MyCardNumber      |

    Scenario: Create Secondary Card
        Given Create Secondary Card
            |JsonTag        |Value                  |
            |AccountNumber  |@MyAccountnUmber       |
        When Verify API response is OK 

    Scenario: Post purchase 
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |4005            |
            |TransactionAmount|2000            |
            
        When Verify API response is OK
        Then Verify Transaction in DB
        #And Age system "2" days 
        
            
    Scenario: Post Payment 
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |2102            |
            |TransactionAmount|500             | 
        When Verify API response is OK
        Then Verify Transaction in DB

    Scenario: Post Manual Auth
        Given Post Manual Auth
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |CardNumber       |@MyCardNumber   |
        When Verify API response is OK
        Then Pause for "5" Second
        And Verify Transaction in DB
    
    Scenario: Post ReatilAuth
        When Post ReatilAuth
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
        Then Verify API response is OK
        #Then Verify Transaction in DB

    Scenario: perform statmenting 
        Then Age system "25" days 
        
        


    
