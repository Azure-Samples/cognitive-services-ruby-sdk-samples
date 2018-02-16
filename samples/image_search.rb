# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_imagesearch'

include Azure::CognitiveServices::ImageSearch::V1_0::Models

class ImageSearchClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @image_search_latest_profile_client_obj =
        Azure::ImageSearch::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
  end

  def perform_sample_image_search
    puts "\t\t\tCognitive Services Images Search Scenarios"
    puts "\t\t\t=========================================="
    puts

    simple_search
    puts
    sleep(5)

    search_with_image_type_and_aspect
    puts
    sleep(5)

    search_trending_images
    puts
    sleep(5)

    search_image_details
    puts
    sleep(5)
  end

  private
  def simple_search
    puts 'Scenario I - Simple Images Search'
    puts '================================='
    puts 'This will search images for (canadian rockies) then verify number of results and print out first image result, pivot suggestion, and query expansion'

    image_results = @image_search_latest_profile_client_obj.images_operations.search('canadian rockies')
    puts "Search images for query 'canadian rockies'"

    if (!image_results.nil? && image_results.value.length > 0)
      first_image_result = image_results.value[0];

      puts "Image result count: #{image_results.value.length}"
      puts "First image insights token: #{first_image_result.image_insights_token}"
      puts "First image thumbnail url: #{first_image_result.thumbnail_url}"
      puts "First image content url: #{first_image_result.content_url}"
    else
      puts "Couldn't find any image results data..."
    end

    puts "Image result total estimated matches: #{image_results.total_estimated_matches}"
    puts "Image result next offset: #{image_results.next_offset}"

    if(!image_results.pivot_suggestions.nil? && image_results.pivot_suggestions.length > 0)
      first_pivot = image_results.pivot_suggestions[0]

      puts "Pivot suggestion count: #{image_results.pivot_suggestions.length}"
      puts "First pivot: #{first_pivot.pivot}"

      if(!first_pivot.suggestions.nil? && first_pivot.suggestions.length > 0)
        first_suggestion = first_pivot.suggestions[0];

        puts "Suggestion count: #{first_pivot.suggestions.length}"
        puts "First suggestion text: #{first_suggestion.text}"
        puts "First suggestion web search url: #{first_suggestion.web_search_url}"
      else
        puts "Couldn't find pivot suggestions!!!"
      end
    else
      puts "Couldn't find pivot suggestions!!!"
    end

    if(!image_results.query_expansions.nil? && image_results.query_expansions.length > 0)
      first_query_expansion = image_results.query_expansions[0];

      puts "Query expansion count: #{image_results.query_expansions.length}"
      puts "First query expansion text: #{first_query_expansion.text}"
      puts "First query expansion search link: #{first_query_expansion.search_link}"
    else
      puts "Couldn't find query expansions!!!"
    end
  end

  def search_with_image_type_and_aspect
    puts 'Scenario II - Images Search with Image Type and aspect'
    puts '======================================================'
    puts 'This will search images for (studio ghibli), filtered for animated gifs and wide aspect, then verify number of results and print out insights token, thumbnail url and web url of first result'

    image_results = @image_search_latest_profile_client_obj.images_operations.search(
        'studio ghibli', aspect:ImageAspect::Wide, image_type:ImageType::AnimatedGif)

    puts "Search images for 'studio ghibli' results that are animated gifs and wide aspect"

    if(!image_results.nil? && image_results.value.length > 0)
      first_image_result = image_results.value[0];

      puts "Image result count: #{image_results.value.length}"
      puts "First image insightsToken: #{first_image_result.image_insights_token}"
      puts "First image thumbnail url: #{first_image_result.thumbnail_url}"
      puts "First image web search url: #{first_image_result.web_search_url}"
    else
      puts "Couldn't see any image result data..."
    end
  end

  def search_trending_images
    puts 'Scenario III - Trending Images Search'
    puts '====================================='
    puts 'This will search for trending images then verify categories and tiles.'

    trending_results = @image_search_latest_profile_client_obj.images_operations.trending
    puts 'Search trending images'

    if(!trending_results.nil?)
      if (!trending_results.categories.nil? && trending_results.categories.length > 0)
        first_category = trending_results.categories[0];
        puts "Category count: #{trending_results.categories.length}"
        puts "First category title: #{first_category.title}"

        if(!first_category.tiles.nil? && first_category.tiles.length > 0)
          first_tile = first_category.tiles[0];
          puts "Tile count: #{first_category.tiles.length}"
          puts "First tile text: #{first_tile.query.text}"
          puts "First tile url: #{first_tile.query.web_search_url}"
        else
          puts "Couldn't find tiles!!!"
        end
      else
        puts "Couldn't find categories..."
      end
    else
      puts "Couldn't see any trending image data..."
    end
  end

  def search_image_details
    puts 'Scenario IV - Image Details Search'
    puts '=================================='
    puts 'This will search images for (degas) and then search for image details of the first image.'

    image_results = @image_search_latest_profile_client_obj.images_operations.search('degas')
    first_image = image_results.value[0]

    if(!first_image.nil?)
      image_detail = @image_search_latest_profile_client_obj.images_operations.details(
          'degas', insights_token:first_image.image_insights_token, modules:[ImageInsightModule::All])

      puts "Search detail for image insightsToken=#{first_image.image_insights_token}"

      if(!image_detail.nil?)
        puts "Expected image insights token: #{image_detail.image_insights_token}"

        if(!image_detail.best_representative_query.nil?)
          puts "Best representative query text: #{image_detail.best_representative_query.text}"
          puts "Best representative query web search url: #{image_detail.best_representative_query.web_search_url}"
        else
          puts "Couldn't find best representative query!"
        end

        if(!image_detail.image_caption.nil?)
          puts "Image caption: #{image_detail.image_caption.caption}"
          puts "Image caption data source url: #{image_detail.image_caption.data_source_url}"
        else
          puts "Couldn't find image caption!"
        end

        if(!image_detail.pages_including.nil? && !image_detail.pages_including.value.nil? && image_detail.pages_including.value.length > 0)
          first_page = image_detail.pages_including.value[0];
          puts "Pages including count: #{image_detail.pages_including.value.length}"
          puts "First page content url: #{first_page.content_url}"
          puts "First page name: #{first_page.name}"
          puts "First page date published: #{first_page.date_published}"
        else
          puts "Couldn't find any pages including this image!"
        end

        if(!image_detail.related_searches.nil? && !image_detail.related_searches.value.nil? && image_detail.related_searches.value.length > 0)
          first_related_search = image_detail.related_searches.value[0];
          puts "Related searches count: #{image_detail.related_searches.value.length}"
          puts "First related search text: #{first_related_search.text}"
          puts "First related search web search url: #{first_related_search.web_search_url}"
        else
          puts "Couldn't find any related searches!"
        end

        if(!image_detail.visually_similar_images.nil? && !image_detail.visually_similar_images.value.nil? && image_detail.visually_similar_images.value.length > 0)
          first_visually_similar_image = image_detail.visually_similar_images.value[0];
          puts "Visually similar images count: #{image_detail.related_searches.value.length}"
          puts "First visually similar image name: #{first_visually_similar_image.name}"
          puts "First visually similar image content url: #{first_visually_similar_image.content_url}"
          puts "First visually similar image size: #{first_visually_similar_image.content_size}"
        else
          puts "Couldn't find any related searches!"
        end

        if(!image_detail.image_tags.nil? && !image_detail.image_tags.value.nil? && image_detail.image_tags.value.length > 0)
          first_tag = image_detail.image_tags.value[0];
          puts "Image tags count: #{image_detail.image_tags.value.length}"
          puts "First tag name: #{first_tag.name}"
        else
          puts "Couldn't find any related searches!"
        end
      else
        puts "Couldn't find detail about the image!"
      end
    else
      puts "Couldn't find image results!!!"
    end
  end
end
