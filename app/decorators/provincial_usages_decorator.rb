class ProvincialUsagesDecorator < Draper::CollectionDecorator
  def t_headers
    plain_headers.map do |header|
      h.t("provincial_usages.#{header}")
    end
  end

  private

  def plain_headers
    %w(code location visit unique delivered most_request)
  end
end
