class OrganizationsController < ApplicationController
  def trees
    roots = OrganizationNode.roots.map { |x|
      { 
        id: x.id.to_s, 
        name: x.name,
        path: show_tree_organization_path(x)
      }
    }

    @component_name = 'OrganizationsTreesPage'
    @component_data = {
      tree_roots: roots
    }
  end

  def show_tree
    root = OrganizationNode.find(params[:id])

    @component_name = 'OrganizationTreePage'
    @component_data = {
      tree_data: root.tree_data
    }
  end

  def show
    o = OrganizationNode.find(params[:id])

    @component_name = 'OrganizationNodeShow'
    @component_data = {
      node_data: o.node_data
    }
  end

  # 新增机构
  def new
    organization = OrganizationNode.new
    @component_name = 'CreateUpdatePage'
    @component_data = {
      organization: organization.controller_data,
      submit_url: organizations_path(organization),
      cancel_url: organizations_path,
      organization_nodes: OrganizationNode.all.map { |node| node.controller_data }
    }
  end

  # 新增机构
  def create
    organization = OrganizationNode.new(organization_params)
    if organization.save
      redirect_to organizations_path
    else
      render json: "创建机构失败"
    end
  end

  # 组织机构列表
  def index
    @component_name = 'ListPage'
    @component_data = {
      organization: OrganizationNode.all.map { |organization|  organization.controller_data }
    }
  end

  # 编辑组织机构
  def edit
    organization = OrganizationNode.find(params[:id])
    @component_name = 'CreateUpdatePage'
    @component_data = {
      organization: organization.controller_data,
      submit_url: organization_path(organization),
      cancel_url: organizations_path,
      organization_nodes: OrganizationNode.all.map { |node| node.controller_data }
    }
  end

  # 更新组织机构信息
  def update
    organization = OrganizationNode.find(params[:id])
    organization.update(organization_params)
    if organization.save
      redirect_to organizations_path
    else
      render json: "保存出错"
    end
  end

  # 删除公司并且解除与 parent 和 children 的关系
  def destroy
    organization = OrganizationNode.find(params[:id])
    organization.destroy
    redirect_to organizations_path
  end

  def tree_show
    # 展现组织树状图
    @component_name = 'TreeShowPage'
    @component_data = {
      organizations:  OrganizationNode.where(depth:"0").all.to_a.map{|x| x.tree_data}
    } 
  end

  private
    def organization_params
      params.require(:OrganizationNode).permit(:name, :code, :parent_id)
    end
end