# app/controllers/batteries_controller.rb
class BatteriesController < ApplicationController
  before_action :set_battery, only: [:show, :update, :destroy]

  # GET /batteries
  def index
    @batteries = Battery.includes(:custom_attributes).all

    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @batteries.map { |battery| battery_with_custom_attributes(battery) } }
    end
  end

  # GET /batteries/:id
  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: battery_with_custom_attributes(@battery) }
    end
  end

  # POST /batteries
  def create
    @battery = Battery.new(battery_params)

    if @battery.save
      handle_custom_attributes(@battery)

      respond_to do |format|
        format.html { redirect_to @battery, notice: 'Battery was successfully created.' }
        format.json { render json: battery_with_custom_attributes(@battery), status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new } # render the form again with errors
        format.json { render json: { errors: @battery.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # PUT /batteries/:id
  def update
    if @battery.update(battery_params)
      handle_custom_attributes(@battery)

      respond_to do |format|
        format.html { redirect_to @battery, notice: 'Battery was successfully updated.' }
        format.json { render json: battery_with_custom_attributes(@battery), status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit } # render the edit form again with errors
        format.json { render json: { errors: @battery.errors.full_messages }, status: :unprocessable_entity }
      end
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
    params.require(:battery).permit(:capacity) # Only allow standard attributes
  end

  def handle_custom_attributes(resource)
    # All other attributes from the battery hash are considered custom attributes
    custom_attributes = params[:battery].except(:capacity) # Exclude standard params

    begin
      resource.set_custom_attributes(custom_attributes)
    rescue => e
      # Handle error and ensure it doesn't interrupt flow
      render json: { error: e.message }, status: :unprocessable_entity and return
    end
  end

  def battery_with_custom_attributes(battery)
    battery.attributes.merge(battery.custom_attributes_hash)
  end
end
