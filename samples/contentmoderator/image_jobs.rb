# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorImageJobsClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'
  end

  def perform_image_jobs_sample(team_name)
    puts "\t\t\tCognitive Services Content Moderator Image Jobs Scenarios"
    puts "\t\t\t========================================================="
    puts

    content = Content.new
    content.content_value = 'https://moderatorsampleimages.blob.core.windows.net/samples/sample2.jpg'

    puts 'Create moderation job for an image'
    puts '=================================='
    job_result = @content_moderator_latest_profile_client_obj.reviews.create_job(
        team_name, 'image',  'contentID', 'default', 'application/json', content)
    job_id = job_result.job_id
    puts "Job ID: #{job_id}"
    puts
    puts

    sleep(2)
    puts 'Get job status before review'
    puts '============================'
    job_details = @content_moderator_latest_profile_client_obj.reviews.get_job_details(team_name, job_id)
    get_job_details(job_details)

    sleep(50)
    puts 'Get job status after review'
    puts '============================'
    job_details = @content_moderator_latest_profile_client_obj.reviews.get_job_details(team_name, job_id)
    get_job_details(job_details)
  end

  private
  def get_job_details(job_details)
    puts "Job Details Status: #{job_details.status}"
    puts
    puts 'Job Execution Report'
    puts '===================='
    job_details.job_execution_report.each do |entry|
      puts "    #{entry.msg}"
    end

    if(job_details.result_meta_data.length > 0 )
      puts
      puts
      puts 'Result Meta Data'
      puts '================'
    end
    job_details.result_meta_data.each do |entry|
      puts "    #{entry.key} - #{entry.value}"
    end
  end
end
