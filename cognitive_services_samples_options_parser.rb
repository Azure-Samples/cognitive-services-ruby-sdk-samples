# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'optparse'
require 'ostruct'

SAMPLES_AVAILABLE = [
    'azure_cognitiveservices_computervision',
    'azure_cognitiveservices_customsearch',
    'azure_cognitiveservices_entitysearch',
    'azure_cognitiveservices_imagesearch',
    'azure_cognitiveservices_newssearch',
    'azure_cognitiveservices_spellcheck',
    'azure_cognitiveservices_textanalytics',
    'azure_cognitiveservices_videosearch',
    'azure_cognitiveservices_websearch',
    'azure_cognitiveservices_contentmoderator-imagejobs',
    'azure_cognitiveservices_contentmoderator-termlist',
    'azure_cognitiveservices_contentmoderator-imagereviews',
    'azure_cognitiveservices_contentmoderator-textmoderation',
    'azure_cognitiveservices_contentmoderator-videotranscriptreview',
    'azure_cognitiveservices_contentmoderator-imagemoderation',
    'azure_cognitiveservices_contentmoderator-videoreview',
    'azure_cognitiveservices_contentmoderator-imagelistmanagement'
]

class CognitiveServicesSamplesOptionsParser
  def self.parse(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.on('-sSDK', '--sdk=SDK', "Cognitive Services SDK sample to execute. Permissible Values: #{SAMPLES_AVAILABLE}") do |sdk|
        if !SAMPLES_AVAILABLE.include?sdk
          raise OptionParser::InvalidOption.new("#{sdk} is not a valid input for sdk. It must be one of #{SAMPLES_AVAILABLE}")
        end
        options.sdk = sdk
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end

  def self.options(args)
    args << '-h' if args.empty?
    options = self.parse(args)
    mandatory_params = [:sdk]
    missing_params = mandatory_params.select{|param| options[param].nil?}
    raise OptionParser::MissingArgument.new(missing_params.join(', ')) unless missing_params.empty?
    options
  end
end