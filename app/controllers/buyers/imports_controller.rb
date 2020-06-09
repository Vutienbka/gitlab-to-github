class Buyers::ImportsController < Buyers::BaseController
  def index
    @import = ItemRequest.new
  end

  def download_csv
    send_file("#{Rails.root}/public/item.csv")
  end

  def create
    @import = ItemRequest.import_file(params[:file] , current_user)
    if @import == false
      flash[:alert] = "csvファイルまたは間違ったcsv形式を追加します"
      redirect_to buyers_imports_path
    elsif
      if @import[1].present?
        flash[:alert] = "CSVのインポートが失敗する、行: #{@import[2].join(', 行:')}"
        redirect_to buyers_item_requests_path
      else
        redirect_to buyers_item_requests_path
        flash[:success] = "CSVのインポートが成功しました。"
      end
    end

  end
end