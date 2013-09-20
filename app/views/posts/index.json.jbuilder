json.array!(@posts) do |post|
  json.extract! post, :url, :title, :description, :user_id
  json.url post_url(post, format: :json)
end
