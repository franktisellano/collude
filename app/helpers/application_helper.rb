module ApplicationHelper
  def gravatar_for(user, options = { size: 48 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, class: "gravatar", width: size, height: size, alt: user.name)
  end
end
