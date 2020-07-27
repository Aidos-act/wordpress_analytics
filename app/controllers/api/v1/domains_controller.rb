class Api::V1::DomainsController < ApplicationController

  def show
    article_id = params[:article_id]
    @domain_name = Article.joins(:domain).where(id: article_id).pluck("domains.domain_name")
  end

  def domainInfo
    domain_setup = Domain.pluck(:domain_name)
    domain_setup.unshift('total')
    @domain_info = domain_setup
  end
end
