# -*- coding: utf-8 -*-

# Taken from https://github.com/tanraya/stuff/blob/master/account/account.rb

module AssortedCandy
  module Business

    module Rbank
      # This method validates russian bank account number using BIK (Swiff code)
      def self.validate_acc(acc, bik)
        # Для проверки контрольной суммы перед расчётным счётом
        # добавляются три последние цифры БИКа банка.
        acc = bik[-3..-1] + acc

        # Вычисляется контрольная сумма со следующими весовыми
        # коэффициентами: (7,1,3,7,1,3,7,1,3,7,1,3,7,1,3,7,1,3,7,1,3,7,1)
        coeff = "71371371371371371371371"
        crc   = 0

        0.upto(22) do |i|
          tmp_pro = acc[i, 1].to_i * coeff[i, 1].to_i
          crc += (tmp_pro.to_s[tmp_pro.to_s.size - 1, 1]).to_i
        end

        # Вычисляется контрольное число как остаток от деления контрольной суммы на 10
        # Контрольное число сравнивается с нулём. В случае их равенства расчётного
        # счёт считается правильным.
        crc % 10 == 0
      end
    end # module Rbank

  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check(
        AssortedCandy::Business::Rbank.validate_acc("40817810511721147978", "046577756") == true
        )

  check(
        AssortedCandy::Business::Rbank.validate_acc("40817810511721147978", "046577757") == false
        )


end
