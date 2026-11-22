# Початкове наповнення бази даних інтернет-магазину AutoPulse
# Запуск: bin/rails db:seed

puts "Очищення таблиць..."
[OrderItem, Order, CartItem, Cart, Review, FeedbackMessage, Product, Category, DeliveryMethod, User].each(&:delete_all)

puts "Користувачі..."
admin = User.create!(name: "Адміністратор", email: "admin@autopulse.ua", phone: "+380671112233",
                     password: "admin123", admin: true)
buyers = [
  ["Олег Ковальчук", "oleg@example.com", "+380501234567"],
  ["Ірина Савчук", "iryna@example.com", "+380631112244"],
  ["Андрій Мельник", "andrii@example.com", "+380972223355"],
  ["Марта Бойко", "marta@example.com", nil]
].map { |n, e, p| User.create!(name: n, email: e, phone: p, password: "password") }

puts "Категорії..."
cats = [
  ["Моторні оливи", "oils"], ["Фільтри", "filters"], ["Гальмівна система", "brakes"],
  ["Акумулятори", "batteries"], ["Запалювання", "ignition"], ["Освітлення", "lighting"],
  ["Склоочисники", "wipers"], ["Аксесуари", "accessories"]
].each_with_index.to_h { |(name, slug), i| [slug, Category.create!(name: name, slug: slug, position: i)] }

puts "Способи доставки..."
DeliveryMethod.create!([
  { name: "Нова пошта — відділення", code: "np_branch", price: 80, free_from: 2000, position: 1,
    description: "1–2 дні, безкоштовно від 2 000 грн" },
  { name: "Нова пошта — кур'єр", code: "courier", price: 120, position: 2,
    description: "Доставка за адресою, 1–2 дні" },
  { name: "Укрпошта", code: "ukrposhta", price: 50, position: 3,
    description: "3–5 днів, найдешевший варіант" },
  { name: "Самовивіз з магазину", code: "pickup", price: 0, position: 4,
    description: "м. Івано-Франківськ, вул. Карпатська, 15 — того ж дня" }
])

puts "Товари..."
P = lambda do |cat, name, brand, sku, price, stock, image, compat, desc, old: nil, featured: false|
  Product.create!(category: cats[cat], name: name, brand: brand, sku: sku, price: price, old_price: old,
                  stock: stock, image: image, compatibility: compat, description: desc, featured: featured)
end

P.("oils", "Моторна олива Castrol EDGE 5W-30 LL, 4 л", "Castrol", "CAS-15669E", 1890, 24, "oil-castrol.svg",
   "VAG 504.00/507.00, BMW LL-04, Audi A4/A6 TDI",
   "Синтетична моторна олива з технологією Fluid TITANIUM. Схвалення VW 504.00/507.00 для бензинових і дизельних двигунів з сажовим фільтром. Подовжений інтервал заміни до 30 000 км.",
   old: 2150, featured: true)
P.("oils", "Моторна олива Mobil 1 ESP 5W-30, 4 л", "Mobil", "MOB-154297", 2040, 15, "oil-mobil.svg",
   "MB 229.51, VW 504/507, BMW LL-04",
   "Повністю синтетична олива з низьким вмістом зольності (Low SAPS). Захищає системи нейтралізації відпрацьованих газів.")
P.("oils", "Моторна олива Shell Helix Ultra 5W-40, 4 л", "Shell", "SH-550052679", 1450, 30, "oil-shell.svg",
   "Бензинові та дизельні двигуни, VW 502/505",
   "Синтетична олива на основі технології PurePlus, отриманої з природного газу. Підтримує чистоту двигуна та знижує тертя.",
   featured: true)
P.("oils", "Моторна олива Motul 8100 X-clean 5W-30, 5 л", "Motul", "MOT-102020", 2590, 8, "oil-motul.svg",
   "BMW LL-04, MB 229.51, VW 502/505",
   "Олива класу C3 для сучасних двигунів Euro IV–VI з сажовими фільтрами. 100% синтетика.")
