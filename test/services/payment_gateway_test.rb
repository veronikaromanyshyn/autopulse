require "test_helper"

class PaymentGatewayTest < ActiveSupport::TestCase
  def charge(number: "4242 4242 4242 4242", month: "12", year: (Date.current.year + 2).to_s[-2..], cvv: "123")
    PaymentGateway.charge(order: nil, number: number, exp_month: month, exp_year: year, cvv: cvv)
  end

  test "успішна оплата тестовою карткою" do
    result = charge
    assert result.success?
    assert_equal "4242", result.last4
    assert_match(/\ATXN-/, result.reference)
  end

  test "номер, що не проходить перевірку Луна, відхиляється" do
    assert_equal "Невірний номер картки", charge(number: "4242 4242 4242 4241").error
  end

  test "прострочена картка відхиляється" do
    assert_equal "Термін дії картки минув", charge(month: "01", year: "20").error
  end

  test "тестова картка відмови повертає помилку банку" do
    assert_equal "Платіж відхилено банком", charge(number: "4000 0000 0000 0002").error
  end
end
