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
    @component_name = 'CreateOrganizationPage'
    @component_data = {
      submit_url: "/organizations",
      organization_nodes: OrganizationNode.all.map { |node|
        {
          id: node.id.to_s,
          name: node.name,
        }
      }
    }
  end

  # 新增机构
  def create
    organization = OrganizationNode.new(name: params[:OrganizationNode][:name], code: params[:OrganizationNode][:code], parent_id: params[:OrganizationNode][:organizationId])
    if organization.save
      redirect_to "/organizations/organization_list"
    else
      render json: "创建机构失败"
    end
  end

  # 组织机构列表
  def organization_list
    @component_name = 'OrganizationsManagerPage'
    @component_data = {
      organization: OrganizationNode.all.map { |organization|
        {
          id: organization.id.to_s,
          name: organization.name,
          code: organization.code,
          parents_name:  organization.parent?.to_s == "false" ? "无" : organization.parent.name,
          children_name: organization.children?.to_s == "false" ? "无" : organization.children.map {|x| x.name}.join(","),
        }
      }
    }
  end

  # 编辑组织机构
  def edit_organization
    organization = OrganizationNode.find(params[:id])
    @component_name = 'EditOrganizationPage'
    @component_data = {
      id: organization.id.to_s,
      name: organization.name,
      code: organization.code,
      submit_url: "/organizations/#{params[:id]}/update_organization",
      organization_nodes: OrganizationNode.all.map { |node|
        {
          id: node.id.to_s,
          name: node.name,
        }
      }
    }
  end

  # 更新组织机构信息
  def update_organization
    organization = OrganizationNode.find(params[:id])
    organization.update(name: params[:OrganizationNode][:name], code: params[:OrganizationNode][:code], parent_id: params[:OrganizationNode][:organizationId])
    if organization.save
      redirect_to "/organizations/organization_list"
    else
      render json: "保存出错"
    end
  end

  # 删除公司并且解除与 parent 和 children 的关系
  def destroy
    organization = OrganizationNode.find(params[:id])
    organization.destroy
    redirect_to "/organizations/organization_list"
  end

  def organization_tree_show
    # 展现组织树状图
    @component_name = 'OrganizationTreeShowPage'
    @component_data = {
      organizations:  OrganizationNode.where(depth:"0").all.to_a.map{|x| x.tree_data}
    } 
  end
end