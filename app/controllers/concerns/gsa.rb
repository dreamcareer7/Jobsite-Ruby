module GSA
  require 'googleauth'
  require 'google/apis/compute_v1'

  def return_access_token
    compute = Google::Apis::ComputeV1::ComputeService.new

    scopes =  ["https://www.googleapis.com/auth/analytics.readonly", "https://www.googleapis.com/auth/analytics"]
    create_auth = compute.authorization = Google::Auth.get_application_default(scopes)

    create_auth.fetch_access_token!
    
  end

end
