class MembersController < ApplicationController
  def index
    @component_name = 'MembersIndexPage'
    @component_data = {
      members: Member.all.map { |member|
        {
          id: member.id.to_s,
          membername: member.name,
          email: member.user.email,
          job_number: member.job_number,
          organization_nodes: member.organization_nodes.map {|x| x.name}.join(","),
        }
      }
    }
  end

  def new
    @component_name = 'MembersNewPage'
    @component_data = {
      submit_url: "/members",
      organization_nodes: OrganizationNode.all.map { |node|
        {
          id: node.id.to_s,
          name: node.name,
        }
      }
    }
  end

  def create
    user = User.new(:email => params[:member][:email], :password => params[:member][:password])
    member = Member.new(:name => params[:member][:name], :job_number => params[:member][:job_number], :organization_node_ids => params[:member][:organization], :user_id => user.id)
    if member.save && user.save
      redirect_to "/members"
    else
      render json: "新建失败"
    end
  end

  def edit
    member = Member.find(params[:id])
    @component_name = 'MembersEditPage'
    @component_data = {
      name: member.name,
      email: member.user.email,
      job_number: member.job_number,
      organization: member.organization_nodes.map {|x| x.name}.join(","),
      password: member.user.password,
      submit_url: "/members/" + params[:id],
      organization_nodes: OrganizationNode.all.map { |node|
        {
          id: node.id.to_s,
          name: node.name,
        }
      }
    }
  end

  def update
    member = Member.find(params[:id])
    member.update(:name => params[:member][:name], :job_number => params[:member][:job_number], :organization_node_ids => params[:member][:organization])
    member.user.update(:email => params[:member][:email])
    if member.save
      redirect_to "/members"
    else
      render json: "修改失败"
    end
  end

  def destroy
    member = Member.find(params[:id])
    member.user.destroy
    member.destroy
    redirect_to "/members"
  end
end