require 'delegate'

class GildedRose
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each do |item|
      ItemCollection.init(item).update
    end
  end

end

class ItemCollection < SimpleDelegator
  def self.init(item)
    if item.name == 'Aged Brie'
      AgedBrie.new(item)
    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePass.new(item)
    elsif item.name == 'Conjured'
      ConjuredItem.new(item)
    elsif item.name == 'Sulfuras, Hand of Ragnaros'
      SulfurasItem.new(item)
    else
      new(item)
    end
  end

  def update
    return if name == "Sulfuras, Hand of Ragnaros"

    update_sell_in
    update_quality
  end

  def calc_quality
    counter = 0

    if sell_in < 0
      counter -= 1
    else
      counter -= 1
    end

    counter
  end

  def update_sell_in
    self.sell_in -= 1
  end

  def update_quality
    self.quality += calc_quality
  end

  def quality=(new_quality)
    if new_quality < 0
      new_quality = 0
    elsif new_quality > 50
      new_quality = 50
    end
    super(new_quality)
  end
end

class AgedBrie < ItemCollection
  def calc_quality
    counter = 1
    if sell_in < 0
      counter += 1
    end

    counter
  end
end

class BackstagePass < ItemCollection
  def calc_quality
    counter = 1
    if sell_in < 11
      counter += 1
    end
    if sell_in < 6
      counter += 1
    end
    if sell_in < 0
      counter -= quality
    end

    counter
  end
end

class ConjuredItem < ItemCollection
  def calc_quality
    counter = -2
    if sell_in < 0
      counter -= 2
    end

    counter
  end
end

class SulfurasItem < ItemCollection
  def calc_quality
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end