class Buyers::ImportsController < Buyers::BaseController
  def index
    @import = ItemRequest.new
  end

  def suplier_id
    supplier_id = params["supplier_id"].to_i
    redirect_to buyers_imports_path(supplier_id: supplier_id)
  end

  def download_csv
    send_file("#{Rails.root}/public/csv.zip")
  end

  def create
    file = params[:file]
    supplier_id = params["supplier_id"].to_i
    return redirect_to buyers_imports_path(supplier_id: supplier_id), alert:"zipファイルを選択していません"  if file.nil?
    return redirect_to buyers_imports_path(supplier_id: supplier_id), alert:"zipファイルではありません"  unless file.content_type.in?(['application/zip'])

    @import = ItemRequest.import_file(params[:file] , current_user, supplier_id)
    if @import == false
      system ("rm -rf public/csv")
      flash[:alert] = "csvファイルまたは間違ったcsv形式を追加します"
      redirect_to buyers_imports_path(supplier_id: supplier_id)
    else
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