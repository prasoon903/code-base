Feature: perform auth related scenarios 

    Scenario: Perform Auth
        Given Make bin file entry in txt file
        When  start "sim.bat"
        Then verify entry in CoreAuthTransaction
    