# Сервіс-обгортка над платіжним шлюзом.
# У навчальному проєкті працює в тестовому режимі (аналог sandbox LiqPay/Stripe):
# перевіряє реквізити картки, але реальних списань не виконує.
class PaymentGateway
  Result = Struct.new(:success?, :reference, :last4, :error, keyword_init: true)

  DECLINED_CARD = "4000000000000002" # тестова картка, що завжди відхиляється

  def self.charge(order:, number:, exp_month:, exp_year:, cvv:)
    new.charge(order: order, number: number, exp_month: exp_month, exp_year: exp_year, cvv: cvv)
  end

  def charge(order:, number:, exp_month:, exp_year:, cvv:)
    number = number.to_s.gsub(/\D/, "")
    return failure("Невірний номер картки") unless number.length == 16 && luhn_valid?(number)
    return failure("Невірний CVV-код")       unless cvv.to_s.match?(/\A\d{3}\z/)
    return failure("Термін дії картки минув") if expired?(exp_month.to_i, exp_year.to_i)
    return failure("Платіж відхилено банком") if number == DECLINED_CARD

    Result.new(success?: true, reference: "TXN-#{SecureRandom.hex(6).upcase}", last4: number[-4..])
  end

  private

  def failure(message) = Result.new(success?: false, error: message)

  def expired?(month, year)
    return true unless (1..12).cover?(month)
    year += 2000 if year < 100
    Date.new(year, month, -1) < Date.current
  rescue Date::Error
    true
  end

  # Алгоритм Луна для перевірки контрольної суми номера картки
  def luhn_valid?(number)
    sum = number.reverse.chars.each_with_index.sum do |ch, i|
      d = ch.to_i
      d *= 2 if i.odd?
      d > 9 ? d - 9 : d
    end
    (sum % 10).zero?
  end
end