P.("oils", "Моторна олива Liqui Moly Top Tec 4200 5W-30, 5 л", "Liqui Moly", "LM-8973", 2780, 12, "oil-liqui.svg",
   "VW 504.00/507.00, Porsche C30",
   "Олива HC-синтетичного типу для подовжених інтервалів обслуговування. Виробництво — Німеччина.")
P.("oils", "Трансмісійна олива Febi ATF для АКПП ZF 6HP, 1 л", "Febi", "FEB-27001", 520, 40, "oil-atf.svg",
   "Audi A6 C6/C7, BMW E60/F10 з АКПП ZF 6HP",
   "Синтетична рідина для автоматичних коробок передач ZF 6HP. Відповідає специфікації ZF Lifeguard Fluid 6.")

P.("filters", "Фільтр масляний MANN-FILTER W 719/30", "MANN-FILTER", "MANN-W71930", 245, 50, "filter-oil-mann.svg",
   "VW Golf IV/V, Skoda Octavia 1.4–1.8, Audi A3",
   "Масляний фільтр з якісним фільтруючим папером і антидренажним клапаном. Оригінальна якість, виробництво Німеччина.")
P.("filters", "Фільтр масляний Bosch F 026 407 006", "Bosch", "BOS-F026407006", 310, 35, "filter-oil-bosch.svg",
   "Audi A4/A6 2.0 TDI, VW Passat B7/B8",
   "Фільтруючий елемент масляного фільтра без металевого корпусу для двигунів 2.0 TDI.")
P.("filters", "Фільтр повітряний MAHLE LX 1780/3", "MAHLE", "MAH-LX1780", 420, 22, "filter-air.svg",
   "Audi A6 C7 2.0 TDI, Audi A7",
   "Повітряний фільтр двигуна. Ефективність фільтрації понад 99,5 %, тривалий ресурс до 30 000 км.")
P.("filters", "Фільтр салону вугільний Bosch 1 987 432 397", "Bosch", "BOS-1987432397", 560, 18, "filter-cabin.svg",
   "Audi A6/A7 C7, Audi A8 D4",
   "Салонний фільтр з активованим вугіллям — затримує пил, пилок і неприємні запахи.", featured: true)
P.("filters", "Фільтр паливний Knecht KL 228/2D", "Knecht", "KN-KL2282D", 690, 4, "filter-fuel.svg",
   "Audi A6 C7 2.0 TDI, VW Passat B7 TDI",
   "Паливний фільтр для дизельних двигунів з відокремленням води. Захищає паливну апаратуру Common Rail.")

P.("brakes", "Диск гальмівний передній Brembo 09.A820.11", "Brembo", "BRE-09A82011", 2350, 10, "disc-brembo.svg",
   "Audi A6 C7, Audi A7 (діаметр 320 мм)",
   "Вентильований гальмівний диск з антикорозійним покриттям UV Coating. Ціна вказана за 1 шт.", featured: true)
P.("brakes", "Диск гальмівний задній ATE 24.0130-0174.1", "ATE", "ATE-240130", 1480, 14, "disc-ate.svg",
   "VW Passat B6/B7, Skoda Superb II",
   "Суцільний задній гальмівний диск, діаметр 282 мм. Ціна за 1 шт.")
P.("brakes", "Колодки гальмівні передні TRW GDB1550", "TRW", "TRW-GDB1550", 1190, 20, "pads-trw.svg",
   "VW Golf V/VI, Audi A3 8P, Skoda Octavia A5",
   "Комплект дискових гальмівних колодок (4 шт.) з противібраційними пластинами. Сертифікат ECE R90.",
   old: 1350)
P.("brakes", "Колодки гальмівні передні Textar 2470301", "Textar", "TEX-2470301", 1680, 9, "pads-textar.svg",
   "Audi A6 C7, Audi A7",
   "Колодки з датчиком зносу, тиха робота та стабільний коефіцієнт тертя.")
P.("brakes", "Гальмівна рідина ATE SL.6 DOT 4, 1 л", "ATE", "ATE-03990166", 430, 45, "brake-fluid.svg",
   "Універсальна, для систем з ABS/ESP",
   "Низьков'язка гальмівна рідина класу DOT 4 для сучасних систем ESP. Точка кипіння 265 °C.")

