module DistributeAppHelper
  def as_currency(number)
    if number == 0
      return "FREE"
    else
      return currencify(number).to_s
    end
  end
  
  def as_price(number, period="")
    m = ""
    m = period.to_s == "1" ? " /mo." : " #{period.to_s}/<br>Months" unless period.to_s == ""
    return "#{as_currency(number)} #{m}"
  end
  
  private
  
  # pulled this from http://codesnippets.joyent.com/posts/show/1812
  def currencify(number, options={})
    # :currency_before => false puts the currency symbol after the number
    # default format: $12,345,678.90
    options = {:currency_symbol => "$", :delimiter => ",", :decimal_symbol => ".", :currency_before => true}.merge(options)

    # split integer and fractional parts 
    int, frac = ("%.2f" % number).split('.')
    # insert the delimiters
    int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

    if options[:currency_before]
      options[:currency_symbol] + int + options[:decimal_symbol] + frac
    else
      int + options[:decimal_symbol] + frac + options[:currency_symbol]
    end
  end
end
