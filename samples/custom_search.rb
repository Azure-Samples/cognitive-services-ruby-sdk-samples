# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_customsearch'

class CustomSearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @custom_search_latest_profile_client_obj =
        Azure::CustomSearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_custom_search(custom_config)
    puts "\t\t\tCognitive Services Custom Search Scenarios"
    puts "\t\t\t=========================================="
    puts

    search_with_custom_config(custom_config)
    puts
    sleep(5)
  end

  private
  def search_with_custom_config(custom_config)
    puts 'Scenario - Search with custom config'
    puts '===================================='
    puts 'This will look up a single query (Seattle) and print out name and url for first web result'

    web_data = @custom_search_latest_profile_client_obj.custom_instance.search(
        custom_config, 'Seattle')

    puts "Searched for Query 'Seattle'"

    if (!web_data.web_pages.nil? && !web_data.web_pages.value.nil? && web_data.web_pages.value.length > 0)
      first_web_pages_result = web_data.web_pages.value[0];
      if(!first_web_pages_result.nil?)
        puts "Webpage Results: #{web_data.web_pages.value.length}"
        puts "First web page name: #{first_web_pages_result.name}"
        puts "First web page URL: #{first_web_pages_result.url}"
      else
        puts "Couldn't find web results!!!"
      end
    else
      puts "Couldn't see any web data..."
    end
  end
end