P.("batteries", "Акумулятор VARTA Blue Dynamic E11 74 Аг 680 А", "VARTA", "VAR-574012068", 4290, 7, "battery-varta.svg",
   "Більшість легкових авто, полярність R+",
   "Свинцево-кислотний акумулятор з технологією PowerFrame. Пусковий струм 680 А, гарантія 24 місяці.",
   featured: true)
P.("batteries", "Акумулятор Bosch S5 AGM 77 Аг 780 А", "Bosch", "BOS-0092S5A110", 7350, 3, "battery-bosch.svg",
   "Авто з системою Start-Stop, Audi A6 C7",
   "AGM-акумулятор для автомобілів з системою старт-стоп і рекуперацією енергії. Підвищена циклічна стійкість.")
P.("batteries", "Акумулятор EXIDE Premium EA640 64 Аг 640 А", "EXIDE", "EXI-EA640", 3650, 11, "battery-exide.svg",
   "Легкові авто середнього класу",
   "Необслуговуваний акумулятор з технологією Carbon Boost для частих запусків.")

P.("ignition", "Свічка запалювання NGK Laser Iridium LKR7DIX-11S", "NGK", "NGK-LKR7DIX", 420, 60, "plug-ngk.svg",
   "Renault, Nissan, Hyundai, Kia 1.6–2.0",
   "Іридієва свічка з подовженим ресурсом до 60 000 км. Ціна за 1 шт.")
P.("ignition", "Свічка розжарювання Bosch Duraterm 0 250 403 009", "Bosch", "BOS-0250403009", 540, 32, "plug-bosch.svg",
   "Audi A4/A6 2.0 TDI, VW Passat B7/B8 TDI",
   "Свічка розжарювання для дизельних двигунів з швидким нагріванням до 1000 °C за 3 секунди.")

P.("lighting", "Лампа H7 Philips X-tremeVision Pro150, 2 шт.", "Philips", "PH-12972XVPS2", 890, 25, "bulb-philips.svg",
   "Фари з цоколем H7",
   "Галогенні лампи з потоком світла до +150 % порівняно зі стандартними. Колірна температура 3500 K.",
   featured: true)
P.("lighting", "Лампа H7 Osram Night Breaker Laser, 2 шт.", "Osram", "OS-64210NL", 760, 30, "bulb-osram.svg",
   "Фари з цоколем H7",
   "Лампи з лазерним абляційним покриттям, на 150 % більше світла та на 150 м довший промінь.")
P.("lighting", "Лампа світлодіодна Osram LEDriving W5W 6000K, 2 шт.", "Osram", "OS-2825DWP", 410, 2, "bulb-led.svg",
   "Габарити, підсвітка номера, салон",
   "Світлодіодні лампи холодного білого світла з низьким енергоспоживанням.")

P.("wipers", "Щітки склоочисника Bosch Aerotwin A863S 650/475 мм", "Bosch", "BOS-3397007863", 980, 16, "wiper-bosch.svg",
   "Audi A6 C7, Audi A7",
   "Безкаркасні щітки з аеродинамічним спойлером. Комплект для лобового скла (2 шт.).")
P.("wipers", "Щітки склоочисника Valeo Silencio X.TRM 600/450 мм", "Valeo", "VAL-574376", 870, 13, "wiper-valeo.svg",
   "VW Passat B6/B7, Skoda Superb",
   "Тиха робота завдяки гумі з покриттям та рівномірному притисканню по всій довжині.", old: 990)

P.("accessories", "Відеореєстратор 70mai Dash Cam A500S + задня камера", "70mai", "70M-A500S", 4590, 6, "dashcam.svg",
   "Універсальний",
   "Запис 2.7K + Full HD задня камера, вбудований GPS, ADAS-асистент, керування зі смартфона.",
   old: 5199, featured: true)
