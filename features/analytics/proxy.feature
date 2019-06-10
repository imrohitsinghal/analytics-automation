@setup_mitm_proxy
Feature: Test analytics functionality
  As a potential candidate
  I want to make sure Thoughtworks analytics functionality is working properly
  So that i can assure all data is correctly flowing into google analytics
#
#  Background: Login to the system and enable Mario
#    Given I login to the "France" "PP"

#  @create_marketplace_order_default
  Scenario: Open thoughtworks website and check the analytics
    When I open the thoughtworks website

  Scenario: Open thoughtworks website second time and check the analytics
    When I open the thoughtworks website