# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_newssearch'

class NewsSearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @news_search_latest_profile_client_obj =
        Azure::NewsSearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_news_search
    puts "\t\t\tCognitive Services News Search Scenarios"
    puts "\t\t\t========================================"
    puts

    search_with_market_and_count
    puts
    sleep(5)

    search_with_market_freshness_and_sortby
    puts
    sleep(5)

    search_category_with_market_and_safe_search
    puts
    sleep(5)

    search_trending_with_market
    puts
    sleep(5)
  end

  private
  def search_with_market_and_count
    puts 'Scenario I - News Search with market and count'
    puts '=============================================='
    puts 'This will search news for (Quantum  Computing) with market and count parameters then verify number of results and print out total estimated matches, name, url, description, published time and name of provider of the first news result.'
    news_results = @news_search_latest_profile_client_obj.news_operations.search(
        'Quantum Computing', count:10, market:'en-us')

    if(news_results.nil?)
      puts "Didn't see any news result data.."
    elsif (news_results.value.length > 0)
      first_news_result = news_results.value[0];
      puts "Total Estimated Matches value: #{news_results.total_estimated_matches}"
      puts "News result count: #{news_results.value.length}"
      puts "First news name: #{first_news_result.name}"
      puts "First news url: #{first_news_result.url}"
      puts "First news description: #{first_news_result.description}"
      puts "First news published time: #{first_news_result.date_published}"
      puts "First news provider: #{first_news_result.provider[0].name}"
    else
      puts "Couldn't find news results!"
    end
  end

  def search_with_market_freshness_and_sortby
    puts 'Scenario II - News Search with market, freshness and sort_by'
    puts '============================================================'
    puts 'This will search most recent news for (Artificial Intelligence) with freshness and sort_by parameters then verify number of results and print out total estimated matches, name, url, description, published time and name of provider of the first news result.'
    news_results = @news_search_latest_profile_client_obj.news_operations.search(
        'Artificial Intelligence', freshness:'Week', market:'en-us', sort_by:'Date')

    if(news_results.nil?)
      puts "Didn't see any news result data.."
    elsif (news_results.value.length > 0)
      first_news_result = news_results.value[0];
      puts "Total Estimated Matches value: #{news_results.total_estimated_matches}"
      puts "News result count: #{news_results.value.length}"
      puts "First news name: #{first_news_result.name}"
      puts "First news url: #{first_news_result.url}"
      puts "First news description: #{first_news_result.description}"
      puts "First news published time: #{first_news_result.date_published}"
      puts "First news provider: #{first_news_result.provider[0].name}"
    else
      puts "Couldn't find news results!"
    end
  end

  def search_category_with_market_and_safe_search
    puts 'Scenario III - News Category Search with market and safe_search'
    puts '==============================================================='
    puts 'This will search category news for movie and TV entertainment with safe search then verify number of results and print out category, name, url, description, published time and name of provider of the first news result'
    news_results = @news_search_latest_profile_client_obj.news_operations.category(
        category:'Entertainment_MovieAndTV', market:'en-us', safe_search:'strict')

    if(news_results.nil?)
      puts "Didn't see any news result data.."
    elsif (news_results.value.length > 0)
      first_news_result = news_results.value[0];
      puts "News result count: #{news_results.value.length}"
      puts "First news category: #{first_news_result.category}"
      puts "First news name: #{first_news_result.name}"
      puts "First news url: #{first_news_result.url}"
      puts "First news description: #{first_news_result.description}"
      puts "First news published time: #{first_news_result.date_published}"
      puts "First news provider: #{first_news_result.provider[0].name}"
    else
      puts "Couldn't find news results!"
    end
  end

  def search_trending_with_market
    puts 'Scenario IV - News Trending Search with market'
    puts '=============================================='
    puts 'This will search news trending topics in Bing then verify number of results and print out name, text of query, web search url, news search url and image url of the first news result'
    trending_topics = @news_search_latest_profile_client_obj.news_operations.trending(market:'en-us')

    if(trending_topics.nil?)
      puts "Didn't see any news trending topics.."
    elsif (trending_topics.value.length > 0)
      first_topic = trending_topics.value[0];
      puts "Trending topics count: #{trending_topics.value.length}"
      puts "First topic name: #{first_topic.name}"
      puts "First topic query: #{first_topic.query.text}"
      puts "First topic image url: #{first_topic.image.url}"
      puts "First topic web search url: #{first_topic.web_search_url}"
      puts "First topic news search url: #{first_topic.news_search_url}"
    else
      puts "Couldn't find news trending topics!"
    end
  end
end
