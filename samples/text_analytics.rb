# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_textanalytics'

include Azure::CognitiveServices::TextAnalytics::V2_0::Models

class TextAnalyticsClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @text_analytics_latest_profile_client_obj =
        Azure::TextAnalytics::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @text_analytics_latest_profile_client_obj.azure_region = AzureRegions::Westus2
  end

  def perform_sample_text_analytics
    puts "\t\t\tCognitive Services Text Analytics Scenarios"
    puts "\t\t\t==========================================="
    puts

    detect_language_input
    puts
    sleep(5)

    extract_key_phrases
    puts
    sleep(5)

    perform_sentiment_analysis
    puts
    sleep(5)
  end

  private
  def detect_language_input
    puts 'Scenario I - Detect Language Input'
    puts '=================================='
    puts 'This will detect the languages of the inputs.'

    input_1 = Input.new
    input_1.id = '1'
    input_1.text = 'This is a document written in English.'

    input_2 = Input.new
    input_2.id = '2'
    input_2.text = 'Este es un document escrito en Español..'

    input_3 = Input.new
    input_3.id = '3'
    input_3.text = '这是一个用中文写的文件'

    batch_input = BatchInput.new
    batch_input.documents = [input_1, input_2, input_3]

    result = @text_analytics_latest_profile_client_obj.detect_language(batch_input)

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      result.documents.each do |document|
        puts "Document ID: #{document.id} , Language: #{document.detected_languages[0].name}"
      end
    else
      puts 'No results data..'
    end
  end

  def extract_key_phrases
    puts 'Scenario II - Extract Key Phrases'
    puts '================================='
    puts 'This will extract key phrases from the sentences.'

    input_1 = MultiLanguageInput.new
    input_1.id = '1'
    input_1.language = 'ja'
    input_1.text = '猫は幸せ'

    input_2 = MultiLanguageInput.new
    input_2.id = '2'
    input_2.language = 'de'
    input_2.text = 'Fahrt nach Stuttgart und dann zum Hotel zu Fu.'

    input_3 = MultiLanguageInput.new
    input_3.id = '3'
    input_3.language = 'en'
    input_3.text = 'My cat is stiff as a rock.'

    input_4 = MultiLanguageInput.new
    input_4.id = '4'
    input_4.language = 'es'
    input_4.text = 'A mi me encanta el fútbol!'

    multi_language_batch_input =  MultiLanguageBatchInput.new
    multi_language_batch_input.documents = [input_1, input_2, input_3, input_4]

    result = @text_analytics_latest_profile_client_obj.key_phrases(multi_language_batch_input)

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      result.documents.each do |document|
        puts "Document Id: #{document.id}"
        puts '  Key Phrases'
        document.key_phrases.each do |key_phrase|
          puts "    #{key_phrase}"
        end
      end
    else
      puts 'No results data..'
    end
  end

  def perform_sentiment_analysis
    puts 'Scenario III - Perform Sentiment Analysis'
    puts '========================================='
    puts 'This will perform sentiment analysis on the sentences.'

    input_1 = MultiLanguageInput.new
    input_1.id = '1'
    input_1.language = 'en'
    input_1.text = 'I had the best day of my life.'

    input_2 = MultiLanguageInput.new
    input_2.id = '2'
    input_2.language = 'en'
    input_2.text = 'This was a waste of my time. The speaker put me to sleep.'

    input_3 = MultiLanguageInput.new
    input_3.id = '3'
    input_3.language = 'es'
    input_3.text = 'No tengo dinero ni nada que dar...'

    input_4 = MultiLanguageInput.new
    input_4.id = '4'
    input_4.language = 'it'
    input_4.text = "L'hotel veneziano era meraviglioso. È un bellissimo pezzo di architettura."

    multi_language_batch_input =  MultiLanguageBatchInput.new
    multi_language_batch_input.documents = [input_1, input_2, input_3, input_4]

    result = @text_analytics_latest_profile_client_obj.sentiment(multi_language_batch_input)

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      result.documents.each do |document|
        puts "Document Id: #{document.id}: Sentiment Score: #{document.score}"
      end
    end
  end
end
