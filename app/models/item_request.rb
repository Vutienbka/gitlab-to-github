class ItemRequest < ApplicationRecord
  acts_as_paranoid
  extend Enumerize

  belongs_to :supplier
  
  belongs_to :buyer
  has_one :item_info, dependent: :destroy
  has_one :item_quality, dependent: :destroy
  has_one :item_drawing, dependent: :destroy
  has_one :item_sample, dependent: :destroy
  has_one :item_image, dependent: :destroy
  has_many :item_conditions, dependent: :destroy

  accepts_nested_attributes_for :item_conditions, :item_info, :item_quality, :item_sample, allow_destroy: true

  PARAMS_ATTRIBUTES = [
    item_conditions_attributes: [
      :id, :item_request_id, :condition, :position, :creator, :updater
    ]
  ]

  STATUSES = {
    'information': 1,
    'draw': 2,
    'image': 3,
    'quality': 4,
    'standard': 5,
    'condition': 6,
    'sample': 7,
    'estimate': 8,
    'low_cost': 9
  }

  enumerize :status, in: STATUSES, predicates: { prefix: true }

  def self.import_file(file, current_user)
    info_request = ["SKU", "name", "category1", "category2", "category3", "expected_sales_volume", "lead_time", "cost"]
    itemRequest_h = ["id", "supplier_id", "status"]
    condition_request = ["condition", "position"]
    item_quality  = ["quality1", "quality2", "quality3", "quality4", "quality5", "quality6", "quality7", "quality8", "quality9", "quality10", "quality11", "quality12", "quality13", "quality14", "quality15", "quality16"]
    item_sample = ["category_type1", "category_type2", "category_type3", "category_type4"]

    file_nil = true
    file_false = true
    if file.nil?
      file_nil = false
      return file_nil
    else
      spreadsheet = open_spreadsheet(file)
      if spreadsheet == false
        file_false = false
        return file_false
      else
        header = spreadsheet.row(1)
        row_error = 2
        row_errors = []
        fails = ""
        ActiveRecord::Base.transaction do
          (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose].compact

            itemRequest = find_by_id(row["id"]) || ItemRequest.new
            
            itemRequest.attributes = row.to_hash.slice(*itemRequest_h)

            itemRequest.buyer_id = current_user.id
            if itemRequest.valid?
              itemRequest.save!

              info = ItemInfo.find_or_initialize_by(item_request_id: itemRequest.id)
              info.attributes = row.to_hash.slice(*info_request)
              
              condition = ItemCondition.find_or_initialize_by(item_request_id: itemRequest.id)
              condition.attributes = row.to_hash.slice(*condition_request)

              quality = ItemQuality.find_or_initialize_by(item_request_id: itemRequest.id)
              quality.attributes = row.to_hash.slice(*item_quality)

              sample = ItemSample.find_or_initialize_by(item_request_id: itemRequest.id)
              sample.attributes = row.to_hash.slice(*item_sample)

              sample.sample_category1_id = 1
              sample.sample_category2_id = 2
              sample.sample_category3_id = 3
              sample.sample_category4_id = 4

              if info.valid? && sample.valid? && quality.valid? && condition.valid?
                info.save!
                condition.save!
                quality.save!
                sample.save!
              else
                itemRequest.destroy!
                fails = "fail"
                row_errors.push(row_error)
              end
            else
              fails = "fail"
              row_errors.push(row_error)
            end
            row_error +=1
          end
        end
        [row_error, fails, row_errors]
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else return false
    end
  end

end
