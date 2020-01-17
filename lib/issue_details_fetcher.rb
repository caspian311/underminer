require 'net/http'
require 'uri'
require 'json'
require 'byebug'

class IssueDetailsFetcher
  def fetch(issue_id)
    response = make_issue_details_request issue_id

    raise 'Request was a failure' unless response.is_a?(Net::HTTPSuccess)

    format_response response
  end

  private 
  def format_response(response)
    data = JSON.parse(response.body)

    {
      id: data['issue']['id'],
      subject: data['issue']['subject'],
      category: category(data),
      status: data['issue']['status']['name'],
      journals: data['issue']['journals']
    }
  end

  def category(data)
    category = ''
    if data['issue'].key?('category')
      unless data['issue']['category'].nil?
        if data['issue']['category'].key?('name')
          unless data['issue']['category']['name'].nil?
            category = data['issue']['category']['name']
          end
        end
      end
    end
  end

  def make_issue_details_request(issue_id)
    header = {
      'Content-Type': 'application/json',
      'X-Redmine-API-Key': Config.api_key
    }
    uri = issue_details_uri issue_id
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, header)

    http.request(request)
  end

  def issue_details_uri(issue_id)
    url = "#{Config.base_url}/issues/#{issue_id}.json"
    uri = URI(url)
    params = {
      include: 'journals'
    }
    uri.query = URI.encode_www_form(params)
    uri
  end
end