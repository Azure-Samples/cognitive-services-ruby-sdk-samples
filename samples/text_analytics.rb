# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'net/https'
require 'uri'
require 'json'

class TextAnalyticsClient
  @@accessKey
  @@uri
  def initialize(accessKey, uri)
    @@accessKey = accessKey
    @@uri = uri
  end

  def SendRequest(path, documents)
    uri = URI(@@uri + path)

    puts 'Please wait a moment for the results to appear.'

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = "application/json"
    request['Ocp-Apim-Subscription-Key'] = @@accessKey
    request.body = documents.to_json

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request (request)
    end

    puts JSON::pretty_generate (JSON (response.body))
  end
end

def Detect_Language(textAnalyticsClient)
  documents = { 'documents': [
    { 'id' => '1', 'text' => 'This is a document written in English.' },
    { 'id' => '2', 'text' => 'Este es un document escrito en Español.' },
    { 'id' => '3', 'text' => '这是一个用中文写的文件' }
  ]}
  path = 'languages'
  textAnalyticsClient.SendRequest(path, documents)
end

def Analyze_Sentiment(textAnalyticsClient)
  documents = { 'documents': [
    { 'id' => '1', 'language' => 'en', 'text' => 'I really enjoy the new XBox One S. It has a clean look, it has 4K/HDR resolution and it is affordable.' },
    { 'id' => '2', 'language' => 'es', 'text' => 'Este ha sido un dia terrible, llegué tarde al trabajo debido a un accidente automobilistico.' }
  ]}
  path = 'sentiment'
  textAnalyticsClient.SendRequest(path, documents)
end

def Extract_KeyPhrases(textAnalyticsClient)
  documents = { 'documents': [
    { 'id' => '1', 'language' => 'en', 'text' => 'I really enjoy the new XBox One S. It has a clean look, it has 4K/HDR resolution and it is affordable.' },
    { 'id' => '2', 'language' => 'es', 'text' => 'Si usted quiere comunicarse con Carlos, usted debe de llamarlo a su telefono movil. Carlos es muy responsable, pero necesita recibir una notificacion si hay algun problema.' },
    { 'id' => '3', 'language' => 'en', 'text' => 'The Grand Hotel is a new hotel in the center of Seattle. It earned 5 stars in my review, and has the classiest decor I\'ve ever seen.' },
  ]}
  path = 'keyphrases'
  textAnalyticsClient.SendRequest(path, documents)
end

def Recognize_Entities(textAnalyticsClient)
  documents = { 'documents': [
    { 'id' => '1', 'language' => 'en', 'text' => 'Microsoft is an It company.' }
  ]}
  path = 'entities'
  textAnalyticsClient.SendRequest(path, documents)
end

accessKey = String.new("enter key here")
uri = String.new("https://westus.api.cognitive.microsoft.com/text/analytics/v2.1/")
textAnalyticsClient = TextAnalyticsClient.new(accessKey, uri)

Detect_Language(textAnalyticsClient)
Analyze_Sentiment(textAnalyticsClient)
Extract_KeyPhrases(textAnalyticsClient)
Recognize_Entities(textAnalyticsClient)
