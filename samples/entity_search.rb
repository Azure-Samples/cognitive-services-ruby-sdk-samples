# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_entitysearch'

class EntitySearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @entity_search_latest_profile_client_obj =
        Azure::EntitySearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_entity_search
    puts "\t\t\tCognitive Services Entity Search Scenarios"
    puts "\t\t\t=========================================="
    puts

    search_single_entity
    puts
    sleep(5)

    search_disambiguation_results
    puts
    sleep(5)

    search_entity_url
    puts
    sleep(5)

    search_list_urls
    puts
    sleep(5)
  end

  private
  def search_single_entity
    puts 'Scenario I - Single Entity Search'
    puts '================================='
    puts 'This will look up a single entity (tom cruise) and print out a short description about them.'

    search_results = @entity_search_latest_profile_client_obj.entities_operations.search('tom cruise')

    if(!search_results.entities.nil? && !search_results.entities.value.nil? && search_results.entities.value.length > 0)
      main_entity_found = false

      search_results.entities.value.each do |seach_result|
        if(seach_result.entity_presentation_info.entity_scenario == 'DominantEntity')
          main_entity_found = true
          puts "Searched for 'Tom Cruise' and found a dominant entity with this description:"
          puts seach_result.description
        end
      end

      if main_entity_found == false
        puts "Couldn't find main entity tom cruise!"
      end
    else
      puts "Couldn't see any data..."
    end


  end

  def search_disambiguation_results
    puts 'Scenario II - Disambiguation Results Search'
    puts '==========================================='
    puts 'This will handle disambiguation results for an ambiguous query (harry potter).'

    search_results = @entity_search_latest_profile_client_obj.entities_operations.search('harry potter')

    if(!search_results.entities.nil? && !search_results.entities.value.nil? && search_results.entities.value.length > 0)
      main_entity_found = false

      search_results.entities.value.each do |seach_result|
        if(seach_result.entity_presentation_info.entity_scenario == 'DominantEntity')
          main_entity_found = true
          puts "Searched for 'harry potter' and found a dominant entity with type hint: #{seach_result.entity_presentation_info.entity_type_hints}:"
          puts seach_result.description
        end
      end

      if main_entity_found == false
        puts "Couldn't find main entity tom cruise!"
      end

      disambiguation_entity_found = false
      disambiguity_entity_string = ''

      search_results.entities.value.each do |seach_result|
        if(seach_result.entity_presentation_info.entity_scenario == 'DisambiguationItem')
          disambiguation_entity_found = true
          if disambiguity_entity_string.length != 0
            disambiguity_entity_string += ", or "
          end
          disambiguity_entity_string += " #{seach_result.name} the #{seach_result.entity_presentation_info.entity_type_display_hint}."
        end
      end

      if disambiguation_entity_found == true
        puts "This query is pretty ambiguous and can be referring to multiple things.Did you mean one of these: #{disambiguity_entity_string} ?"
      else
        puts "We didn't find any disambiguation items for harry potter, so we must be certain what you're talking about!"
      end

    else
      puts "Couldn't see any data..."
    end
  end

  def search_entity_url
    puts 'Scenario III - Entity Search (Url)'
    puts '=================================='
    puts 'This will look up a single restaurant (john howie bellevue) and print out its url.'

    search_results = @entity_search_latest_profile_client_obj.entities_operations.search('john howie bellevue wa')

    if(!search_results.places.nil? && !search_results.places.value.nil? && search_results.places.value.length > 0)
      puts "Searched for 'John Howie Bellevue' and found a restaurant with this url: #{search_results.places.value[0].url}"
    else
      puts "Couldn't see any data..."
    end

  end

  def search_list_urls
    puts 'Scenario IV - Entity Search List & Urls'
    puts '======================================='
    puts 'This will look up a list of restaurants (seattle restaurants) and present their names and urls.'

    search_results = @entity_search_latest_profile_client_obj.entities_operations.search('seattle restaurants')

    if(!search_results.places.nil? && !search_results.places.value.nil? && search_results.places.value.length > 0)
      list_found = false
      list_string = ''
      search_results.places.value.each do |search_result|
        if(search_result.entity_presentation_info.entity_scenario == 'ListItem')
          list_found = true
          list_string += "'#{search_result.name}, #{search_result.web_search_url}'  "
        end
      end

      if list_found == true
        puts "Ok, we found these places: #{list_string}"
      else
        puts "Couldn't find any relevant results for 'seattle restaurants'"
      end

    else
      puts "Couldn't see any data..."
    end
  end
end
