# frozen_string_literal: true

module ApplicationHelper
  include AuthConcern

  def link_to_commit(check, ops = {})
    slug = check.repository.full_name
    link = "https://github.com/#{slug}/commit/#{check.reference}"

    link_to(check.reference, link, target: '_blank', rel: 'noopener', **ops) if check.reference.present?
  end

  def link_to_file(check, file_path, ops = {})
    slug = check.repository.full_name
    link = "https://github.com/#{slug}/tree/#{check.reference}/#{file_path}"

    link_to(file_path, link, target: '_blank', rel: 'noopener', **ops) if file_path.present?
  end
end
