require_relative "test_helper"

class OrderTest < Minitest::Test
  def test_hash
    store_names ["Product A", "Product B", "Product C", "Product D"]
    assert_order "product", ["Product D", "Product C", "Product B", "Product A"], order: {name: :desc}
  end

  def test_string
    store_names ["Product A", "Product B", "Product C", "Product D"]
    assert_order "product", ["Product A", "Product B", "Product C", "Product D"], order: "name"
  end

  def test_multiple
    store [
      {name: "Product A", color: "blue", store_id: 1},
      {name: "Product B", color: "red", store_id: 3},
      {name: "Product C", color: "red", store_id: 2}
    ]
    assert_order "product", ["Product A", "Product B", "Product C"], order: {color: :asc, store_id: :desc}
  end

  def test_unmapped_type
    Product.search_index.refresh
    assert_order "product", [], order: {not_mapped: {unmapped_type: "long"}}
  end

  def test_array
    store [{name: "San Francisco", latitude: 37.7833, longitude: -122.4167}]
    assert_order "francisco", ["San Francisco"], order: [{_geo_distance: {location: "0,0"}}]
  end
end
