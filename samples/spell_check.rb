# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_spellcheck'

include Azure::CognitiveServices::SpellCheck::V1_0::Models

class SpellCheckClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @spell_check_latest_profile_client_obj =
        Azure::SpellCheck::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_spell_check
    puts "\t\t\tCognitive Services Spell Check Scenarios"
    puts "\t\t\t========================================"
    puts

    simple_spell_check
    puts
    sleep(5)
  end

  private
  def simple_spell_check
    puts 'Scenario I - Simple Spell Check'
    puts '==============================='
    puts 'This will do a search for a misspelled query and parse the response'

    result = @spell_check_latest_profile_client_obj.spell_checker(
        'Bill Gatos', mode: 'proof')

    puts "Correction for Query: 'Bill Gatos'"

    if (!result.flagged_tokens.nil? && result.flagged_tokens.length > 0)
      first_spell_check_result = result.flagged_tokens[0];
      if(!first_spell_check_result.nil?)
        puts "SpellCheck Results: #{result.flagged_tokens.length}"
        puts "First SpellCheck Result token: #{first_spell_check_result.token}"
        puts "First SpellCheck Result Type: #{first_spell_check_result.type}"
        puts "First SpellCheck Result Suggestion Count: #{first_spell_check_result.suggestions.length}"

        suggestions = first_spell_check_result.suggestions;

        if (!suggestions.nil? && suggestions.length > 0)
          first_suggestion = suggestions[0];
          puts "First SpellCheck Suggestion Score: #{first_suggestion.score}"
          puts "First SpellCheck Suggestion : #{first_suggestion.suggestion}"
        end
      else
        puts "Couldn't get any Spell check results!"
      end
    else
      puts "Couldn't see any SpellCheck results.."
    end
  end
end
