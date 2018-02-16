# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_websearch'

include Azure::CognitiveServices::WebSearch::V1_0::Models

class WebSearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @web_search_latest_profile_client_obj =
        Azure::WebSearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_web_search
    puts "\t\t\tCognitive Services Web Search Scenarios"
    puts "\t\t\t======================================="
    puts

    simple_search
    puts
    sleep(5)

    search_with_offset_and_count
    puts
    sleep(5)

    search_with_response_filter
    puts
    sleep(5)

    search_with_answer_count_promote_and_safe_search
    puts
    sleep(5)
  end

  private
  def simple_search
    puts 'Scenario I - Simple Web Search'
    puts '=============================='
    puts 'This will look up a single query (Seattle) and print out name and url for first web, image, news and videos results.'

    result = @web_search_latest_profile_client_obj.web.search('Seattle')
    puts "Searched for Query: 'Seattle'"

    puts 'Web Pages results'
    puts '================='
    # Web Pages
    if(!result.web_pages.nil? && result.web_pages.value.length > 0)
      first_web_pages_result = result.web_pages.value[0];
      if(!first_web_pages_result.nil?)
        puts "Web page Results: #{result.web_pages.value.length}"
        puts "First web page name: #{first_web_pages_result.name}"
        puts "First web page URL: #{first_web_pages_result.url}"
        puts
      else
        puts "Couldn't find web results!!!"
      end
    else
      puts "Couldn't see any web data..."
    end

    puts 'Images results'
    puts '=============='
    # Images
    if(!result.images.nil? && result.images.value.length > 0)
      first_images_result = result.images.value[0]
      if(!first_images_result.nil?)
        puts "Image Results: #{result.images.value.length}"
        puts "First Image result name: #{first_images_result.name}"
        puts "First Image result URL: #{first_images_result.content_url}"
        puts
      else
        puts "Couldn't find image results!!!"
      end
    else
      puts "Couldn't see any image data..."
    end

    puts 'News results'
    puts '============'
    # News
    if(!result.news.nil? && result.news.value.length > 0)
      first_news_result = result.news.value[0]
      if(!first_news_result.nil?)
        puts "News Results: #{result.news.value.length}"
        puts "First news result name: #{first_news_result.name}"
        puts "First news result URL: #{first_news_result.url}"
        puts
      else
        puts "Couldn't find news results!!!"
      end
    else
      puts "Couldn't see any news data..."
    end

    puts 'Videos results'
    puts '=============='
    # Videos
    if (!result.videos.nil? && result.videos.value.length > 0)
      first_videos_result = result.videos.value[0]
      if(!first_videos_result.nil?)
        puts "Video Results: #{result.videos.value.length}"
        puts "First video result name: #{first_videos_result.name}"
        puts "First video result URL: #{first_videos_result.content_url}"
        puts
      else
        puts "Couldn't find videos results!!!"
      end
    else
      puts "Couldn't see any video data..."
    end
  end

  def search_with_offset_and_count
    puts 'Scenario II - Web Search with Offset and Count'
    puts '=============================================='
    puts 'This will search (Best restaurants in Seattle), verify number of results and print out name and url of first result.'

    result = @web_search_latest_profile_client_obj.web.search(
        'Best restaurants in Seattle', count:20, offset:10)

    puts "Searched for Query: 'Best restaurants in Seattle'"
    if(!result.web_pages.nil? && result.web_pages.value.length > 0)
      first_web_pages_result = result.web_pages.value[0];
      if(!first_web_pages_result.nil?)
        puts "Web page Results: #{result.web_pages.value.length}"
        puts "First web page name: #{first_web_pages_result.name}"
        puts "First web page URL: #{first_web_pages_result.url}"
        puts
      else
        puts "Couldn't find web results!!!"
      end
    else
      puts "Couldn't see any web data..."
    end
  end

  def search_with_response_filter
    puts 'Scenario III - Web Search with Response filter'
    puts '=============================================='
    puts 'This will search (Microsoft) with response filters to news and print details of news.'

    result = @web_search_latest_profile_client_obj.web.search(
        'Microsoft', response_filter:[AnswerType::News])

    puts "Searched for Query 'Microsoft' with response filters 'News'"

    if(!result.news.nil? && result.news.value.length > 0)
      first_news_result = result.news.value[0];
      if(!first_news_result.nil?)
        puts "News Results: #{result.news.value.length}"
        puts "First news page name: #{first_news_result.name}"
        puts "First news page URL: #{first_news_result.url}"
      else
        puts "Couldn't find news results!!!"
      end
    else
      puts "Couldn't see any news data..."
    end
  end

  def search_with_answer_count_promote_and_safe_search
    puts 'Scenario IV - Web Search with answer count, promote and safe search'
    puts '==================================================================='
    puts 'This will search (Lady Gaga) with answer count and promote parameters and print details of answers.'

    result = @web_search_latest_profile_client_obj.web.search(
        'Lady Gaga', answer_count:2, promote:[AnswerType::Videos], safe_search:SafeSearch::Strict)

    puts "Searched for Query 'Lady Gaga'"
    if(!result.videos.nil? && result.videos.value.length > 0)
      first_videos_result = result.videos.value[0]
      if(!first_videos_result.nil?)
        puts "Video Results: #{result.videos.value.length}"
        puts "First Video page name: #{first_videos_result.name}"
        puts "First Video page URL: #{first_videos_result.content_url}"
      else
        puts "Couldn't find videos results!!!"
      end
    else
      puts "Couldn't see any videos data..."
    end
  end
end
