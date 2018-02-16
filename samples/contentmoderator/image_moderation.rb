# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorImageModerationClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'

    @image_urls = [
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample2.jpg',
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample5.png'
    ]

  end

  def perform_image_moderation_sample
    puts "\t\t\tCognitive Services Content Moderator Image Moderation Scenarios"
    puts "\t\t\t==============================================================="
    puts

    puts 'Image Moderation Samples'
    @image_urls.each do |image_url|
      detect_racy(image_url)
      sleep(5)
      detect_text(image_url)
      sleep(5)
      detect_face(image_url)
      sleep(5)
    end
  end

  private
  def detect_racy(url)
    puts 'Evaluating for adult and racy content...'
    image_url = ImageUrl.new
    image_url.data_representation = 'URL'
    image_url.value = url

    result = @content_moderator_latest_profile_client_obj.image_moderation.evaluate_url_input('application/json', image_url)

    if(!result.nil?)
      puts "Cache Id: #{result.cache_id}"
      puts "Result: #{result.result}"
      puts "Tracking Id: #{result.tracking_id}"
      puts "Adult Classification Score: #{result.adult_classification_score}"
      puts "Is Image Adult Classified: #{result.is_image_adult_classified}"
      puts "Racy Classification Score: #{result.racy_classification_score}"
      puts "Is Image Racy Classified: #{result.is_image_racy_classified}"
      puts 'Status'
      puts "  Code: #{result.status.code}"
      puts "  Description: #{result.status.description}"
      puts "  Exception Status: #{result.status.exception}"
      puts 'Advanced Info'
      result.advanced_info.each do |entry|
        puts "Key: #{entry.key} - Value: #{entry.value}"
        puts
      end
    end
    puts
    puts
  end

  def detect_text(url)
    puts 'Detect and extract text....'
    image_url = ImageUrl.new
    image_url.data_representation = 'URL'
    image_url.value = url

    result = @content_moderator_latest_profile_client_obj.image_moderation.ocrurl_input('eng', 'application/json', image_url)
    if(!result.nil?)
      puts 'Status'
      puts "  Code: #{result.status.code}"
      puts "  Description: #{result.status.description}"
      puts "  Exception Status: #{result.status.exception}"
      puts 'Metadata'
      result.metadata.each do |entry|
        puts "  Key: #{entry.key} - Value: #{entry.value}"
      end
      puts "Tracking Id: #{result.tracking_id}"
      puts "Cache Id: #{result.cache_id}"
      puts "Language: #{result.language}"
      puts "Text: #{result.text}"
      puts 'Candidates' if result.candidates.length > 0
      result.candidates.each do |candidate|
        puts "  Text: #{candidate.text} - Confidence: #{candidate.confidence}"
        puts
      end
    end
    puts
    puts
  end

  def detect_face(url)
    puts 'Detect faces.'
    image_url = ImageUrl.new
    image_url.data_representation = 'URL'
    image_url.value = url

    result = @content_moderator_latest_profile_client_obj.image_moderation.find_faces_url_input('application/json', image_url)
    if(!result.nil?)
      puts 'Status'
      puts "  Code: #{result.status.code}"
      puts "  Description: #{result.status.description}"
      puts "  Exception Status: #{result.status.exception}"
      puts "Tracking Id: #{result.tracking_id}"
      puts "Cache Id: #{result.cache_id}"
      puts "Result: #{result.result}"
      puts "Count: #{result.count}"
      puts 'Advanced Info'
      result.advanced_info.each do |entry|
        puts "Key: #{entry.key} - Value: #{entry.value}"
        puts
      end
      puts 'Faces'
      result.faces.each do |face|
        puts "  Bottom: #{face.bottom}"
        puts "  Left: #{face.left}"
        puts "  Right: #{face.right}"
        puts "  Top: #{face.top}"
        puts
      end
    end
    puts
    puts
  end
end
