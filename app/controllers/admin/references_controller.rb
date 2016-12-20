class Admin::ReferencesController < ApplicationController
  def index
    @component_name = 'ReferencesIndexPage'
    @component_data = {
      references: Reference.all.map{|ref| ref.controller_data},
      new_url: new_admin_reference_path
    }
  end
  
  def new
    reference = Reference.new
    @component_name = 'RefNewEditPage'
    @component_data = {
      references: reference.controller_data,
      tags: Tag.all.map { |tag| tag.controller_data },
      submit_url: admin_references_path,
      cancel_url: admin_references_path,
    }
  end

  def create
    reference = Reference.new(reference_params)
    if reference.save
      redirect_to admin_references_path
    else
      render :json => "保存数据失败"
    end
  end

  def edit
    reference = Reference.find(params[:id])
    @component_name = 'RefNewEditPage'
    @component_data = {
      references: reference.controller_data,
      tags: Tag.all.map { |tag| tag.controller_data },
      submit_url: admin_reference_path(reference),
      cancel_url: admin_references_path,
    }
  end

  def update
    reference = Reference.find(params[:id])
    reference.update(reference_params)
    if reference.save
      redirect_to admin_references_path
    else
      render :json => "修改失败"
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    reference.destroy
    redirect_to admin_references_path
  end

  # android 获取参考资料
  def get_ref_detail
    references = Reference.all
    ref_ary = []
    references.each do |ref|
      tags_str = ''
      ref.tags.each do |tag|
        tags_str += '#' + tag.name + ' '
      end
      ref_ary.push({
        id: ref.id.to_s,
        name: ref.name,
        tags: tags_str,
        kind: ref.kind,
      })
    end
    render json: {
      references: ref_ary,
    }
  end

  # 获取资料中的文件用于 Android 端阅读或播放
  def fetch_ref_file
    reference = Reference.find(params[:id])
    render json:{
      name: reference.name,
    }
  end

  private
    def reference_params
      params.require(:References).permit(:name, :describe, :kind, :reference_file_name, :tags_name => [])
    end

end