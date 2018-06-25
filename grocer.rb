def consolidate_cart(cart)
  new_cart = {}
  cart.each { |items|
    items.each { |item, info|
      if new_cart[item] == nil
        new_cart[item] = info
        new_cart[item][:count] = 1
      else
        new_cart[item][:count] += 1
      end
    }
  }
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    item = coupon[:item]
    if cart[item] != nil
      cart[item][:count] -= coupon[:num]
      if cart["#{item} W/COUPON"] == nil
        cart["#{item} W/COUPON"] = {}
        cart["#{item} W/COUPON"][:price] = coupon[:cost]
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
        cart["#{item} W/COUPON"][:count] = 1
      else  
        cart["#{item} W/COUPON"][:count] += 1
      end
    end
  }
  cart
end


def apply_clearance(cart)
  cart.each { |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(2)
    end
  }
  cart
end

def checkout(cart, coupons)
  cart_0 = consolidate_cart(cart)
  cart_1 = apply_coupons(cart_0, coupons)
  cart_2 = apply_clearance(cart_1)
  total = 0
  cart_2.each { |item, info|
    if info[:count] >= 0
    total += info[:price] * info[:count]
  }
  if total >= 100
    total *= 0.9
  end
  total
end
