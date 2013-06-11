module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    mail = user.respond_to?("email") ? user.email.downcase : "nope"
    name = user.respond_to?("name") ? user.email.downcase : ""
    gravatar_id = Digest::MD5::hexdigest(mail)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: name, class: "gravatar")
  end
end
