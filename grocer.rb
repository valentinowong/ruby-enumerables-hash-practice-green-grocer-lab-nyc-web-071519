def consolidate_cart(cart)
  keys = cart.flat_map(&:keys)
  new_cart = cart.inject(:merge).map do |k, v|
    { k => v.merge(count: keys.count(k)) }
  end
  new_cart.reduce({},:merge)
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |coupon|
    item = coupon[:item]

    if !new_cart[item].nil? && new_cart[item][:count] >= coupon[:num]
      new_item = {"#{item} W/COUPON" => {
        :price => coupon[:cost] / coupon[:num],
        :clearance => new_cart[item][:clearance],
        :count => coupon[:num]
        }
      }
      
      if new_cart["#{item} W/COUPON"].nil?
        new_cart.merge!(new_item)
      else
        new_cart["#{item} W/COUPON"][:count] = new_cart["#{item} W/COUPON"][:count] + coupon[:num]
      end
      
      new_cart[item][:count] -= coupon[:num]
    end
  end
  new_cart
end

def apply_clearance(cart)
  new_cart = cart
  new_cart.each do |k,v|
    if new_cart[k][:clearance]
      new_cart[k][:price] = (new_cart[k][:price] * 0.8).round(2)
    end
  end
  new_cart
end

def checkout(cart, coupons)
  consolidate_cart(cart)
end