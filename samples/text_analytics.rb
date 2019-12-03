# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.

# <includeStatement>
require 'azure_cognitiveservices_textanalytics'
include Azure::CognitiveServices::TextAnalytics::V2_1::Models
# </includeStatement>

class TextAnalyticsClient
  @textAnalyticsClient
  # <initialize> 
  def initialize(endpoint, key)
    credentials =
        MsRestAzure::CognitiveServicesCredentials.new(key)

    endpoint = String.new(endpoint)

    @textAnalyticsClient = Azure::TextAnalytics::Profiles::Latest::Client.new({
        credentials: credentials
    })
    @textAnalyticsClient.endpoint = endpoint
  end
  # </initialize>
  # <analyzeSentiment>
  def AnalyzeSentiment(inputDocuments)
    result = @textAnalyticsClient.sentiment(
        multi_language_batch_input: inputDocuments
    )

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      puts '===== SENTIMENT ANALYSIS ====='
      result.documents.each do |document|
        puts "Document Id: #{document.id}: Sentiment Score: #{document.score}"
      end
    end
    puts ''
  end
  # </analyzeSentiment>
  # <detectLanguage>
  def DetectLanguage(inputDocuments)
    result = @textAnalyticsClient.detect_language(
        language_batch_input: inputDocuments
    )

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      puts '===== LANGUAGE DETECTION ====='
      result.documents.each do |document|
        puts "Document ID: #{document.id} , Language: #{document.detected_languages[0].name}"
      end
    else
      puts 'No results data..'
    end
    puts ''
  end
  # </detectLanguage>
  # <recognizeEntities>
  def RecognizeEntities(inputDocuments)
    result = @textAnalyticsClient.entities(
        multi_language_batch_input: inputDocuments
    )

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      puts '===== ENTITY RECOGNITION ====='
      result.documents.each do |document|
        puts "Document ID: #{document.id}"
          document.entities.each do |entity|
            puts "\tName: #{entity.name}, \tType: #{entity.type == nil ? "N/A": entity.type},\tSub-Type: #{entity.sub_type == nil ? "N/A": entity.sub_type}"
            entity.matches.each do |match|
              puts "\tOffset: #{match.offset}, \Length: #{match.length},\tScore: #{match.entity_type_score}"
            end
            puts
          end
      end
    else
      puts 'No results data..'
    end
    puts ''
  end
  # </recognizeEntites>
  
  # <extractKeyPhrases>
  def ExtractKeyPhrases(inputDocuments)
    result = @textAnalyticsClient.key_phrases(
        multi_language_batch_input: inputDocuments
    )

    if (!result.nil? && !result.documents.nil? && result.documents.length > 0)
      puts '===== KEY PHRASE EXTRACTION ====='
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
    puts ''
  end
  # </extractKeyPhrases>
end

# <vars>
key = "<paste-your-text-analytics-key-here>"
endpoint = "<paste-your-text-analytics-endpoint-here>"
# </vars>

# <clientCreation>
client = TextAnalyticsClient.new(endpoint, key)
# </clientCreation>

# <sentimentCall>
def SentimentAnalysisExample(client)
  # The documents to be analyzed. Add the language of the document. The ID can be any value.
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

  inputDocuments =  MultiLanguageBatchInput.new
  inputDocuments.documents = [input_1, input_2, input_3, input_4]

  client.AnalyzeSentiment(inputDocuments)
end
# </sentimentCall>
# <detectLanguageCall>
def DetectLanguageExample(client)
 # The documents to be analyzed.
 language_input_1 = LanguageInput.new
 language_input_1.id = '1'
 language_input_1.text = 'This is a document written in English.'

 language_input_2 = LanguageInput.new
 language_input_2.id = '2'
 language_input_2.text = 'Este es un document escrito en Español..'

 language_input_3 = LanguageInput.new
 language_input_3.id = '3'
 language_input_3.text = '这是一个用中文写的文件'

 language_batch_input = LanguageBatchInput.new
 language_batch_input.documents = [language_input_1, language_input_2, language_input_3]

 client.DetectLanguage(language_batch_input)
end
# </detectLanguageCall>
# <recognizeEntitiesCall>
def RecognizeEntitiesExample(client)
  # The documents to be analyzed.
  input_1 = MultiLanguageInput.new
  input_1.id = '1'
  input_1.language = 'en'
  input_1.text = 'Microsoft was founded by Bill Gates and Paul Allen on April 4, 1975, to develop and sell BASIC interpreters for the Altair 8800.'

  input_2 = MultiLanguageInput.new
  input_2.id = '2'
  input_2.language = 'es'
  input_2.text = 'La sede principal de Microsoft se encuentra en la ciudad de Redmond, a 21 kilómetros de Seattle.'

  multi_language_batch_input =  MultiLanguageBatchInput.new
  multi_language_batch_input.documents = [input_1, input_2]

  client.RecognizeEntities(multi_language_batch_input)
end
# </recognizeEntitiesCall>

# <keyPhrasesCall>
def KeyPhraseExtractionExample(client)
  # The documents to be analyzed.
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

  input_documents =  MultiLanguageBatchInput.new
  input_documents.documents = [input_1, input_2, input_3, input_4]

  client.ExtractKeyPhrases(input_documents)
end

DetectLanguageExample(client)
SentimentAnalysisExample(client)
RecognizeEntitiesExample(client)
KeyPhraseExtractionExample(client)
