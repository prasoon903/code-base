Feature: Create Account

    Scenario: Create Account and Verify Account Number
        # Given Start CI AppServer
        # Given Take DB Backup
        Given Create Account 
            |JsonTag    |Value      |
            |ProductID  |7131       |
            |StoreName  |CookieStore|
            |AccountCreationDateTime | 20180101121212 |
            |CreditLimit | 5000 |
         When Verify API response is OK
         Then Verify Account Number in Database 
         And Save tag into variable
             |TagName        |VariableName      |
             |AccountNumber  |MyAccountnUmber   |
             |CardNumber     |MyCardNumber      |

    # Scenario: Create Secondary Card
    #     Given Create Secondary Card
    #         |JsonTag        |Value                  |
    #         |AccountNumber  |@MyAccountnUmber       |
    #     When Verify API response is OK

    Scenario: Post purchase 
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |4005            |
            |TransactionAmount|2000            |
            |TransactionTime  |20180102121212  |
            |TransactionPostTime  |20180102121212  |
        When Verify API response is OK
        #  Then Save tag into variable
        #  |TagName        |VariableName      |
        #  |Tranid         | @tr@tranidanid |

    Scenario: Age Account
        Given Age TestAccount
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |AgingDate         |20180302       |
        When Verify API response is OK     
         
    Scenario: Post Payment 
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |2102            |
            |TransactionAmount|600            |
            |TransactionTime  |20180202121212  |
            |TransactionPostTime  |20180303121212  |
        When Verify API response is OK
        Then Save tag into variable
            |TagName        |VariableName      |
            |TransactionID   | @tranid1 |
        
    
    
    Scenario: Post Payment 
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |2102            |
            |TransactionAmount|400            |
            |TransactionTime  |20180202121212  |
            |TransactionPostTime  |20180303121212  |
        When Verify API response is OK
            Then Verify Transaction in DB
            And Save tag into variable
            |TagName        |VariableName      |
            |TransactionID         | @tranid2 |
            # Then Verify Transaction in DB
    
    Scenario: Post Payment reversal
        Given Post Transaction
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
            |TranType         |2208            |
            |TransactionAmount|600            |
            |ReversalTargetTranID  |@tranid1  |
            |TransactionTime  |20180304121212  |
            |TransactionPostTime  |20180304121212  |
        When Verify API response is OK
        Then Verify Transaction in DB

        Given Get AccountSummary
            |JsonTag          |Value           |
            |AccountNumber    |@MyAccountnUmber|
        When Verify API response is OK
    #     Then Verify Transaction in DB
    #     #And Age system "2" days 
        
    # Scenario: Age Account
    #     Given Age TestAccount
    #         |JsonTag          |Value           |
    #         |AccountNumber    |@MyAccountnUmber|
    #         |AgingDate         |20180202            |
    #  When Verify API response is OK
    #     Then Verify Transaction in DB
    #     #And Age system "2" days 
            
    # Scenario: Post Payment 
    #     Given Post Transaction
    #         |JsonTag          |Value           |
    #         |AccountNumber    |@MyAccountnUmber|
    #         |TranType         |2102            |
    #         |TransactionAmount|500             | 
    #     When Verify API response is OK
    #     Then Verify Transaction in DB

    # Scenario: Post Manual Auth
    #     Given Post Manual Auth
    #         |JsonTag          |Value           |
    #         |AccountNumber    |@MyAccountnUmber|
    #         |CardNumber       |@MyCardNumber   |
    #     When Verify API response is OK
    #     Then Pause for "5" Second
    #     And Verify Transaction in DB
    
    # Scenario: Post ReatilAuth
    #     When Post ReatilAuth
    #         |JsonTag          |Value           |
    #         |AccountNumber    |@MyAccountnUmber|
    #     Then Verify API response is OK
    #     #Then Verify Transaction in DB

    # Scenario: perform statmenting 
    #     Then Age system "25" days 
        
        


    
