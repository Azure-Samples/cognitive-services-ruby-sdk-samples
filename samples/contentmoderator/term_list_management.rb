# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'azure_cognitiveservices_contentmoderator'

include Azure::CognitiveServices::ContentModerator::V1_0::Models

class ContentModeratorTermListManagementClient
  def initialize(subscription_key)
    cognitive_services_credentials =
        MsRestAzure::CognitiveServicesCredentials.new(subscription_key)
    @content_moderator_latest_profile_client_obj =
        Azure::ContentModerator::Profiles::Latest::Client.new({
            credentials: cognitive_services_credentials
        })
    @content_moderator_latest_profile_client_obj.base_url='https://westus2.api.cognitive.microsoft.com/'
  end

  def perform_term_list_management_sample
    puts "\t\t\tCognitive Services Content Moderator Term List Scenarios"
    puts "\t\t\t========================================================"
    puts

    puts 'Create a term list and populate with terms.'
    list_id = create_term_list
    update_term_list(list_id, 'name', 'description')
    add_term(list_id, 'term1')
    add_term(list_id, 'term2')
    get_all_terms(list_id)
    refresh_search_index(list_id)
    puts 'Screen for the populated terms and delete one term from list.'
    text = "This text contains the terms 'term1' and 'term2'."
    screen_text(list_id, text)
    delete_term(list_id, 'term_1')
    refresh_search_index(list_id)
    puts 'Screen for populated terms again and then delete terms and list.'
    screen_text(list_id, text)
    delete_all_terms(list_id)
    delete_term_list(list_id)
    puts 'Done with sample.'
  end

  private
  def create_term_list
    puts 'Creating term list.'

    body = Body.new
    body.name = 'Term list name'
    body.description = 'Term list description'

    list = @content_moderator_latest_profile_client_obj.list_management_term_lists.create('application/json', body)

    if(list.id.nil?)
      raise 'TermList.id value missing.'
    end

    list_id = list.id
    puts "Termlist created. ID: #{list_id}"
    sleep(5)
    list_id.to_s
  end

  def update_term_list(list_id, name, description)
    puts "Updating information for term list with ID #{list_id}."
    body = Body.new
    body.name = name
    body.description = description
    @content_moderator_latest_profile_client_obj.list_management_term_lists.update(list_id, 'application/json', body)
    sleep(5)
  end

  def add_term(list_id, term)
    puts "Adding term #{term} to term list with ID #{list_id}."
    @content_moderator_latest_profile_client_obj.list_management_term.add_term(list_id, term, 'eng')
    sleep(5)
  end

  def get_all_terms(list_id)
    puts "Getting terms in term list with ID #{list_id}."
    terms = @content_moderator_latest_profile_client_obj.list_management_term.get_all_terms(list_id, 'eng')
    data = terms.data
    data.terms.each do |data_term|
      puts data_term.term
    end
    sleep(5)
  end

  def refresh_search_index(list_id)
    puts "Refreshing search index for term list with ID #{list_id}."
    @content_moderator_latest_profile_client_obj.list_management_term_lists.refresh_index_method(list_id, 'eng')
    sleep(10)
  end

  def screen_text(list_id, text)
    puts "Screening text: #{text} using term list with ID #{list_id}."
    screen = @content_moderator_latest_profile_client_obj.text_moderation.screen_text('eng', 'text/plain', text, list_id: list_id)
    if(!screen.terms.nil?)
      screen.terms.each do |term|
        puts "Found term: #{term.term} from list ID #{term.list_id} at index #{term.index}."
      end
    else
      puts 'No terms from the term list were detected in the text.'
    end
    sleep(10)
  end

  def delete_term(list_id, term)
    puts "Removed term #{term} from term list with ID #{list_id}."
    @content_moderator_latest_profile_client_obj.list_management_term.delete_term(list_id, term, 'eng')
    sleep(5)
  end

  def delete_all_terms(list_id)
    puts "Removing all terms from term list with ID #{list_id}."
    @content_moderator_latest_profile_client_obj.list_management_term.delete_all_terms(list_id, 'eng')
    sleep(10)
  end

  def delete_term_list(list_id)
    puts "Deleting term list with ID #{list_id}."
    result = @content_moderator_latest_profile_client_obj.list_management_term_lists.delete(list_id)
    sleep(5)
  end
end
