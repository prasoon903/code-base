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
#  Given Restore Database
  Then Set system to "2018-02-06" Date

Scenario: Start CI AppServer
  Given Start CI AppServer

Scenario: Start CITNP
  Given Start CITNP

#Scenario: Start API JOB
#  Given Start CI APIJOB


