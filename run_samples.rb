# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require_relative 'cognitive_services_samples_options_parser'
require_relative 'samples/computer_vision'
require_relative 'samples/custom_search'
require_relative 'samples/entity_search'
require_relative 'samples/image_search'
require_relative 'samples/news_search'
require_relative 'samples/spell_check'
require_relative 'samples/text_analytics'
require_relative 'samples/video_search'
require_relative 'samples/web_search'
require_relative 'samples/contentmoderator/image_jobs'
require_relative 'samples/contentmoderator/term_list_management'
require_relative 'samples/contentmoderator/image_reviews'
require_relative 'samples/contentmoderator/text_moderation'
require_relative 'samples/contentmoderator/video_transcript_review'
require_relative 'samples/contentmoderator/image_moderation'
require_relative 'samples/contentmoderator/video_reviews'
require_relative 'samples/contentmoderator/image_list_management'

def check_for_environment_variable(env_variable_names = [])
  env_variable_names.each do |env_variable_name|
    if(!ENV.has_key?env_variable_name)
      raise "#{env_variable_name} environment variable is not set. Please set it to execute this sample."
    end
  end
end

options = CognitiveServicesSamplesOptionsParser.options ARGV

case options.sdk
  when 'azure_cognitiveservices_computervision'
    check_for_environment_variable(['COMPUTERVISION_SUBSCRIPTION_KEY'])
    obj = ComputerVisionClient.new(ENV.fetch('COMPUTERVISION_SUBSCRIPTION_KEY'))
    obj.perform_sample_computer_vision
  when 'azure_cognitiveservices_customsearch'
    check_for_environment_variable(['CUSTOMSEARCH_SUBSCRIPTION_KEY', 'CUSTOMSEARCH_SEARCH_CONFIG'])
    obj = CustomSearchClient.new(ENV.fetch('CUSTOMSEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_custom_search(ENV.fetch('CUSTOMSEARCH_SEARCH_CONFIG').to_i)
  when 'azure_cognitiveservices_entitysearch'
    check_for_environment_variable(['ENTITYSEARCH_SUBSCRIPTION_KEY'])
    obj = EntitySearchClient.new(ENV.fetch('ENTITYSEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_entity_search
  when 'azure_cognitiveservices_imagesearch'
    check_for_environment_variable(['IMAGESEARCH_SUBSCRIPTION_KEY'])
    obj = ImageSearchClient.new(ENV.fetch('IMAGESEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_image_search
  when 'azure_cognitiveservices_newssearch'
    check_for_environment_variable(['NEWSSEARCH_SUBSCRIPTION_KEY'])
    obj = NewsSearchClient.new(ENV.fetch('NEWSSEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_news_search
  when 'azure_cognitiveservices_spellcheck'
    check_for_environment_variable(['SPELLCHECK_SUBSCRIPTION_KEY'])
    obj = SpellCheckClient.new(ENV.fetch('SPELLCHECK_SUBSCRIPTION_KEY'))
    obj.perform_sample_spell_check
  when 'azure_cognitiveservices_textanalytics'
    check_for_environment_variable(['TEXTANALYTICS_SUBSCRIPTION_KEY'])
    obj = TextAnalyticsClient.new(ENV.fetch('TEXTANALYTICS_SUBSCRIPTION_KEY'))
    obj.perform_sample_text_analytics
  when 'azure_cognitiveservices_videosearch'
    check_for_environment_variable(['VIDEOSEARCH_SUBSCRIPTION_KEY'])
    obj = VideoSearchClient.new(ENV.fetch('VIDEOSEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_video_search
  when 'azure_cognitiveservices_websearch'
    check_for_environment_variable(['WEBSEARCH_SUBSCRIPTION_KEY'])
    obj = WebSearchClient.new(ENV.fetch('WEBSEARCH_SUBSCRIPTION_KEY'))
    obj.perform_sample_web_search
  when 'azure_cognitiveservices_contentmoderator-imagejobs'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY', 'CONTENTMODERATOR_TEAM_NAME'])
    obj = ContentModeratorImageJobsClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_image_jobs_sample(ENV.fetch('CONTENTMODERATOR_TEAM_NAME'))
  when 'azure_cognitiveservices_contentmoderator-termlist'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY'])
    obj = ContentModeratorTermListManagementClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_term_list_management_sample
  when 'azure_cognitiveservices_contentmoderator-imagereviews'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY', 'CONTENTMODERATOR_TEAM_NAME'])
    obj = ContentModeratorImageReviewsClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_image_reviews_sample(ENV.fetch('CONTENTMODERATOR_TEAM_NAME'))
  when 'azure_cognitiveservices_contentmoderator-textmoderation'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY'])
    obj = ContentModeratorTextModerationClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_text_moderation_sample
  when 'azure_cognitiveservices_contentmoderator-videotranscriptreview'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY', 'CONTENTMODERATOR_TEAM_NAME'])
    obj = ContentModeratorVideoTranscriptReviewClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_video_transcript_review_sample(ENV.fetch('CONTENTMODERATOR_TEAM_NAME'))
  when 'azure_cognitiveservices_contentmoderator-imagemoderation'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY'])
    obj = ContentModeratorImageModerationClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_image_moderation_sample
  when 'azure_cognitiveservices_contentmoderator-videoreview'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY', 'CONTENTMODERATOR_TEAM_NAME'])
    obj = ContentModeratorVideoReviewsClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_video_reviews_sample(ENV.fetch('CONTENTMODERATOR_TEAM_NAME'))
  when 'azure_cognitiveservices_contentmoderator-imagelistmanagement'
    check_for_environment_variable(['CONTENTMODERATOR_SUBSCRIPTION_KEY'])
    obj = ContentModeratorImageListManagementClient.new(ENV.fetch('CONTENTMODERATOR_SUBSCRIPTION_KEY'))
    obj.perform_image_list_management_sample
end
