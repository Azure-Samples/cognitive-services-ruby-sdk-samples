# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_videosearch'

include Azure::CognitiveServices::VideoSearch::V1_0::Models

class VideoSearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @video_search_latest_profile_client_obj =
        Azure::VideoSearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_video_search
    puts "\t\t\tCognitive Services Video Search Scenarios"
    puts "\t\t\t========================================="
    puts

    simple_video_search
    puts
    sleep(5)

    search_with_pricing_length_resolution
    puts
    sleep(5)

    search_trending_videos
    puts
    sleep(5)

    search_video_details
    puts
    sleep(5)
  end

  private
  def simple_video_search
    puts 'Scenario I - Simple Video Search'
    puts '================================'
    puts 'This will search videos for (Nasa CubeSat) then verify number of results and print out id, name and url of first video result.'

    video_results = @video_search_latest_profile_client_obj.videos_operations.search('Nasa CubeSat')
    puts "Search videos for query 'Nasa CubeSat'"

    if(!video_results.nil? && !video_results.value.nil? && video_results.value.length > 0)
      first_video = video_results.value[0]
      puts "Video result count: #{video_results.value.length}"
      puts "First video id: #{first_video.video_id}"
      puts "First video name: #{first_video.name}"
      puts "First video url: #{first_video.content_url}"
    else
      puts "Couldn't find video results!"
    end
  end

  def search_with_pricing_length_resolution
    puts 'Scenario II - Video Search with pricing, length and resolution'
    puts '=============================================================='
    puts 'This will search videos for (Interstellar Trailer) that is free, short and 1080p resolution then verify number of results and print out id, name and url of first video result.'

    video_results = @video_search_latest_profile_client_obj.videos_operations.search('Interstellar Trailer', pricing: VideoPricing::Free, length: VideoLength::Short, resolution: VideoResolution::HD1080p)
    puts "Search videos for query 'Interstellar Trailer' that is free, short and 1080p resolution"
    if(!video_results.nil? && !video_results.value.nil? && video_results.value.length > 0)
      first_video = video_results.value[0]
      puts "Video result count: #{video_results.value.length}"
      puts "First video id: #{first_video.video_id}"
      puts "First video name: #{first_video.name}"
      puts "First video url: #{first_video.content_url}"
    else
      puts "Couldn't find video results!"
    end
  end

  def search_trending_videos
    puts 'Scenario III - Search trending videos'
    puts '====================================='
    puts 'This will find trending videos then verify banner tiles and categories'

    video_results = @video_search_latest_profile_client_obj.videos_operations.trending
    puts 'Search trending videos'

    if(!video_results.nil?)
      if(video_results.banner_tiles.length > 0)
        first_banner_tile = video_results.banner_tiles[0];
        puts "Banner tile count: #{video_results.banner_tiles.length}"
        puts "First banner tile text: #{first_banner_tile.query.text}"
        puts "First banner tile url: #{first_banner_tile.query.web_search_url}"
      else
        puts "Couldn't find banner tiles"
      end

      if(video_results.categories.length > 0)
        first_category = video_results.categories[0];
        puts "Category count: #{video_results.categories.length}"
        puts "First category title: #{first_category.title}"

        if(first_category.subcategories.length > 0)
          first_sub_category = first_category.subcategories[0];
          puts "SubCategory count: #{first_category.subcategories.length}"
          puts "First sub category title: #{first_sub_category.title}"

          if(first_sub_category.tiles.length > 0)
            first_tile = first_sub_category.tiles[0];
            puts "Tile count: #{first_sub_category.tiles.length}"
            puts "First tile text: #{first_tile.query.text}"
            puts "First tile url: #{first_tile.query.web_search_url}"
          else
            puts "Couldn't find tiles!"
          end
        else
          puts "Couldn't fine subcategories!"
        end
      else
        puts "Couldn't find categories"
      end
    else
      puts "Couldn't find video results!"
    end
  end

  def search_video_details
    puts 'Scenario IV - Search Video Details'
    puts '=================================='
    puts 'This will search videos for (Interstellar Trailer) and then search for detail information of the first video.'

    video_results = @video_search_latest_profile_client_obj.videos_operations.search('Interstellar Trailer')
    if(video_results.nil? || video_results.value.nil? && video_results.value.length == 0)
      puts "Couldn't find video results!"
      return
    end

    video_details = @video_search_latest_profile_client_obj.videos_operations.details('Interstellar Trailer', id:video_results.value[0].video_id, modules: [VideoInsightModule::All])
    puts "Search detail for video id=#{video_results.value[0].video_id}, name=#{video_results.value[0].name}"

    if(!video_details.nil?)
      if(video_details.video_result)
        puts "Expected video id: #{video_details.video_result.video_id}"
        puts "Expected video name: #{video_details.video_result.name}"
        puts "Expected video url: #{video_details.video_result.content_url}"
      else
        puts "Couldn't find expected video!"
      end

      if(!video_details.related_videos.value.nil? && video_details.related_videos.value.length > 0)
        first_related_video = video_details.related_videos.value[0]
        puts "Related video count: #{video_details.related_videos.value.length}"
        puts "First related video id: #{first_related_video.video_id}"
        puts "First related video name: #{first_related_video.name}"
        puts "First related video url: #{first_related_video.content_url}"
      else
        puts "Couldn't find any related video!"
      end
    else
      puts "Couldn't find details about the video!"
    end
  end
end
