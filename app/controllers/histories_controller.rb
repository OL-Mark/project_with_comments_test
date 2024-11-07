class HistoriesController < ApplicationController
  VALID_ENTITIES_MAP = {
    "project" => Project,
    "comment" => Comment
  }.freeze

  before_action :find_entity

  def show
    render status: :not_found unless valid_entity_type?

    @history_entries = @entity.audits
  end

  private

  def valid_entity_type?
    VALID_ENTITIES_MAP.keys.include?(requested_entity_type)
  end

  def find_entity
    entity = params[:id].to_i
    entity_class = VALID_ENTITIES_MAP[requested_entity_type]

    @entity = entity_class.find(entity)
  end

  def requested_entity_type
    params[:entity_type].downcase.strip
  end
end
