class Picture < ApplicationRecord
    include ActiveModel::Serializers::JSON

    belongs_to :article
    has_one_attached :picture

    def attributes
        {
            'id' => nil,
            'updated_at' => nil,
            'created_at' => nil,
            'private' => nil,
            'picture_url' => nil
        }
    end

    def picture_url
        Rails.application.routes.url_helpers.rails_representation_url(
            picture.variant(resize_to_limit: [200, 200]).processed, only_path: true
        )
    end

end
