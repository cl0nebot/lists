class ListItem < ActiveRecord::Base
  include Scoring
  belongs_to :list, counter_cache: :products_count
  belongs_to :product
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :scores, as: :scorable, dependent: :destroy

  validates :user, :product, :list, presence: true

  after_create :set_rank
  after_create :score_creation
  after_create :add_product_category_to_list

  def add_product_category_to_list
    list.add_category(product.category)
  end

  def display_rank
    rank + 1
  end

  def liked
    recalculate_rank
  end

  def unliked
    recalculate_rank
  end

  def recalculate_rank
    new_rank = list.items_ordered_by_most_likes.index(self)
    ranks = [rank , new_rank].sort
    list.recalculate_ranks(ranks[0], ranks[1])
  end

  def likes_count_percent
    if list.maximum_likes_count > 0
      likes_count.to_f / list.maximum_likes_count
    else
      0.0
    end
  end

  private

  def score_creation
    score!(self.list, self, 5)
    user.score!(self.list, self, 5)
  end

  def set_rank
    update_column(:rank, list.items.count - 1)
  end
end
