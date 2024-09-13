# frozen_string_literal: true

class BatteriesController < ApplicationController
  before_action :set_battery, only: %i[show update destroy]

  # GET /batteries
  def index
    @batteries = Battery.includes(:custom_attributes).all
    render json: @batteries.map { |battery| battery_with_custom_attributes(battery) }
  end

  # GET /batteries/:id
  def show
    render json: battery_with_custom_attributes(@battery)
  end

  # POST /batteries
  def create
    @battery = Battery.new(battery_params)
    handle_result(@battery.save, @battery, :created) # Using :created for create
  end

  # PUT /batteries/:id
  def update
    handle_result(@battery.update(battery_params), @battery, :ok) # Using :ok for update
  end

  # DELETE /batteries/:id
  def destroy
    @battery.destroy
    head :no_content
  end

  private

  def set_battery
    @battery = Battery.includes(:custom_attributes).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Battery not found' }, status: :not_found
  end

  # Strong parameters for the battery
  def battery_params
    params.require(:battery).permit(:capacity)
  end

  def handle_result(success, battery, success_status)
    if success
      handle_custom_attributes(battery)
      render json: battery_with_custom_attributes(battery), status: success_status
    else
      render json: { errors: battery.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    logger.error("Failed to handle custom attributes: #{e.message}")
    render json: { error: 'An error occurred while processing custom attributes.' }, status: :unprocessable_entity
  end

  def handle_custom_attributes(resource)
    custom_attributes = params[:battery].except(:capacity) # Exclude standard params
    resource.set_custom_attributes(custom_attributes) if custom_attributes.present?
  end

  def battery_with_custom_attributes(battery)
    battery.attributes.merge(battery.custom_attributes_hash)
  end
end
