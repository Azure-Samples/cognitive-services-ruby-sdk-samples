# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorVideoReviewsClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'
    @streaming_content = 'https://amssamples.streaming.mediaservices.windows.net/91492735-c523-432b-ba01-faba6c2206a2/AzureMediaServicesPromo.ism/manifest'
    @frame1_url = 'https://blobthebuilder.blob.core.windows.net/sampleframes/ams-video-frame1-00-17.PNG'
    @frame2_url = 'https://blobthebuilder.blob.core.windows.net/sampleframes/ams-video-frame-2-01-04.PNG'
    @frame3_url = 'https://blobthebuilder.blob.core.windows.net/sampleframes/ams-video-frame-3-02-24.PNG'
  end

  def perform_video_reviews_sample(team_name)
    puts "\t\t\tCognitive Services Content Moderator Video Reviews Scenarios"
    puts "\t\t\t============================================================"
    puts

    puts 'Video Reviews Sample'
    @team_name = team_name
    puts 'Create a review with the content pointing to a streaming endpoint (manifest).'
    review_id = create_review('review1', @streaming_content)
    puts 'Adding frames with different timestamps.'
    add_frame(review_id, @frame1_url, 17)
    add_frame(review_id, @frame2_url, 64)
    add_frame(review_id, @frame3_url, 144)
    puts 'Get frame and review information.'
    get_frames(review_id)
    get_review(review_id)
    puts 'Publish the review.'
    publish_review(review_id)
    puts 'Open your Content Moderator Dashboard and select Review > Video to see the review.'
  end

  private
  def create_review(id, content)
    create_video_reviews_body_item = CreateVideoReviewsBodyItem.new
    create_video_reviews_body_item.content = content
    create_video_reviews_body_item.content_id = id
    create_video_reviews_body_item.type = 'Video'
    create_video_reviews_body_item.status = 'Unpublished'

    result = @content_moderator_latest_profile_client_obj.reviews.create_video_reviews('application/json', @team_name, [create_video_reviews_body_item])
    sleep(5)
    result[0]
  end

  def add_frame(review_id, url, timestamp_seconds)
    puts "Adding a frame to the review with ID #{review_id}"
    video_frame_body_item = VideoFrameBodyItem.new
    video_frame_body_item.timestamp = (timestamp_seconds * 1000).to_s
    video_frame_body_item.frame_image = url

    metadata_1 = VideoFrameBodyItemMetadataItem.new
    metadata_1.key = 'reviewRecommended'
    metadata_1.value = 'true'

    metadata_2 = VideoFrameBodyItemMetadataItem.new
    metadata_2.key = 'adultScore'
    metadata_2.value = Random.rand.to_s

    metadata_3 = VideoFrameBodyItemMetadataItem.new
    metadata_3.key = 'a'
    metadata_3.value = 'false'

    metadata_4 = VideoFrameBodyItemMetadataItem.new
    metadata_4.key = 'racyScore'
    metadata_4.value = Random.rand.to_s

    metadata_5 = VideoFrameBodyItemMetadataItem.new
    metadata_5.key = 'r'
    metadata_5.value = 'false'

    video_frame_body_item.metadata = [metadata_1, metadata_2, metadata_3, metadata_4, metadata_5]

    tag = VideoFrameBodyItemReviewerResultTagsItem.new
    tag.key = 'tag1'
    tag.value = 'value1'

    video_frame_body_item.reviewer_result_tags = [tag]

    @content_moderator_latest_profile_client_obj.reviews.add_video_frame_url('application/json', @team_name, review_id, [video_frame_body_item])
    sleep(5)
  end

  def get_frames(review_id)
    puts "Getting frames for the review with ID #{review_id}"
    result = @content_moderator_latest_profile_client_obj.reviews.get_video_frames(@team_name, review_id, start_seed: 0, no_of_records: 10000)
    if(!result.nil?)
      puts 'Result'
      puts "  Review Id: #{result.review_id}"
      puts '  Frames'
      result.video_frames.each do |frame|
        puts "    Timestamp: #{frame.timestamp}"
        puts "    Frame Image: #{frame.frame_image}"
        puts '    Metadata' if frame.metadata.length > 0
        frame.metadata.each do |keyvalue|
          puts "      Key: #{keyvalue.key} - Value: #{keyvalue.value}"
        end
        puts '    Reviewer Result Tags' if frame.reviewer_result_tags.length > 0
        frame.reviewer_result_tags.each do |tag|
          puts "      Key: #{tag.key} - Value: #{tag.value}"
        end
      end
    end
    sleep(5)
  end

  def get_review(review_id)
    puts "Getting the status for the review with ID #{review_id}"
    result = @content_moderator_latest_profile_client_obj.reviews.get_review(@team_name, review_id)
    if(!result.nil?)
      puts "Review Id: #{result.review_id}"
      puts "Sub Team: #{result.sub_team}"
      puts "Status: #{result.status}"
      puts "Created By: #{result.created_by}"
      puts "Type: #{result.type}"
      puts 'Reviewer result tags' if result.reviewer_result_tags.length > 0
      result.reviewer_result_tags.each do |tag|
        puts "  Key: #{tag.key} - Value: #{tag.value}"
      end
      puts 'Metadata' if result.metadata.length > 0
      result.metadata.each do |key_value|
        puts "  Key: #{key_value.key} - Value: #{key_value.value}"
      end
      puts "Content: #{result.content}"
      puts "Content Id: #{result.content_id}"
      puts "Callback Endpoint: #{result.callback_endpoint}"
    end
    sleep(5)
  end

  def publish_review(review_id)
    puts "Publishing the review with ID #{review_id}."
    @content_moderator_latest_profile_client_obj.reviews.publish_video_review(@team_name, review_id)
    sleep(5)
  end
end