P.("accessories", "Килимки в салон 3D Stingray, комплект 4 шт.", "Stingray", "STG-A6C7-3D", 2190, 5, "mats.svg",
   "Audi A6 C7 (2011–2018)",
   "Поліуретанові килимки з високими бортиками, повторюють геометрію підлоги салону.")
P.("accessories", "Компресор автомобільний Xiaomi Mi Portable Air Pump 1S", "Xiaomi", "XM-BHR5884", 1890, 19, "compressor.svg",
   "Шини легкових авто, велосипеди, м'ячі",
   "Портативний акумуляторний компресор з цифровим манометром і автоматичною зупинкою при досягненні тиску.")
P.("accessories", "Тримач для телефону Baseus MagSafe на дефлектор", "Baseus", "BS-SUCX140", 590, 0, "holder.svg",
   "Універсальний",
   "Магнітний тримач з кріпленням на решітку вентиляції, сумісний з iPhone 12–15.")
P.("accessories", "Антифриз G13 концентрат VAG, 1,5 л", "VAG", "VAG-G013A8JM1", 640, 27, "coolant.svg",
   "Audi, VW, Skoda, Seat 2008+",
   "Оригінальний концентрат охолоджувальної рідини G13 фіолетового кольору. Розводиться 1:1 з дистильованою водою.")

puts "Відгуки..."
texts = [
  [5, "Замовляв під Audi A6 C7 — підійшло ідеально, доставка Новою поштою за день."],
  [5, "Якість відмінна, оригінальна упаковка, ціна нижча ніж у місцевих магазинах."],
  [4, "Все добре, але коробка трохи пом'ята при доставці. Сам товар цілий."],
  [5, "Вже вдруге купую тут, консультант допоміг підібрати за VIN-кодом."],
  [3, "Товар нормальний, але чекав довше, ніж обіцяли — 4 дні Укрпоштою."]
]
Product.featured.each_with_index do |product, i|
  buyers.sample(3, random: Random.new(i)).each_with_index do |user, j|
    rating, body = texts[(i + j) % texts.size]
    Review.create!(product: product, user: user, rating: rating, body: body, created_at: (i + j + 1).days.ago)
  end
end

puts "Замовлення..."
np = DeliveryMethod.find_by(code: "np_branch")
samples = [
  [buyers[0], "Castrol", "card", "paid"], [buyers[1], "VARTA", "cod", "shipped"],
  [buyers[2], "Brembo", "card", "completed"], [buyers[0], "Philips", "cod", "new"]
]
samples.each_with_index do |(user, brand, pay, status), i|
  cart = Cart.create!
  cart.add_product(Product.find_by!(brand: brand), 2).save!
  cart.add_product(Product.find_by!(sku: "MANN-W71930"), 1).save!
  order = Order.new(user: user, full_name: user.name, phone: user.phone || "+380500000000", email: user.email,
                    city: %w[Київ Львів Івано-Франківськ Тернопіль][i], address: "Відділення №#{i + 3}",
                    delivery_method: np, payment_method: pay)
  order.build_from_cart(cart)
  order.status = status
  order.paid_at = 1.day.ago if %w[paid shipped completed].include?(status) && pay == "card"
  order.payment_reference = "TXN-DEMO#{i}" if order.paid_at
  order.card_last4 = "4242" if order.paid_at
  order.created_at = (i * 2 + 1).days.ago
  order.save!
  cart.destroy
end

puts "Звернення..."
FeedbackMessage.create!([
  { name: "Василь", email: "vasyl@example.com", subject: "Підбір запчастин за VIN",
    body: "Добрий день! Потрібні передні колодки на Audi A6 C7 2.0 TDI 2014 р., VIN WAUZZZ4G1EN000000." },
  { name: "Ірина Савчук", email: "iryna@example.com", subject: "Статус замовлення", user: buyers[1],
    body: "Підкажіть, будь ласка, коли буде відправлено моє замовлення з акумулятором?", status: "answered" }
])

puts "Готово: #{User.count} користувачів, #{Product.count} товарів, #{Order.count} замовлень."
puts "Адмін: admin@autopulse.ua / admin123"
