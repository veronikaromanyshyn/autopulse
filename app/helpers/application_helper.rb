module ApplicationHelper
  def uah(amount)
    number_to_currency(amount, unit: "грн", format: "%n %u", precision: 0, delimiter: " ")
  end

  def stars(rating)
    full = rating.to_f.round
    content_tag(:span, class: "stars", title: "Оцінка #{rating}") do
      safe_join((1..5).map { |i| content_tag(:span, "★", class: i <= full ? "on" : "off") })
    end
  end

  def product_image(product, css = "product-img")
    image_tag("products/#{product.image.presence || 'default.svg'}", alt: product.name, class: css)
  end

  def status_badge(order)
    content_tag(:span, order.status_name, class: "badge badge-#{order.status}")
  end

  def errors_for(record)
    return unless record.errors.any?
    content_tag(:div, class: "form-errors") do
      content_tag(:strong, "Будь ласка, виправте помилки:") +
        content_tag(:ul, safe_join(record.errors.full_messages.map { |m| content_tag(:li, m) }))
    end
  end
end
