# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_computervision'

include Azure::CognitiveServices::ComputerVision::V1_0::Models

class ComputerVisionClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @computer_vision_latest_profile_client_obj =
        Azure::ComputerVision::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @computer_vision_latest_profile_client_obj.azure_region = AzureRegions::Westus2
  end

  def perform_sample_computer_vision
    puts "\t\t\tCognitive Services Computer Vision Scenarios"
    puts "\t\t\t============================================"
    puts

    file_stream = File.binread("#{__dir__}/../resources/images/house.jpg")

    visual_features = [VisualFeatureTypes::Categories, VisualFeatureTypes::Tags, VisualFeatureTypes::Description, VisualFeatureTypes::Color, VisualFeatureTypes::Faces, VisualFeatureTypes::ImageType]
    result = @computer_vision_latest_profile_client_obj.analyze_image_in_stream(file_stream ,visual_features:visual_features)

    if(!result.nil? && !result.description.nil? && !result.description.captions.nil? && result.description.captions.length > 0)
      puts "The image can be described as: #{result.description.captions[0].text}"
      puts "Confidence of description: #{result.description.captions[0].confidence}"
    else
      puts "Couldn't see any image descriptions.."
    end

    if(!result.nil? && !result.tags.nil? && result.tags.length > 0)
      puts
      puts 'Tags associated with this image:'
      puts '  Tag-Confidence'
      puts '  =============='
      result.tags.each do |tag|
        puts "    #{tag.name}-#{tag.confidence}"
      end
    else
      puts "Couldn't see any image tags.."
    end

    puts
    puts "The primary colors of this image are: #{result.color.dominant_colors.join(',')}"

  end
end
