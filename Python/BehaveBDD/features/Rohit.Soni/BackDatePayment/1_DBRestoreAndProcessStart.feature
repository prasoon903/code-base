Feature: DBRestore and Process Up

#    Scenario: DBRestore
#      Given Restore Database
#      Then Upgrade Posting2.0
#
#      Scenario: Take DB backup
#        Given Take DB Backup
#
#    Scenario: Start CI AppServer
#      Given Start CI AppServer
#
#    Scenario: Start CITNP
#      Given Start CITNP

Scenario: Stop all processes
  Given Stop Processes

Scenario: DBRestore
  Given Restore Database with backup
  Then Set system to "2020-07-24" Date

#Scenario: Reset Tview date
#  Then Age system to "2020-07-25" Date

Scenario: Start CI AppServer
  Given Start CI AppServer

Scenario: Start CITNP
  Given Start CITNP

#    Scenario: Start CI APJOB
#      Given Start CI APJOB
#      Then Age system to "2021-08-01" Date
#    Scenario: Test Given
#      Given Test Given
#      Then Age system to "2020-07-25" Date



