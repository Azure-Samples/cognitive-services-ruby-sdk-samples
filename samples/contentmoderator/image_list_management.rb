# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorImageListManagementClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'

    @image_id_map = {}
    @IMG_SPORTS = {
        label: 'Sports',
        urls: [
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample4.png',
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample6.png',
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample9.png'
        ]
    }

    @IMG_SWIMSUIT = {
        label: 'Swimsuit',
        urls: [
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample1.jpg',
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample3.png',
            'https://moderatorsampleimages.blob.core.windows.net/samples/sample16.png'
        ]
    }

    @IMG_CORRECTIONS = [
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample16.png'
    ]

    @IMAGES_TO_MATCH = [
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample1.jpg',
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample4.png',
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample5.png',
        'https://moderatorsampleimages.blob.core.windows.net/samples/sample16.png'
    ]
  end

  def perform_image_list_management_sample
    puts "\t\t\tCognitive Services Content Moderator Image List Management Scenarios"
    puts "\t\t\t===================================================================="
    puts

    puts 'This will create a custom image list.'

    creation_result = create_custom_list

    if(!creation_result.id.nil?)
      list_id = creation_result.id
      puts 'This will perform various operations using the image list.'
      add_images(list_id, @IMG_SPORTS[:urls], @IMG_SPORTS[:label])
      add_images(list_id, @IMG_SWIMSUIT[:urls], @IMG_SWIMSUIT[:label])

      get_all_image_ids(list_id)
      update_list_details(list_id)
      get_list_details(list_id)

      puts 'Be sure to refresh search index.'
      refresh_search_index(list_id)

      puts 'Waiting 2 minutes to allow the server time to propagate the index changes.'
      sleep(120)

      puts 'This will match images against the image list.'
      match_images(list_id, @IMAGES_TO_MATCH)

      puts 'This will remove the images and refresh the search index again.'
      remove_images(list_id, @IMG_CORRECTIONS)
      refresh_search_index(list_id)

      puts 'Waiting 2 minutes to allow the server time to propagate the index changes.'
      sleep(120)
      puts 'Match images again against the image list. The removed image should not get matched.'
      match_images(list_id, @IMAGES_TO_MATCH)

      puts 'Delete and verify.'
      delete_all_images(list_id)
      delete_custom_list(list_id)
      get_all_list_ids
    end
  end

  private
  def create_custom_list
    @body = Body.new
    @body.name = 'MyList'
    @body.description = 'A sample list'
    @body.metadata = BodyMetadata.new
    @body.metadata.key_one = 'Acceptable'
    @body.metadata.key_two = 'Potentially racy'

    puts "Creating List: #{@body.name}"

    result = @content_moderator_latest_profile_client_obj.list_management_image_lists.create('application/json', @body)
    sleep(3)

    if(!result.nil?)
      puts 'Response for creating list'
      puts "ImageList Id: #{result.id}"
      puts "ImageList Name: #{result.name}"
      puts "ImageList description: #{result.description}"
      puts "ImageList Metadata: Key One - #{result.metadata.key_one}:Key Two - #{result.metadata.key_two} "
    else
      puts "Couldn't get the result for creating lists"
    end

    result
  end

  def delete_custom_list(list_id)
    puts "Deleting List: #{list_id}"
    @content_moderator_latest_profile_client_obj.list_management_image_lists.delete(list_id.to_s)
    sleep(5)
  end

  def add_images(list_id, images_to_add, label)
    images_to_add.each do |image_url_to_add|
      puts "Adding #{image_url_to_add} to list #{list_id} with label #{label}."

      image_url = ImageUrl.new
      image_url.data_representation = 'URL'
      image_url.value = image_url_to_add

      result = @content_moderator_latest_profile_client_obj.list_management_image.add_image_url_input(list_id.to_s, 'application/json', image_url, label: label)
      @image_id_map[image_url_to_add] = result.content_id.to_i
      sleep(5)
    end
  end

  def remove_images(list_id, images_to_remove)
    images_to_remove.each do |image_to_remove|
      puts "Removing Image: #{image_to_remove}"
      result = @content_moderator_latest_profile_client_obj.list_management_image.delete_image(list_id, @image_id_map[image_to_remove])
      puts "Result #{result}"
      sleep(5)
    end
  end

  def delete_all_images(list_id)
    puts "Deleting all images from list #{list_id}."
    result = @content_moderator_latest_profile_client_obj.list_management_image.delete_all_images(list_id.to_s)
    puts "Deletion Result #{result}"
    sleep(5)
  end

  def get_all_list_ids
    puts 'Getting all image list IDs.'
    result = @content_moderator_latest_profile_client_obj.list_management_image_lists.get_all_image_lists
    puts "Number of Custom Lists: #{result.length}"
    result.each_with_index do |entry, index|
      puts "  #{index}. #{entry.id}"
    end
  end

  def get_all_image_ids(list_id)
    puts "Getting all image IDs for list #{list_id}."
    image_ids = @content_moderator_latest_profile_client_obj.list_management_image.get_all_image_ids(list_id)
    puts "Content Source: #{image_ids.content_source}"
    puts "Status Code: #{image_ids.status.code}"
    puts "Status Description: #{image_ids.status.description}"
    puts "Status exception: #{image_ids.status.exception}"
    puts "Tracking Id: #{image_ids.tracking_id}"
    image_ids.content_ids.each_with_index do |content_id, index|
      puts "Content Id #{index}: #{content_id}"
    end
    sleep(5)
  end

  def update_list_details(list_id)
    puts "Updating details for list #{list_id}."
    @body.name = 'Swimsuits and sports'
    @content_moderator_latest_profile_client_obj.list_management_image_lists.update(list_id.to_s, 'application/json', @body)
    puts "List #{list_id} updated."
    sleep(5)
  end

  def get_list_details(list_id)
    puts "Getting details for list #{list_id}."
    result = @content_moderator_latest_profile_client_obj.list_management_image_lists.get_details(list_id)
    puts "Id: #{result.id}"
    puts "Name: #{result.name}"
    puts "Description: #{result.description}"
    puts "Metadata: Key 1: #{result.metadata.key_one} - Key 2: #{result.metadata.key_two}"
    sleep(5)
  end

  def refresh_search_index(list_id)
    puts "Refreshing the search index for list #{list_id}."
    result = @content_moderator_latest_profile_client_obj.list_management_image_lists.refresh_index_method(list_id)
    puts "Content Source Id: #{result.content_source_id}"
    puts "Is Update Success: #{result.is_update_success}"
    puts "Status Code: #{result.status.code}"
    puts "Status Description: #{result.status.description}"
    puts "Status exception: #{result.status.exception}"
    puts "Tracking Id: #{result.tracking_id}"
    puts 'Advanced Info' if result.advanced_info.length > 0
    result.advanced_info.each do |ainfo|
      puts "Key 1: #{ainfo.key_one} - Key 2: #{ainfo.key_two}"
    end
    sleep(5)
  end

  def match_images(list_id, images_to_match)
    images_to_match.each do |image_url|
      puts "Matching image #{image_url} against list #{list_id}."

      image_url_param = ImageUrl.new
      image_url_param.data_representation = 'URL'
      image_url_param.value = image_url

      result = @content_moderator_latest_profile_client_obj.image_moderation.match_url_input('application/json', image_url_param, list_id: list_id.to_s)
      puts "Tracking Id: #{result.tracking_id}"
      puts "Cache Id: #{result.cache_id}"
      puts "Is Match: #{result.is_match}"
      puts "Status Code: #{result.status.code}"
      puts "Status Description: #{result.status.description}"
      puts "Status exception: #{result.status.exception}"
      puts 'Matches' if result.matches.length > 0
      result.matches.each do |match|
        puts "  Score: #{match.score}"
        puts "  Match Id: #{match.match_id}"
        puts "  Source: #{match.source}"
        puts "  Label: #{match.label}"
        puts '  Tags' if match.tags.length > 0
        match.tags.each do |tag|
          puts "    #{tag}"
        end
      end
      sleep(5)
    end
  end
end
