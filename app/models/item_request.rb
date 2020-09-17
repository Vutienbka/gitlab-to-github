class ItemRequest < ApplicationRecord
  extend Enumerize
  require 'rubygems'
  require 'zip'

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


  def self.extract_zip(file)
    Zip::File.open(file) do |zip_file|
      zip_file.each { |f|
        f_path = File.join("public/", f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    end
  end

  def self.import_file(file, current_user, supplier_id)
    info_request = ["SKU", "name", "category1", "category2", "category3", "expected_sales_volume", "lead_time", "cost"]
    itemRequest_h = ["id"]
    condition_request = ["condition", "position"]
    item_quality  = ["quality1", "quality2", "quality3", "quality4", "quality5", "quality6", "quality7", "quality8", "quality9", "quality10", "quality11", "quality12", "quality13", "quality14", "quality15", "quality16"]
    item_sample = ["category_type1", "category_type2", "category_type3", "category_type4"]

    file_nil = true
    file_false = true
    if file.nil?
      file_nil = false
      return file_nil
    else
      zip = extract_zip(file)

      # select file csv
      file_csv = Dir.new("public/csv/")
      csvs = file_csv.entries.select {|e| /^.+\.csv$/.match(e) }
      path_csv = "public/csv/" + "#{csvs[0]}"

      spreadsheet = open_spreadsheet(path_csv)
      if spreadsheet == false
        file_false = false
        return file_false
      else
        header = spreadsheet.row(2)
        count = 3
        row_errors = []
        folder = 1
        fails = ""
        ActiveRecord::Base.transaction do
          (3..spreadsheet.last_row).each do |i|


            #select file image draw
            image_draw1 = Dir.new("public/csv/図面/製品仕様図（2D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw1 =  image_draw1.map {|image| File.open("#{Rails.root}/public/csv/図面/製品仕様図（2D）/#{folder}/#{image}") } rescue nil

            image_draw2 = Dir.new("public/csv/図面/組立仕様図（2D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw2 =  image_draw2.map {|image| File.open("#{Rails.root}/public/csv/図面/組立仕様図（2D）/#{folder}/#{image}") } rescue nil

            image_draw3 = Dir.new("public/csv/図面/梱包仕様図（2D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw3 =  image_draw3.map {|image| File.open("#{Rails.root}/public/csv/図面/梱包仕様図（2D）/#{folder}/#{image}") } rescue nil

            image_draw4 = Dir.new("public/csv/図面/製品仕様図（3D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw4 =  image_draw4.map {|image| File.open("#{Rails.root}/public/csv/図面/製品仕様図（3D）/#{folder}/#{image}") } rescue nil

            image_draw5 = Dir.new("public/csv/図面/組立仕様図（3D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw5 =  image_draw5.map {|image| File.open("#{Rails.root}/public/csv/図面/組立仕様図（3D）/#{folder}/#{image}") } rescue nil

            image_draw6 = Dir.new("public/csv/図面/梱包仕様図（3D）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_draw6 =  image_draw6.map {|image| File.open("#{Rails.root}/public/csv/図面/梱包仕様図（3D）/#{folder}/#{image}") } rescue nil

            #select file image
            image_image1 = Dir.new("public/csv/画像/アイテムの画像をアップロードしてください（複数可）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_image1 =  image_image1.map {|image| File.open("#{Rails.root}/public/csv/画像/アイテムの画像をアップロードしてください（複数可）/#{folder}/#{image}") } rescue nil

            image_image2 = Dir.new("public/csv/画像/アイテムのデザイン画をアップロードしてください（複数可）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_image2 =  image_image2.map {|image| File.open("#{Rails.root}/public/csv/画像/アイテムのデザイン画をアップロードしてください（複数可）/#{folder}/#{image}") } rescue nil


            #select file standard
            image_standard1 = Dir.new("public/csv/基準/アイテムの試験基準をアップロードしてください（複数可）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_standard1 =  image_standard1.map {|image| File.open("#{Rails.root}/public/csv/基準/アイテムの試験基準をアップロードしてください（複数可）/#{folder}/#{image}") } rescue nil

            image_standard2 = Dir.new("public/csv/基準/アイテムの検査基準をアップロードしてください（複数可）/#{folder}").entries.select {|e| (/\.(gif|jpe?g|tiff|png|webp|bmp)$/i).match(e) } rescue nil
            arr_standard2 =  image_standard2.map {|image| File.open("#{Rails.root}/public/csv/基準/アイテムの検査基準をアップロードしてください（複数可）/#{folder}/#{image}") } rescue nil


            row = Hash[[header, spreadsheet.row(i)].transpose].compact

            itemRequest = find_by_id(row["id"]) || ItemRequest.new

            itemRequest.attributes = row.to_hash.slice(*itemRequest_h)

            itemRequest.buyer_id = current_user.id
            itemRequest.supplier_id = supplier_id
            itemRequest.status = 9
            if itemRequest.valid?
              itemRequest.save!

              # create item drawing
              item_drawing = ItemDrawing.find_or_initialize_by(item_request_id: itemRequest.id)
              item_drawing.save!
              draw_category1 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)
              draw_category2 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)
              draw_category3 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)
              draw_category4 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)
              draw_category5 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)
              draw_category6 = DrawCategory.find_or_initialize_by(item_drawing_id: item_drawing.id)

              draw_category1.name = "製品仕様図（2D）"
              draw_category2.name = "組立仕様図（2D）"
              draw_category3.name = "梱包仕様図（2D）"
              draw_category4.name = "製品仕様図（3D）"
              draw_category5.name = "組立仕様図（3D）"
              draw_category6.name = "梱包仕様図（3D）"

              draw_category1.save!
              draw_category2.save!
              draw_category3.save!
              draw_category4.save!
              draw_category5.save!
              draw_category6.save!

              file_draw1 = FileDraw.find_or_initialize_by(draw_category_id: draw_category1.id)
              file_draw2 = FileDraw.find_or_initialize_by(draw_category_id: draw_category2.id)
              file_draw3 = FileDraw.find_or_initialize_by(draw_category_id: draw_category3.id)
              file_draw4 = FileDraw.find_or_initialize_by(draw_category_id: draw_category4.id)
              file_draw5 = FileDraw.find_or_initialize_by(draw_category_id: draw_category5.id)
              file_draw6 = FileDraw.find_or_initialize_by(draw_category_id: draw_category6.id)

              file_draw1.file_link = arr_draw1
              file_draw2.file_link = arr_draw2
              file_draw3.file_link = arr_draw3
              file_draw4.file_link = arr_draw4
              file_draw5.file_link = arr_draw5
              file_draw6.file_link = arr_draw6

              file_draw1.save!
              file_draw2.save!
              file_draw3.save!
              file_draw4.save!
              file_draw5.save!
              file_draw6.save!

              # create item images
              item_image = ItemImage.find_or_initialize_by(item_request_id: itemRequest.id)
              item_image.save!
              image_category1 = ImageCategory.find_or_initialize_by(item_image_id: item_image.id)
              image_category2 = ImageCategory.find_or_initialize_by(item_image_id: item_image.id)

              image_category1.name = "TYPE1"
              image_category2.name = "TYPE2"

              image_category1.save!
              image_category2.save!

              file_image1 = FileImage.find_or_initialize_by(image_category_id: image_category1.id)
              file_image2 = FileImage.find_or_initialize_by(image_category_id: image_category2.id)

              file_image1.file_link = arr_image1
              file_image2.file_link = arr_image2

              file_image1.save!
              file_image2.save!

              # create item standard

              item_standard = ItemStandard.find_or_initialize_by(item_request_id: itemRequest.id)
              item_standard.save!
              standard_category1 = StandardCategory.find_or_initialize_by(item_standard_id: item_standard.id)
              standard_category2 = StandardCategory.find_or_initialize_by(item_standard_id: item_standard.id)

              standard_category1.name = "STANDARD_TYPE1"
              standard_category2.name = "STANDARD_TYPE2"

              standard_category1.save!
              standard_category2.save!

              file_standard1 = FileStandard.find_or_initialize_by(standard_category_id: standard_category1.id)
              file_standard2 = FileStandard.find_or_initialize_by(standard_category_id: standard_category2.id)

              file_standard1.file_link = arr_standard1
              file_standard2.file_link = arr_standard2

              file_standard1.save!
              file_standard2.save!



              info = ItemInfo.find_or_initialize_by(item_request_id: itemRequest.id)
              info.attributes = row.to_hash.slice(*info_request)

              condition = ItemCondition.find_or_initialize_by(item_request_id: itemRequest.id)
              condition.attributes = row.to_hash.slice(*condition_request)
              condition.position = 1

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
                row_errors.push(count)
              end
            else
              fails = "fail"
              row_errors.push(count)
            end
            count +=1
            folder +=1
          end
        end
        system ("rm -rf public/csv")
        [count, fails, row_errors]
      end
    end
  end

  def self.open_spreadsheet(content)
    case File.extname(content)
      when ".csv" then Roo::CSV.new(content)
      when ".xls" then Roo::Excel.new(content)
      when ".xlsx" then Roo::Excelx.new(content)
      else return false
    end
  end

end
