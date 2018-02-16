# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorImageReviewsClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'

    @review_items = []
    @IMAGE_URLS = [
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample5.png'
    ]

  end

  def perform_image_reviews_sample(team_name)
    puts "\t\t\tCognitive Services Content Moderator Image Reviews Scenarios"
    puts "\t\t\t============================================================"
    puts

    @team_name = team_name
    puts 'This will create review information for the image.'
    create_reviews
    puts 'This will get review information using the reviewId from the last call.'
    get_review_details
    puts 'Perform manual reviews on the Content Moderator site.'
    puts 'Waiting 120 seconds for results to propagate.'
    sleep(120)
    puts 'Get review information again after wait.'
    get_review_details
  end

  private
  def create_reviews
    puts 'Creating reviews for the following images'

    create_review_body = []

    create_review_body_item_metadata_item = CreateReviewBodyItemMetadataItem.new
    create_review_body_item_metadata_item.key = 'sc'
    create_review_body_item_metadata_item.value = 'true'

    @IMAGE_URLS.each_with_index do |image_url, index|
      create_review_body_item = CreateReviewBodyItem.new
      create_review_body_item.type = 'image'
      create_review_body_item.content = image_url
      create_review_body_item.content_id = index.to_s
      create_review_body_item.callback_endpoint = 'https://requestb.in/vxke1mvx'
      create_review_body_item.metadata = [create_review_body_item_metadata_item]
      create_review_body.push(create_review_body_item)

      @review_items.push({
          'type': 'image',
          'url': image_url,
          'content_id': index.to_s
                         })
    end

    result = @content_moderator_latest_profile_client_obj.reviews.create_reviews('application/json', @team_name, create_review_body)
    result.each_with_index do |review_id, index|
      @review_items[index][:review_id] = review_id
    end

    sleep(5)
  end

  def get_review_details
    puts 'Getting review details'
    @review_items.each do |item|
      review_detail = @content_moderator_latest_profile_client_obj.reviews.get_review(@team_name, item[:review_id])
      puts "Review #{item[:review_id]} for item ID #{item[:content_id]} is #{review_detail.status}"
      if(review_detail.status == 'Complete')
        review_detail.reviewer_result_tags.each do |reviewer_result_tag|
          puts "#{reviewer_result_tag.key} - #{reviewer_result_tag.value}"
        end
      end
      puts 'Waiting 5 seconds'
      sleep(5)
    end
  end
end
