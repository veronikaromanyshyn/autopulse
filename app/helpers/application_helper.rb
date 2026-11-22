module ApplicationHelper
  def uah(amount)
    content_tag(:span, number_to_currency(amount, unit: "грн", format: "%n %u", precision: 0, delimiter: " "),
                class: "money")
  end

  def stars(rating)
    full = rating.to_f.round
    content_tag(:span, class: "stars", title: "Оцінка #{rating}") do
      safe_join((1..5).map { |i| content_tag(:span, "★", class: i <= full ? "on" : "off") })
    end
  end

  # Зображення товару: файл з app/assets/images/products (svg/jpg/png) або пряме посилання на фото
  def product_image(product, css = "product-img")
    src = product.image.presence || "default.svg"
    src = "products/#{src}" unless src.start_with?("http://", "https://")
    image_tag(src, alt: product.name, class: css, loading: "lazy", referrerpolicy: "no-referrer",
              onerror: "this.onerror=null;this.src='#{asset_path('products/default.svg')}'")
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
