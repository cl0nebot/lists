json.id list.id
json.slug list.slug
json.user list.user_id
json.name list.name
json.image list.default_image
json.minimumPrice list.minimum_price.to_s
json.maximumPrice list.maximum_price.to_s
json.listItems list.items_ordered_by_rank.pluck(:id)
json.productsCount list.products_count
json.currentScore list.current_score
json.totalScore list.total_score
json.createdAt list.created_at.iso8601
json.updatedAt list.updated_at.iso8601
