Feature: Run Mutiple feature file
    Scenario: Run Environment file
    Given Run feature file "1_DBRestoreAndProcessStart.feature"

    Scenario: Run Environment feature file
    Given Run feature file "Backdated_payment_Case2.feature"