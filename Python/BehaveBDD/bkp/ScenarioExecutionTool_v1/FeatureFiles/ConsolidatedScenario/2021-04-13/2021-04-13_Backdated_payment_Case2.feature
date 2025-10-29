Feature: Verify delinquency should not impact when two payments of same amount was made and
  one would get reversed on next cycle.Also verify the distribution after payment reversal.
  Background:
    Given Run as "new"

  Scenario: Post purchase and Cash Transaction
    Given Post purchase of $"285" by trancode "4005"
    Then Wait for "60" seconds
    Given Post cash purchase of $"300" by trancode "3001" and "13748"
