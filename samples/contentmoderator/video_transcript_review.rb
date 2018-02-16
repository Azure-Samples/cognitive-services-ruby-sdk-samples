# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorVideoTranscriptReviewClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'
    @streaming_content = 'https://amssamples.streaming.mediaservices.windows.net/91492735-c523-432b-ba01-faba6c2206a2/AzureMediaServicesPromo.ism/manifest'
    @transcript = 'WEBVTT

           01:01.000 --> 02:02.000
           First line with a crap word in a transcript.

           02:03.000 --> 02:25.000
           This is another line in the transcript.'
  end

  def perform_video_transcript_review_sample(team_name)
    puts "\t\t\tCognitive Services Content Moderator Video Transcript Review Scenarios"
    puts "\t\t\t======================================================================"
    puts

    @team_name = team_name
    puts 'Creating review.'
    review_id = create_review('review2', @streaming_content)
    puts 'Adding transcript.'
    add_transcript(review_id, @transcript)
    puts 'Adding transcript moderation result.'
    add_transcript_moderation_result(review_id, @transcript)
    puts 'Publishing review.'
    publish_review(review_id)
    puts 'Open your Content Moderator Dashboard and select Review > Video to see the review.'
  end

  private
  def create_review(id, content)
    puts 'Creating a video review.'
    create_video_reviews_body_item =  CreateVideoReviewsBodyItem.new
    create_video_reviews_body_item.content = content
    create_video_reviews_body_item.content_id = id
    create_video_reviews_body_item.type = 'Video'
    create_video_reviews_body_item.status = 'Unpublished'

    result = @content_moderator_latest_profile_client_obj.reviews.create_video_reviews('application/json', @team_name, [create_video_reviews_body_item])
    sleep(5)
    result[0]
  end

  def add_transcript(review_id, transcript)
    puts "Adding a transcript to the review with ID #{review_id}"
    file_stream = File.open("#{__dir__}/../../resources/files/transcript.txt", 'r')

    content_length = 0
    File.open("#{__dir__}/../../resources/files/transcript.txt", 'r') do |f|
      f.each_line do |line|
        content_length += line.length
      end
    end

    custom_headers = {}
    custom_headers['Content-Length'] = content_length.to_s
    @content_moderator_latest_profile_client_obj.reviews.add_video_transcript(@team_name, review_id, file_stream, custom_headers:custom_headers)
    sleep(5)
  end

  def add_transcript_moderation_result(review_id, transcript)
    puts "Adding a transcript moderation result to the review with ID #{review_id}"
    screen = @content_moderator_latest_profile_client_obj.text_moderation.screen_text('eng', 'text/plain', @transcript)

    terms = []
    if(!screen.terms.nil?)
      screen.terms.each do |term|
        terms << term
        puts " Index: #{term.index}"
        puts " List Id: #{term.list_id}"
        puts " Original Index: #{term.original_index}"
        puts " Term: #{term.term}"
      end
    end

    transcript_moderation_body_item = TranscriptModerationBodyItem.new
    transcript_moderation_body_item.timestamp = '0'
    transcript_moderation_body_item.terms = terms

    @content_moderator_latest_profile_client_obj.reviews.add_video_transcript_moderation_result('application/json', @team_name, review_id, [transcript_moderation_body_item])
    sleep(5)
  end

  def publish_review(review_id)
    puts "Publishing the review with ID #{review_id}."
    @content_moderator_latest_profile_client_obj.reviews.publish_video_review(@team_name, review_id)
    sleep(5)
  end
end
