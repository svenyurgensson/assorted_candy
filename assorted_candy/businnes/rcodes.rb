# -*- coding: utf-8 -*-

# Taken from https://github.com/tanraya/stuff/blob/master/account/account.rb
# need to add others methods from https://github.com/am-dmr/jq-inn/blob/master/jquery.jqinn.js

module AssortedCandy
  module Business

    module Rcodes extend self
      # This method validates russian bank account number using BIK (Swiff code)
      def validate_acc(acc, bik)
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

      def validate_inn10(inn)
        inn = inn.to_s
        return false unless inn.size == 10
        return false unless inn[/([0][1-9]|[1-9][0-9])[0-9]{8}/]
        arr = inn.split(//).map(&:to_i)
        arr[9] == ((2*arr[0] + 4*arr[1] + 10*arr[2] + 3*arr[3] + 5*arr[4] + 9*arr[5] + 4*arr[6] + 6*arr[7] + 8*arr[8]) % 11 % 10)
      end

      def validate_inn12(inn)
        inn = inn.to_s
        return false unless inn.size == 12
        return false unless inn[/([0][1-9]|[1-9][0-9])[0-9]{10}/]
        arr = inn.split(//).map(&:to_i)
        (((7*arr[0] + 2*arr[1] + 4*arr[2] + 10*arr[3] + 3*arr[4] + 5*arr[5] + 9*arr[6] + 4*arr[7] + 6*arr[8] + 8*arr[9]) % 11 % 10 == arr[10]) && ((3*arr[0] + 7*arr[1] + 2*arr[2] + 4*arr[3] + 10*arr[4] + 3*arr[5] + 5*arr[6] + 9*arr[7] + 4*arr[8] + 6*arr[9] + 8*arr[10]) % 11 % 10 == arr[11]))
      end

      def validate_inn(inn)
        inn = inn.to_s
        case inn.size
        when 10 then validate_inn10(inn)
        when 12 then validate_inn12(inn)
        else
          false
        end
      end

      def validate_kpp(kpp)
        !! kpp.to_s[/([0-9]{1}[1-9]{1}|[1-9]{1}[0-9]{1})([0-9]{2})([0-9A-F]{2})([0-9]{3})/]
      end

      def validate_ogrn13(ogrn)
        ogrn = ogrn.to_s
        return unless ogrn[/[0-9]{13}/]
        # (parseInt(value.slice(12, 13), 10) == parseInt(value.slice(0, 12), 10) % 11 % 10)
        ogrn[11..12].to_i == (ogrn[0..10].to_i % 11 % 10)
      end

      def validate_ogrn15(ogrn)
        ogrn = ogrn.to_s
        return unless ogrn[/[0-9]{15}/]
        # parseInt(value.slice(14, 15), 10) == parseInt(value.slice(0, 14), 10) % 13 % 10)
        ogrn[13..14].to_i == (ogrn[0..12].to_i % 13 % 10)
      end

      def validate_ogrn(ogrn)
        ogrn = ogrn.to_s
        case inn.size
        when 13 then validate_ogrn13(ogrn)
        when 15 then validate_ogrn15(ogrn)
        else
          false
        end
      end

    end # module Rcodes

  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  T = AssortedCandy::Business::Rcodes

  check( T.validate_acc("40817810511721147978", "046577756") == true )
  check( T.validate_acc("40817810511721147978", "046577757") == false )

  check( T.validate_kpp("997950001") == true )
  check( T.validate_kpp("775001001") == true )
  check( T.validate_kpp("77500100") == false )

  check( T.validate_inn10("2464031122") == true )
  check( T.validate_inn10("3464031122") == false )

  check( T.validate_inn12("246207025211") == true )
  check( T.validate_inn12("346207025211") == false )

  check( T.validate_ogrn13("1022402294100") == true )
  check( T.validate_ogrn13("2022402294100") == false )

  check( T.validate_ogrn15("306246011400041") == true )
  check( T.validate_ogrn15("306246011410041") == false )

end
