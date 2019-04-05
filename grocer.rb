require 'pry'

def consolidate_cart(cart)
  cart.group_by(&:itself).map do |key, entries|
    key.map do |item, vals|
      vals.update(count: entries.length)
    end
  end

  consolidated = {}
  cart.map { |item| consolidated.update(item)}
  return consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_name = coupon[:item]
    temp = {
      :price => coupon[:cost],
      :clearance => true,
      :count => coupon[:num]
    }

    if cart.key?(coupon_name)
      temp[:clearance] = cart[coupon_name][:clearance]
      leftover = cart[coupon_name][:count] - temp[:count]
      if leftover >= 0
        temp[:count] = (cart[coupon_name][:count]/temp[:count]).floor
        cart[coupon_name][:count] = (cart[coupon_name][:count]%coupon[:num])
        cart[coupon_name + " W/COUPON"] = temp
      end #if leftover
    end #if cart.key?
  end #coupons.each
  return cart
end #method

def apply_clearance(cart)
  cart.map do |cart_item, details|
    if details[:clearance] == true
      details[:price] -= (details[:price]/5)
    end #if details[:clearance]
  end #cart.map
  return cart
end #method

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0.0

  cart.each do |cart_item, details|
    # binding.pry
    total += (details[:price] * details[:count])
  end #cart.each do
  if total > 100
    total -= (total/10)
  end
  return total
end #method
