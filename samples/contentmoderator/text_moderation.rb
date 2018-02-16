# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorTextModerationClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'
  end

  def perform_text_moderation_sample
    puts "\t\t\tCognitive Services Content Text Moderation Scenarios"
    puts "\t\t\t===================================================="
    puts

    text_to_moderate = 'Is this a grabage email abcdef@abcd.com, phone: 6657789887, IP: 255.255.255.255, 1 Microsoft Way, Redmond, WA 98052. Crap is the profanity here. Is this information PII? phone 3144444444'
    screen_result = @content_moderator_latest_profile_client_obj.text_moderation.screen_text('eng', 'text/plain', text_to_moderate, autocorrect: true, pii: true)
    if(!screen_result.nil?)
      puts "Original Text: #{screen_result.original_text}"
      puts "Auto Corrected Text: #{screen_result.auto_corrected_text}"
      puts "Normalized Text: #{screen_result.normalized_text}"
      puts 'Status'
      puts "  Code: #{screen_result.status.code}"
      puts "  Description: #{screen_result.status.description}"
      puts "Tracking Id: #{screen_result.tracking_id}"
      puts 'Terms'
      screen_result.terms.each do |term|
        puts " Index: #{term.index}"
        puts " List Id: #{term.list_id}"
        puts " Original Index: #{term.original_index}"
        puts " Term: #{term.term}"
      end
      if(!screen_result.pii.address.nil? && screen_result.pii.address.length > 0)
        puts 'Pii Address Details'
        screen_result.pii.address.each do |address|
          puts "  Index: #{address.index} - Text: #{address.text}"
        end
      end

      if(!screen_result.pii.email.nil? && screen_result.pii.email.length > 0)
        puts 'Pii Email Details'
        screen_result.pii.email.each do |email|
          puts "  Detected: #{email.detected} - Index: #{email.index} - Sub Type: #{email.sub_type} - Text: #{email.text}"
        end
      end

      if(!screen_result.pii.ipa.nil? && screen_result.pii.ipa.length > 0)
        puts 'Pii ipa Details'
        screen_result.pii.ipa.each do |ipa|
          puts "  Index: #{ipa.index} - Sub Type: #{ipa.sub_type} - Text: #{ipa.text}"
        end
      end

      if(!screen_result.pii.phone.nil? && screen_result.pii.phone.length > 0)
        puts 'Pii phone Details'
        screen_result.pii.phone.each do |phone|
          puts "  Country Code: #{phone.country_code} - Index: #{phone.index} - Text: #{phone.text}"
        end
      end
    else
      puts "Couldn't get any screen results."
    end
  end
end
