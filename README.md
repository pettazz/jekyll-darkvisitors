# Jekyll Dark Visitors

Jekyll plugin to generate a robots.txt to block AI scrapers via the [Dark Visitors](https://darkvisitors.com) API.

## Dark Visitors

[Dark Visitors](https://darkvisitors.com) is an excellent service (with which I am not affiliated, just think is very useful!) that helps you track and/or block AI scrapers and crawlers. They keep a constantly updated list of agents whether they are publicly documented or just discovered out there, and use this to generate a robots.txt file to lay out the ground rules for their using your site.

They provide a WordPress plugin for real-time updates and enforcement, but pre-generated static sites need a different approach. At build time, this plugin will fetch the latest robots.txt information based on your settings and automatically include it in the final site. 

### What is robots.txt?

A robots.txt file saved at the root of your website is a file meant to explain to bots (crawlers, indexers, etc) how to use your site. You can provide a sitemap that helps Google index your site, or exclude particular paths from being crawled at all. It's a list of entries that look like this, which would tell Google not to crawl anything in the /private/ directory:

  ```
  User-agent: Googlebot
  Disallow: /private/
  ```

robots.txt is not an enforcement mechanism, bots could simply ignore it if they choose not to be respectful, so this is not a guarantee that anything will be excluded.

## Installation

(https://jekyllrb.com/docs/plugins/installation/)

One of two options:

### Bundler Config
:warning: **If using bundler with a vendor prefix, this is the required method**

1. In your `Gemfile`, add the `jekyll_plugins` group if it doesn't already exist, and add `jekyll-darkvisitors` to it. For example: 

  ```ruby
  group :jekyll_plugins do
    gem "jekyll-darkvisitors"
  end
  ```

2. Tell bundler to install any plugins with

  ```
  $ bundle install
  ```


### Jekyll Config

1. In your `_config.yml`, add the `plugins` key if it doesn't already exist, and add a value of `jekyll-darkvisitors`. For example:

  ```yaml
  plugins: 
    - jekyll-darkvisitors
  ```

2. Install this gem

  ```
  $ gem install jekyll-darkvisitors
  ```

## Usage

1. If you haven't already, sign up with [Dark Visitors](https://darkvisitors.com) and [create a Project](https://darkvisitors.com/docs/robots-txt) for your site. 

2. In your `_config.yml`, add your `darkvisitors` settings. The only required field is `access_token`.

  ```yaml
  darkvisitors:
    access_token: 1234-abcd
  ```

:warning: **Remember that your `access_token` is private and shoud *never be checked into a public git repo*!** See the [flying-jekyll quickstart project](https://github.com/pettazz/flying-jekyll/) for an example of how to use secrets with GitHub Actions to provide this at build time.

3. Add optional settings if needed, for example:

  ```yaml
  darkvisitors:
    access_token: 1234-abcd
    append_existing: true
    agent_types:
      - AI Data Scraper
      - AI Assistant
      - AI Search Crawler
      - Undocumented AI Agent
    disallow: /
  ```

### Settings

- `access_token` [required] Your Dark Visitors access token *keep this secret!*
- `append_existing` [optional, default: `false`] If `false`, skip generation entirely if there is an existing robots.txt file in the site. If `true`, generate a new robots.txt by appending the Dark Visitors content to the end of the existing one.
- `agent_types` [optional, default: `[AI Data Scraper, Undocumented AI Agent]`] A list of agent types to request from Dark Visitors. 
- `disallow` [optional, default: `/`] A string path to use for the Disallow directive in the generated robots.txt. 