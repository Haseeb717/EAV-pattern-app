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

    if @battery.save
      handle_successful_creation(@battery)
    else
      handle_creation_failure(@battery)
    end
  end

  # PUT /batteries/:id
  def update
    if @battery.update(battery_params)
      begin
        handle_custom_attributes(@battery)
        render json: battery_with_custom_attributes(@battery), status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity and return
      end
    else
      render json: { errors: @battery.errors.full_messages }, status: :unprocessable_entity
    end
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

  def handle_successful_creation(battery)
    handle_custom_attributes(battery)

    render json: battery_with_custom_attributes(battery), status: :created
  rescue StandardError => e
    logger.error("Failed to handle custom attributes: #{e.message}")
    render json: { error: 'An error occurred while processing custom attributes.' }, status: :unprocessable_entity
  end

  def handle_creation_failure(battery)
    render json: { errors: battery.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_custom_attributes(resource)
    custom_attributes = params[:battery].except(:capacity) # Exclude standard params

    return unless custom_attributes.present?

    begin
      resource.set_custom_attributes(custom_attributes)
    rescue StandardError
    end
  end

  def battery_with_custom_attributes(battery)
    battery.attributes.merge(battery.custom_attributes_hash)
  end
end
