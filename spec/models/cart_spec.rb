# -*- coding: utf-8 -*-
require 'spec_helper'

describe Cart do
  context "個人スポンサーが複数回追加されたとき" do
    before(:all) do
      @cart = Cart.new
      @individual_sponsor = ProductItem.make(:item_code => 'rk99_individual_sponsor')
      2.times do
        @cart.add_product(@individual_sponsor)
      end
    end

    subject { @cart }
    its(:total_items) { should == 1 }
  end

  describe "#total_price" do
    before(:all) do
      @cart = Cart.new
      @product1 = ProductItem.make(:unit_price => 1000)
      @product2 = ProductItem.make(:unit_price => 200)
    end

    context "1件だけのとき" do
      before(:all) do
        @cart.add_product(@product1)
      end

      subject { @cart }
      its(:total_price) { should == 1000 }
      its(:total_items) { should == 1 }
      it { should_not be_empty }
    end

    context "複数のアイテムがある場合" do
      before(:all) do
        @cart.add_product(@product1)
        @cart.add_product(@product1)
        @cart.add_product(@product2)
      end

      subject { @cart }
      its(:total_price) { should == 2200 }
      its(:total_items) { should == 3 }
      it { should_not be_empty }
    end
  end
end
