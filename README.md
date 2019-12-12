---
page_type: sample
languages:
- ruby
products:
- azure
description: "These samples will show you how to get up and running using the SDKs for various Cognitive Services."
urlFragment: cognitive-services-ruby-sdk-samples
---

# Cognitive Services SDK Samples (Ruby)

These samples will show you how to get up and running using the SDKs for various Cognitive Services. They'll cover a few rudimentary use cases and hopefully express best practices for interacting with the data from these APIs.

## Features

This project framework provides examples for the following services:

* Using the [Computer Vision SDK](https://rubygems.org/gems/azure_cognitiveservices_computervision) for the [Computer Vision API](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/)
* Using the [Content Moderator SDK](https://rubygems.org/gems/azure_cognitiveservices_contentmoderator) for the [Content Moderator API](https://azure.microsoft.com/en-us/services/cognitive-services/content-moderator/)
* Using the [Custom Search SDK](https://rubygems.org/gems/azure_cognitiveservices_customsearch) for the [Custom Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-custom-search/)
* Using the [Entity Search SDK](https://rubygems.org/gems/azure_cognitiveservices_entitysearch) for the [Entity Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-entity-search-api/)
* Using the [Image Search SDK](https://rubygems.org/gems/azure_cognitiveservices_imagesearch) for the [Image Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-image-search-api/)
* Using the [News Search SDK](https://rubygems.org/gems/azure_cognitiveservices_newssearch) for the [News Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-news-search-api/)
* Using the [Spell Check SDK](https://rubygems.org/gems/azure_cognitiveservices_spellcheck) for the [Spell Check API](https://azure.microsoft.com/en-us/services/cognitive-services/spell-check/)
* Using the [Text Analytics SDK](https://rubygems.org/gems/azure_cognitiveservices_textanalytics) for the [Text Analytics API](https://azure.microsoft.com/en-us/services/cognitive-services/text-analytics/)
* Using the [Video Search SDK](https://rubygems.org/gems/azure_cognitiveservices_videosearch) for the [Video Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-video-search-api/)
* Using the [Web Search SDK](https://rubygems.org/gems/azure_cognitiveservices_websearch) for the [Web Search API](https://azure.microsoft.com/en-us/services/cognitive-services/bing-web-search-api/)

## Run this sample


1. If you don't already have it, [get ruby](https://www.ruby-lang.org/en/documentation/installation/).

1. Clone the repository.

    ```
    git clone https://github.com/Azure-Samples/cognitive-services-ruby-sdk-samples.git
    ```

1. Install the dependencies.

    ```
    cd cognitive-services-ruby-sdk-samples
    bundle install
    ```

1. Get a cognitive services API key with which to authenticate the SDK's calls. [Sign up here](https://azure.microsoft.com/en-us/services/cognitive-services/directory/) by navigating to the right service and acquiring an API key. You can get a trial key for **free** which will expire after 30 days.

2. Set the following environment variables. You only need to set the environment variables for which you want to run the samples.

<table>
  <tr>
    <th>No.</th>
    <th>Service Name</th>
    <th>Environment Variable to set</th>
    <th>Notes</th>
  </tr>
  <tr>
    <td>1</td>
    <td>azure_cognitiveservices_computervision</td>
    <td>COMPUTERVISION_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td rowspan=2>2</td>
    <td rowspan=2>azure_cognitiveservices_customsearch</td>
    <td>CUSTOMSEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>CUSTOMSEARCH_SEARCH_CONFIG</td>
    <td>You can set up the search config <a href="https://www.customsearch.ai">here</a></td>
  </tr>
  <tr>
    <td>3</td>
    <td>azure_cognitiveservices_entitysearch</td>
    <td>ENTITYSEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>4</td>
    <td>azure_cognitiveservices_imagesearch</td>
    <td>IMAGESEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>5</td>
    <td>azure_cognitiveservices_newssearch</td>
    <td>NEWSSEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>6</td>
    <td>azure_cognitiveservices_spellcheck</td>
    <td>SPELLCHECK_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>7</td>
    <td>azure_cognitiveservices_textanalytics</td>
    <td>TEXTANALYTICS_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>8</td>
    <td>azure_cognitiveservices_videosearch</td>
    <td>VIDEOSEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>9</td>
    <td>azure_cognitiveservices_websearch</td>
    <td>WEBSEARCH_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td rowspan=2>10</td>
    <td rowspan=2>azure_cognitiveservices_contentmoderator</td>
    <td>CONTENTMODERATOR_SUBSCRIPTION_KEY</td>
    <td>Your Service Key</td>
  </tr>
  <tr>
    <td>CONTENTMODERATOR_TEAM_NAME</td>
    <td>You can create and get the team name <a href="http://contentmoderator.cognitive.microsoft.com/">here</a></td>
  </tr>
</table>

You can set the environment variable as:

    ```
    export {your key}={your value}
    ```

    > [AZURE.NOTE] On Windows, use `set` instead of `export`.

3. Run the sample.

    ```
    ruby run_samples.rb --sdk={sample_to_run}
    ```

4. To know the possible values of ```sdk```, you can run the following command:

    ```
    ruby run_samples.rb --help
    ```

To see the code of each example, simply look at the examples in the Samples folder. They are written to be isolated in scope so that you can see only what you're interested in.
