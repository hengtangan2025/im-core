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
    user = User.create(:email => params[:member][:email], :password => params[:member][:password])
    member = Member.create(:name => params[:member][:name], :job_number => params[:member][:job_number], :organization_node_ids => params[:member][:organization], :user_id => user.id)
    if member.save && user.save
      redirect_to "/members"
    end
  end

  def edit
    @component_name = 'MembersEditPage'
    @component_data = {
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
    member.save
    redirect_to "/members"
  end

  def destroy
    member = Member.find(params[:id])
    member.user.destroy
    member.destroy
    redirect_to "/members"
  end
end