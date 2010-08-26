# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # an alternative to commenting out code, just wrap in a hide block
  # which acts like a black hole
  def hide(&block)
    # don't yield!
  end

  def file_type(document)
    media_type = document.resource_content_type.split('/').first
    sub_type = document.resource_content_type.split('/').last
    return media_type.upcase if %w(video image audio text).include? media_type

    return 'WORD' if sub_type.include? 'word'
    return 'EXCEL' if sub_type.include? 'excel'
    return 'POWERPOINT' if sub_type.include? 'powerpoint'
    return 'PDF' if sub_type.include? 'pdf'

    'UNKNOWN'
  end

  def page_title
    Settings.site.title.prefix + (@page_title || Settings.site.title.untitled) + Settings.site.title.suffix
  end

  def month_name(num)
    Date::MONTHNAMES[num]
  end

  # Renders a meta tag for use in the HEAD section of an HTML document.
  def meta_tag(name, value, http_equiv = false)
    return nil if value.blank?
    http_equiv = true if %w{expires pragma content-type content-script-type content-style-type default-style content-language refresh window-target cache-control vary}.include? name
    return tag(:meta, :name => name, :content => value) unless http_equiv
    tag :meta, :"http-equiv" => name, :content => value
  end

  # meta_tag defaults
  def meta_tags
    the_meta_tags = []
    the_meta_tags << meta_tag("description", @meta_description) if @meta_description
    the_meta_tags << meta_tag("keywords", @meta_keywords) if @meta_keywords
    the_meta_tags.join("\n")
  end

  def development_mode?
    not ENV["RAILS_ENV"] == 'production'
  end
end
